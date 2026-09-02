---
name: lmstudio-tuning
description: Tune LM Studio on the Mac Studio (M3 Ultra, 96 GB) to balance speed and quality for local models — the lever table (engine, quant, context, flash attention, KV-cache quant, speculative decoding/MTP, parallel), a fixed-prompt A/B protocol with scripts that measure TTFT / prefill / decode tok/s, the leaderboards and places to web-search for "models of our time", and a decision-record format so results accumulate. Use when asking "is there a faster/better model or setting for the Studio", before switching the CCR default model, or whenever a local session feels slow or low-quality.
---

# LM Studio tuning loop (mac-studio)

Goal: pick and configure local models with **measured numbers on our hardware**, not blog
claims. The loop is *inspect → research → hypothesize → A/B → decide → record*. The
`lmstudio-tuner` sub-agent runs this loop end to end; this skill is its reference.

Plan of record (objectives, baseline, open questions, sources):
`.claude/plans/lmstudio-tuning.md`. Launch path + CCR isolation: **claude-studio-launch**.
Model *discovery* for the knowledge pipeline: **knowledge-manager:model-select**.

## 0. Baseline facts (re-verify with step 1 — they drift)

| | |
|---|---|
| Studio | M3 Ultra, 96 GB unified; ssh `mac-studio`; API `http://192.168.1.131:1234` |
| LM Studio | 0.4.23; engines llama.cpp-Metal 2.31 (GGUF) + MLX 1.11 (MLX), chosen by model format |
| `lms` | `/Applications/LM Studio.app/Contents/Resources/app/.webpack/lms` |
| RAM rule | resident models ≤ ~75% of RAM (~72 GB); one big model + one small draft is fine |
| Interactive bar | > 30 tok/s decode feels live; 8–30 is batch-only; TTFT < 2 s warm for agent loops |

Apple Silicon is memory-bandwidth-bound: **MoE models** (35B-A3B, 30B-A3B) decode near
small-model speed at large-model quality, which is why they are our defaults.

## 1. Inspect (always first, read-only)

```bash
LMS="'/Applications/LM Studio.app/Contents/Resources/app/.webpack/lms'"
ssh mac-studio "$LMS ls --json" | python3 -c 'import json,sys; [print(m["modelKey"], m["format"], (m.get("quantization") or {}).get("name"), m.get("sizeBytes",0)//2**30,"GB") for m in json.load(sys.stdin)]'
ssh mac-studio "$LMS ps"                       # what is resident + context + parallel + TTL
ssh mac-studio "$LMS runtime ls"               # selected engine versions
curl -s http://192.168.1.131:1234/api/v0/models | python3 -c 'import json,sys; [print(m["id"], m.get("state")) for m in json.load(sys.stdin)["data"] if m["type"]=="llm"]'
ssh mac-studio "$LMS load <model> --estimate-only -c 65536"   # memory before committing
```

`lms ps` shows only *resident* models; LM Studio JIT-loads anything in `ls` on first request
(that first request pays the load time — see cold vs warm below).

## 2. Levers

| Lever | Where | What it does / our expectation (verify) |
|---|---|---|
| **Engine: GGUF (llama.cpp) vs MLX** | model format at `lms get --gguf|--mlx` | MLX decodes ≈1.4–1.8× faster (dense), up to ≈3× (MoE); llama.cpp prefills faster and is steadier past ~30K ctx. Agent loops are prefill-heavy (short answers, growing context) → GGUF often wins *effective* tok/s. |
| **Quantization** | `lms get model@q8_0` / `@q4_k_m` / MLX `4bit`/`8bit` | Q4_K_M is the speed default; Q8/8bit costs ~2× RAM for accuracy on structured extraction. Test on `kg-extract.md`. |
| **Context length** | `lms load -c N` | KV cache grows with N; keep ≤ ~140K; only allocate what the session needs. |
| **Flash Attention** | GUI per-model default (no CLI flag found) | Set explicitly **On** (not Auto) for GGUF; speeds prefill, required for KV quant. |
| **KV-cache quant** | GUI per-model default | **Q8_0** on GGUF: less RAM, faster prefill, negligible quality loss. MLX KV quant had model compat issues — test. |
| **Prefill / eval batch** | GUI | 512 → 2048–8192 reported ≈1.5× prefill on MLX. |
| **Speculative decoding: MTP** | `lms load --speculative-draft-mtp` | Qwen3.5/3.6/Gemma-4 ship MTP heads. Reported ≈1.4–2.6× via MLX; a **net loss on llama.cpp-Metal**. Only pays with acceptance ≥ ~60–70% and low-entropy output (code, JSON). |
| **Speculative decoding: draft model** | `--speculative-draft-simple --speculative-draft-model <0.5–1B same family>` + `--speculative-draft-max-tokens 2–8` | Same caveats; draft must fit in RAM alongside target. |
| **Parallel** | `lms load --parallel N` | Continuous batching (0.4.0+). Raises total throughput for fan-out sub-agents, lowers per-stream speed. Sweep 1/2/4/8. |
| **TTL / keep loaded** | `--ttl s` | Set long TTL on the CCR default so the first turn of a session isn't a cold load. |
| **Per-request** | API | `temperature 0` for tools/JSON; `max_tokens`; `response_format` JSON schema. |

## 3. A/B protocol (the only part that produces trustworthy numbers)

Rules: same prompt file, same `max_tokens`, `temperature 0`, N ≥ 3 runs, **compare warm
runs** (the first request to a non-resident model includes JIT load; the script flags it),
change **one lever at a time**, keep the Studio otherwise idle (no other model resident
unless that is the variable).

```bash
S=~/.claude/skills/lmstudio-tuning/scripts
$S/bench.sh qwen3.5-35b-a3b 3                              # TTFT / prefill / decode, JSON per run + SUMMARY
$S/bench.sh qwen3.5-35b-a3b 3 ../prompts/kg-extract.md 512
$S/ab.sh "qwen/qwen3.8-27b" "qwen/qwen3.8-27b|--speculative-draft-mtp" 3   # loads each config, benches, logs
```

Both append `SUMMARY` lines to `records/bench-log.jsonl`. Effective throughput for an agent
turn = `completion_tokens / wall_s`, which is what the user feels; decode tok/s alone
flatters MLX. Quality is scored by hand on the fixed prompts (see `prompts/README.md`):
correctness, format compliance, no hallucination, valid tool call, 0–3 each.

Tools worth reaching for beyond the scripts: `llama-bench` (raw prefill/decode isolation,
GGUF only), `promptfoo` (prompt-set regression across models), `lm-evaluation-harness`
(standard tasks), `aider --model` on a small repo for a real agentic edit loop.

## 4. Research: where to look for "models of our time"

Check monthly, or before any switch. Prefer contamination-resistant, verifiable boards.

| Question | Source |
|---|---|
| Agentic coding | SWE-bench Verified https://www.swebench.com ; Aider Polyglot https://aider.chat/docs/leaderboards/ |
| Tool / function calling | BFCL https://gorilla.cs.berkeley.edu/leaderboard.html |
| General, fresh questions | LiveBench https://livebench.ai ; LiveCodeBench https://livecodebench.github.io |
| Open-weight cross-view | https://www.vellum.ai/open-llm-leaderboard ; HF Open LLM Leaderboard |
| Speed / price / context | https://artificialanalysis.ai |
| Human preference | https://lmarena.ai |
| Apple-Silicon reality | r/LocalLLaMA ; famstack.dev MLX-vs-GGUF series ; yage.ai MLX benchmarks |
| What LM Studio can run now | https://lmstudio.ai/models (staff picks; `lms get` names) ; https://lmstudio.ai/blog (engine features) |
| Embeddings | MTEB https://huggingface.co/spaces/mteb/leaderboard |

Web-search templates: `"<model>" MLX M3 Ultra tok/s`, `"<model>" LM Studio MTP speculative`,
`site:reddit.com/r/LocalLLaMA "<model>" apple silicon`, `"<model>" BFCL OR "Aider polyglot"`.
Fit filter: params × bits/8 × ~1.15 ≤ 72 GB; MoE preferred; 256K-class context; MTP head
is a plus; must exist as GGUF *or* MLX in the LM Studio catalog.

## 5. Decide and record

Write `records/YYYY-MM-DD-<topic>.md` using `records/TEMPLATE.md`: hypothesis, configs, the
`bench-log.jsonl` lines, quality scores, decision, and what to re-test when. Then apply the
decision where it lives:
- CCR default model / tiers → `claude-studio-launch` skill (SQLite provider + `~/.claude-studio/settings.json`).
- Knowledge pipeline models → `knowledge-manager:model-select`.
- Long-lived load flags (TTL, parallel, MTP) → the `claude-studio` function or a LaunchAgent on the Studio.

## Gotchas collected so far

- **Thinking is the biggest lever for agent turns.** Qwen3.5 reasoning models burn 300–1000+
  `reasoning_tokens` before a 5-token answer. `"reasoning_effort": "none"` in the request body
  disables it (measured: 375 → 6 completion tokens); `chat_template_kwargs.enable_thinking`
  and `/no_think` do **not** work through LM Studio's API. Bench with
  `BENCH_EXTRA='{"reasoning_effort":"none"}'`; for CCR sessions the router must add it.
- `--speculative-draft-mtp` only works "when supported by the model": an MLX 4bit conversion
  without the MTP head silently loads without it (no draft lines in the server log,
  identical tok/s). Check the model card for MTP weights before testing.
- `lms load` defaults to the model's **full** context (256K for Qwen3.5 → ~58 GB estimated
  peak for the 27B) and `--parallel 4`. Always pass `-c` for the session size you need.
- Same-prompt repeats hit the prompt cache: warm "prefill" of 5000+ tok/s is cache reuse.
  Use `BENCH_NOCACHE=1` to measure real prefill (35B-A3B GGUF ≈ 1000 tok/s; MLX ≈ 800).
- Server log: `~/.lmstudio/server-logs/YYYY-MM/YYYY-MM-DD.N.log` on the Studio (has
  `context_fit` lines with estimated peak RAM per load; no speculative acceptance stats).

- Reasoning output arrives in `reasoning_content`; usage reports `reasoning_tokens` separately — budget `max_tokens` for both when thinking is on.
- Speculative decoding hard-froze at 120K+ context in the field; keep ≤ 140K with it on.
- Prompt caching in LM Studio's MLX runtime was reported broken for Qwen3.5 (huge effective
  slowdown on multi-turn); MLX engine ≥ 1.8.5 adds KV checkpointing — re-test after upgrades.
- `lms server` binds `127.0.0.1` unless started with `--bind 0.0.0.0` (ours is LAN-bound).
- "Cannot truncate prompt" (`n_keep`/`n_ctx`) = context too small for the system prompt; raise `-c`.
