# LM Studio tuning loop on mac-studio: a skill + sub-agent to balance speed and quality

Branch: `feat/claude-studio-ccr-isolation` (workspace repo). Started 2026-09-01.
Companion skill: `claude-studio-launch` (launch path + CCR isolation). This plan owns the
*tuning* side: how we pick, configure, measure, and A/B local models "of our time".

## Objectives

1. A repeatable **tuning loop** (inspect → research → hypothesize → A/B → decide → record) that
   any session can run against the Studio, with no guessing about what a setting does.
2. A **`lmstudio-tuning` skill** holding the lever table, the bench protocol, the leaderboard /
   search list, and a decision-record template so results accumulate instead of being re-derived.
3. A **`lmstudio-tuner` sub-agent** that drives the skill end to end and writes a decision record.
4. Every recommendation grounded in **measured numbers on our hardware**, not blog claims.

## Hardware and software baseline (measured 2026-09-01)

| | |
|---|---|
| Machine | Mac Studio, Apple M3 Ultra, 96 GB unified (ssh `mac-studio`, `192.168.1.131`) |
| LM Studio | 0.4.23+1, server on :1234 (LAN), `lms` CLI commit 07b7252 |
| Engines selected | llama.cpp Metal 2.31.2 (GGUF), MLX 1.11.0 (MLX) — both installed, auto-picked by model format |
| RAM budget rule | keep resident models under ~75% (~72 GB) |

Installed models (format / quant / size):
- `qwen3.5-35b-a3b` GGUF Q4_K_M 20 GB (MoE, ~3B active) — current default via CCR
- `qwen/qwen3-coder-30b` MLX 4bit 16 GB (MoE, tool-calling)
- `qwen/qwen3.8-27b` MLX 4bit 14 GB (dense; the MLX 4bit quant does **not** carry a usable MTP head) — haiku slot
- `qwen3.5-9b` GGUF Q4_K_M 6 GB; `mistralai/ministral-3-14b-reasoning` GGUF 8 GB
- `mistralai/devstral-small-2-2512` MLX 13 GB; `openai/gpt-oss-20b` MLX MXFP4 11 GB
- embeddings: nomic-embed-text-v1.5, qwen3-embedding-8b, embeddinggemma-300m

First measurement (`qwen/qwen3.8-27b`, cold — model was not resident, so TTFT includes JIT load):
TTFT 11.1 s, decode ≈ 29 tok/s, usage reports `reasoning_tokens` separately. This is the number
the bench script must beat / explain; warm TTFT is the real metric.

## Levers we can actually turn

Via `lms load` (scriptable, per-load): `--gpu off|max|0..1`, `-c/--context-length`,
`--parallel N`, `--ttl s`, `--identifier`, `--estimate-only`, and speculative decoding:
`--speculative-draft-mtp` (models with MTP heads: Qwen3.5/3.6, Gemma 4), or
`--speculative-draft-simple --speculative-draft-model <small model>`, plus
`--speculative-draft-max-tokens`, `--speculative-draft-min-tokens`,
`--speculative-draft-min-continue-probability`.
Via `lms get`: `--mlx` / `--gguf`, and `model@quant` (e.g. `qwen/qwen3.5-9b@q8_0`).
Via GUI per-model defaults only (no CLI flag found): Flash Attention, KV-cache quant (Q8_0),
prefill/eval batch size, mmap/mlock, keep-in-memory.
Via API per request: temperature, `max_tokens`, `response_format`, `stream_options.include_usage`.

## Findings from research (what to expect, to be verified on our box)

- **Decode**: MLX beats raw llama.cpp ≈1.4–1.8× on dense, up to ≈3× on MoE. **Prefill**:
  llama.cpp wins; MLX can spend most of its time in prefill on short-answer agent turns.
  At 30K+ context MLX decode reported ≈50% slower than llama.cpp with Flash Attention.
- **Agentic gotcha**: with Qwen3.5 in LM Studio's MLX runtime, prompt caching was reported
  broken → "57 tok/s on screen, 3 tok/s effective" at 8.5K ctx. GGUF recommended for agent
  loops there; MLX engine 1.8.5+ adds KV-cache checkpointing aimed at exactly this. Must A/B.
- **Speculative decoding**: gains only through MLX on Apple Silicon (Qwen3.6-27B MTP ≈1.4–2.6×);
  on llama.cpp Metal it was a net loss (−11…−24%). Acceptance rate below ~60–70% = loss;
  high-entropy (creative) text craters it; it optimizes single-stream latency, not batch.
- **GGUF settings**: Flash Attention explicitly ON, KV cache Q8_0; prefill chunk 512→8192 ≈1.5×.
- **Long context**: keep ≤ ~140K; speculative decoding reported hard-freezing at 120K+.
- **Interactivity threshold**: >30 tok/s feels interactive; 8–30 batch-only.
- **Leaderboards that resist gaming**: LiveBench, Aider Polyglot, SWE-bench Verified, BFCL
  (tool calling), LiveCodeBench; Artificial Analysis for speed/price; LMArena for preference;
  the only ungameable one is a private ~20-prompt eval on our own tasks.

## Tasks (mirrors the session task list)

- [x] T50 Research levers + leaderboards (sources below)
- [x] T51 Inspect `lms` CLI, engines, model formats, streaming usage fields
- [x] T55 Write this plan
- [x] T52 Write `lmstudio-tuning` skill → `.claude/skills/lmstudio-tuning/` (SKILL.md, SOURCES.md,
      `scripts/bench.sh`, `scripts/ab.sh`, `prompts/`, `records/TEMPLATE.md`)
- [x] T53 Write `lmstudio-tuner` sub-agent → `.claude/agents/lmstudio-tuner.md` (preloads skill)
- [x] T54 Run the scripts for real → `records/2026-09-01-first-pass.md` + `records/bench-log.jsonl`
- [x] T56 Commit skill + agent + plan; PR → https://github.com/omars-lab/workspace/pull/2
- [x] T57 CCR sends `reasoning_effort:"none"` to the `lmstudio` provider via provider `extraBody`
      (`{"default":{...}}`, deep-merged by `@the-next-ai/ai-gateway`); proven: `-p` run → `OK`,
      `output_tokens 2, thinking_tokens 0`, Studio log body ends with the field. Recipe in `claude-studio-launch`
- [x] T58 bench.sh captures outputs (`BENCH_OUT`, `BENCH_NOCACHE`); scored 35b-a3b vs coder-30b →
      `records/2026-09-01-quality-ab.md`: keep 35b-a3b as CCR default (12 vs 10 on agent-turn), KG tie
- [ ] T59 Re-test MTP with a quant that ships the MTP head: `unsloth/Qwen3.6-35B-A3B-MTP-GGUF`
      UD-Q4_K_M (21.1 GB) downloading to the Studio (`lms get` can't fetch non-catalog repos → curl into
      `~/.lmstudio/models/unsloth/…`); then A/B `--speculative-draft-mtp` on agent-turn/kg-extract
- [x] T60 Standard load: `-c 131072 --parallel 4`, no TTL, enforced by LaunchAgent
      `com.automationhub.lmstudio-warm` (automation-hub `scripts/lmstudio/`, PR https://github.com/omars-lab/automation-hub/pull/9)

## Measured findings (2026-09-01, details in `records/2026-09-01-first-pass.md`)

| config | prompt | ttft s | prefill tok/s | decode tok/s | per-turn wall s | answered? |
|---|---|---|---|---|---|---|
| qwen3.8-27b MLX 4bit | agent-turn | 0.57 | 567 (cached) | 38.3 | 7.2 @256 tok | no (all reasoning) |
| qwen3.8-27b + `--speculative-draft-mtp` | kg-extract | 1.02 | 242 (cached) | 37.9 | — | no change → MTP no-op on this quant |
| qwen3.5-35b-a3b GGUF Q4_K_M (thinking on) | agent-turn | 0.30 | 1049 | 77.1 | 13.6 @1024 tok | **no** (1024 reasoning tokens) |
| qwen3.5-35b-a3b + `reasoning_effort:"none"` | agent-turn | 0.32 | 1011 | 78.0 | **3.1** | yes, 217 tok |
| qwen3-coder-30b MLX 4bit | agent-turn | 0.36 | 824 | 90.1 | **3.0** | yes, 243 tok |
| CCR → 35b-a3b, `extraBody` reasoning_effort none (T57) | 20K-tok Claude Code system prompt | — | 1326 (server log) | — | 15.6 total, 2 output tok, 0 thinking | yes (`OK`) |

- **Thinking dominates agent-turn latency**; `reasoning_effort:"none"` is the only switch that
  works through LM Studio's API (`enable_thinking` kwarg and `/no_think` do not). → T57.
- GGUF 35B-A3B vs MLX coder-30B is a **wash on speed** once thinking is off (3.1 vs 3.0 s per
  turn); MLX decodes ~15% faster, GGUF prefills ~25% faster. Quality decides → T58.
- `lms load` defaults: full 256K context + `--parallel 4`; server log `context_fit` estimated
  57.6 GB peak for the 27B. Pass `-c`. → T60 done: LaunchAgent keeps 35b-a3b at 131072/4.
- CCR v3 has no plugin-transformer API; the supported hook is provider `extraBody` /
  `extraHeaders` (`default` + per-model) and declarative `providerPlugins` (`bodySet`/`bodyMerge`).
  A 20K-token Claude Code system prompt prefills at ~1330 tok/s on the 35B-A3B → ~15 s first turn;
  prompt cache makes later turns cheap.
- Same-prompt repeats hit the prompt cache (5000+ tok/s "prefill"); bench with `BENCH_NOCACHE=1`.
- Server logs: `~/.lmstudio/server-logs/YYYY-MM/`; no speculative acceptance stats exposed, and
  `/api/v0` `stats` only has tok/s, TTFT, generation_time, stop_reason.

## Open questions to answer with data

1. ~~GGUF 35b-a3b vs MLX coder-30b~~ answered (T58): agent-turn 35b-a3b 12/12 vs coder-30b 10/12
   (coder drifts `args`/`arguments`); KG extraction 8/9 each with opposite failure modes
   (35b-a3b misses `competes_with`, coder paraphrases evidence). n=2 — rerun with ≥5 texts.
2. ~~MTP on qwen3.8-27b MLX~~ answered: no-op (quant lacks MTP head). Re-ask with a GGUF/MTP build (T59).
3. Is a `@q8_0` GGUF of 35b-a3b (≈40 GB) worth it vs Q4_K_M for KG-extraction accuracy?
4. `--parallel` sweet spot when CCR fans out sub-agents (2 / 4 / 8).
5. Is there a REST or config-file path to set Flash Attention / KV quant without the GUI?

## Sources

Tuning / engines
- https://lmstudio.ai/blog (0.4.0 continuous batching; 0.4.14 MTP stable; MLX engine 1.8.5 KV checkpointing)
- https://lmstudio.ai/docs/cli/load
- https://famstack.dev/guides/mlx-vs-gguf-apple-silicon/ and https://famstack.dev/guides/mlx-vs-gguf-part-2-isolating-variables/
- https://yage.ai/share/mlx-apple-silicon-en-20260331.html
- https://blog.starmorph.com/blog/apple-silicon-llm-inference-optimization-guide
- https://vijay.eu/co-authored/llm-inference-internals-apple-silicon/
- https://insiderllm.com/guides/lm-studio-tips-and-tricks/
- https://modelfit.io/blog/speculative-decoding-mac-llm/
- https://runaihome.com/blog/speculative-decoding-llama-cpp-local-llm-setup-2026/
- https://mlx-optiq.com/docs/mtp
- https://ianlpaterson.com/blog/lm-studio-fix-cannot-truncate-prompt-n-keep-n-ctx/

Benchmark methodology
- https://canitrun.dev/guides/benchmark-your-setup/
- https://localaimaster.com/blog/benchmark-local-ai-setup
- https://bmdpat.com/blog/local-llm-benchmark-decision-record-2026
- https://arxiv.org/pdf/2511.16682 (Bench360)
- https://github.com/EleutherAI/lm-evaluation-harness ; https://www.promptfoo.dev

Leaderboards / model discovery
- https://livebench.ai ; https://aider.chat/docs/leaderboards/ ; https://www.swebench.com
- https://gorilla.cs.berkeley.edu/leaderboard.html (BFCL) ; https://livecodebench.github.io
- https://artificialanalysis.ai ; https://lmarena.ai ; https://huggingface.co/spaces/open-llm-leaderboard/open_llm_leaderboard
- https://www.vellum.ai/open-llm-leaderboard ; https://app.stationx.net/articles/best-local-llm
- https://lmstudio.ai/models ; https://huggingface.co/models?sort=trending ; https://www.reddit.com/r/LocalLLaMA/

Artifacts produced
- Skill: `.claude/skills/lmstudio-tuning/` (SKILL.md · SOURCES.md · scripts/bench.sh · scripts/ab.sh · prompts/ · records/)
- Sub-agent: `.claude/agents/lmstudio-tuner.md`
- Records: `records/2026-09-01-first-pass.md` (speed), `records/2026-09-01-quality-ab.md` (quality + decisions), raw outputs in `records/out/`
- Studio LaunchAgent: `automation-hub/scripts/lmstudio/` (PR #9)
- PRs: workspace https://github.com/omars-lab/workspace/pull/2 · automation-hub https://github.com/omars-lab/automation-hub/pull/9
- Companion: `.claude/skills/claude-studio-launch/` (CCR isolation, provider repair)

Sub-agent authoring
- https://code.claude.com/docs/en/sub-agents
