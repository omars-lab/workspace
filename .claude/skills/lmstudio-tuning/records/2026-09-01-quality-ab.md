# 2026-09-01 — Quality A/B: qwen3.5-35b-a3b (GGUF, thinking off) vs qwen3-coder-30b (MLX)

Follow-up to `2026-09-01-first-pass.md`, which showed the two are a **speed tie** once thinking
is off (3.1 s vs 3.0 s per agent turn). This record decides on quality. Task: T58.

## Hypothesis

With `reasoning_effort:"none"`, the MoE reasoning model (35B-A3B) loses its edge and the
coder-tuned MLX model produces better tool calls and better KG extraction.

## Configs

| key | model | engine / quant | request extras | runs |
|---|---|---|---|---|
| A | `qwen3.5-35b-a3b` | llama.cpp GGUF Q4_K_M, ctx 131072, parallel 4 | `reasoning_effort:"none"`, temp 0, nonce | 2 × 2 prompts |
| B | `qwen/qwen3-coder-30b` | MLX 4bit | same | 2 × 2 prompts |

Prompts: `prompts/agent-turn.md` (tool-call next step) and `prompts/kg-extract.md` (KG JSON).
Raw outputs: `records/out/20260901T2254*-*.json`; speed lines: `bench-log.jsonl` label
`quality-ab reasoning_effort=none`.

## Speed (warm, nonce'd, medians)

| key | prompt | ttft s | prefill tok/s | decode tok/s | completion tok | wall s |
|---|---|---|---|---|---|---|
| A | agent-turn | 0.32 | 1011 | 78 | 217 | 3.1 |
| B | agent-turn | 0.36 | 824 | 90 | 240–246 | 3.2 |
| A | kg-extract | 0.27 | ~900 | 78 | 757–822 | 10.1–10.8 |
| B | kg-extract | ~0.3 | ~800 | 90 | 748–788 | 8.8–9.2 |

## Quality scores (manual, 0–3 each: correctness / format / hallucination-free / tool-call validity)

| key | prompt | corr | fmt | halluc-free | tool | total | notes |
|---|---|---|---|---|---|---|---|
| A | agent-turn | 3 | 3 | 3 | 3 | **12** | Pure JSON `{tool, arguments}`; correct `--json` patch incl. `import json` and help text; byte-identical across both runs |
| B | agent-turn | 3 | 2 | 3 | 2 | 10 | Two sentences of prose then JSON (allowed); **schema drift**: run 1 used `args`, run 2 `arguments` → a strict tool parser breaks on one of them |
| A | kg-extract | 2 | 3 | 3 | — | 8/9 | 9 entities, 9–10 relations, numeric ids, evidence quoted verbatim. **Missed `competes_with`** (Trino/Snowflake), labelled "advises" as `works_at` / `related_to`, missed the customer relation |
| B | kg-extract | 3 | 3 | 2 | — | 8/9 | 9 entities, name ids, **found `competes_with`** (run 2: Trino→Snowflake, the faithful reading) and Snowflake→Stockholm; evidence strings are **paraphrased** ("Anders Falk was CTO at Kvarn Bank") rather than quoted; also missed the customer relation |

Rubric detail: hallucination-free = evidence must be a substring of the source; paraphrase costs a point, fabrication would cost three.

## Decision

- **Agent turns (the CCR workload): keep `qwen3.5-35b-a3b` as the CCR default.** Same speed,
  stricter JSON, stable schema. Its thinking is now switched off at the router (T57, below), so
  the 13.6 s thinking-on turn from the first pass no longer applies to CCR sessions.
- **KG extraction: no change to the pipeline model yet.** Tie on totals with opposite failure
  modes (A: recall, B: verbatim evidence). Re-run with ≥ 5 texts and the Qwen3.6 MTP GGUF once
  T59 lands; the deciding factor is whether the pipeline needs quotable evidence (→ A) or
  relation recall (→ B).
- Confidence: **low** (n = 2 runs × 1 prompt per task). Enough to not switch the default, not
  enough to rank the models in general.

## Applied

- T57: CCR now injects `reasoning_effort:"none"` for every `lmstudio` request via the provider's
  `extraBody` (`{"default": {...}}`) in `config.sqlite`. Proof: `ccr default-claude-code cli -- -p`
  returned `OK` with `output_tokens: 2, thinking_tokens: 0`; the Studio server log shows the
  request body ending in `"reasoning_effort": "none"`. Recipe in the `claude-studio-launch` skill.
- T60: standard load flags (`-c 131072 --parallel 4`, no TTL) enforced by the
  `com.automationhub.lmstudio-warm` LaunchAgent on the Studio (automation-hub PR #9).

## Re-test when

- LM Studio / llama.cpp engine upgrade, or a new Qwen3.6 / coder release.
- After T59 (MTP build) — MTP only pays off on low-entropy code/JSON, exactly these prompts.
- Any change to `prompts/` (add files, never edit, so this table stays comparable).
