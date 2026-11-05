# 2026-09-01 — First pass: engine (GGUF vs MLX), MTP, thinking on/off

**Hypotheses:**
1. MTP (`--speculative-draft-mtp`) on qwen/qwen3.8-27b MLX 4bit gives ≥1.3× decode. → **rejected**
2. qwen3.5-35b-a3b (GGUF Q4_K_M, MoE) vs qwen/qwen3-coder-30b (MLX 4bit, MoE) for agent turns. → **tie on speed once thinking is off**
3. Thinking is the dominant cost for short agent turns on Qwen3.5. → **confirmed, `reasoning_effort:"none"` fixes it**

Held constant: prompts `agent-turn.md` / `kg-extract.md`, temperature 0, N=3, warm runs only, Studio idle.
Scripts: `bench.sh` v1 + `ab.sh`; nonce (`BENCH_NOCACHE=1`) added mid-way — rows marked *cached* used identical prompts.

## Configs
| id | model | engine/quant | load flags | notes |
|---|---|---|---|---|
| A | qwen/qwen3.8-27b | MLX 4bit, dense 27B | default (ctx 262144, parallel 4) | CCR background/haiku slot |
| A' | qwen/qwen3.8-27b | same | `--speculative-draft-mtp` | no draft activity in server log |
| B | qwen3.5-35b-a3b | GGUF Q4_K_M, MoE 35B-A3B | JIT default | CCR default |
| B' | qwen3.5-35b-a3b | same | request `reasoning_effort:"none"` | |
| C | qwen/qwen3-coder-30b | MLX 4bit, MoE 30B-A3B | default | non-reasoning |

## Speed (medians of warm runs, from records/bench-log.jsonl)
| cfg | prompt | max_tok | ttft s | prefill tok/s | decode tok/s | completion tok | wall s | effective tok/s (completion/wall) |
|---|---|---|---|---|---|---|---|---|
| A | agent-turn | 256 | 0.57 | 567 *cached* | 38.3 | 255 (all reasoning) | 7.2 | 35 — no answer |
| A | kg-extract | 256 | 1.05 | 236 *cached* | 38.1 | 255 (all reasoning) | — | no answer |
| A' MTP | kg-extract | 256 | 1.02 | 242 *cached* | 37.9 | 255 | — | no change vs A |
| A (code, /api/v0) | fib | 600 | 0.57 | — | 38.3 | 133 (73 reasoning) | 3.5 | 38 |
| B | agent-turn | 1024 | 0.30 | 1049 | 77.1 | 1024 (1024 reasoning) | 13.6 | 75 — **no answer** |
| B' no-think | agent-turn | 1024 | 0.32 | 1011 | 78.0 | 217 (0 reasoning) | 3.1 | **70, answered** |
| C | agent-turn | 1024 | 0.36 | 824 | 90.1 | 243 (0 reasoning) | 3.0 | **81, answered** |

Thinking-off probe (`{"ok":true}` prompt, 35b-a3b): default 375 tok / 367 reasoning; `chat_template_kwargs.enable_thinking=false` no effect; `/no_think` user prefix → 400 reasoning, empty answer; system `/no_think` → 215 reasoning; **`reasoning_effort:"none"` → 6 tok, 0 reasoning.**

## Quality
Not scored yet — outputs were not captured (bench.sh v1 discards content). Next run: save
`content`/`tool_calls` per run to `records/out/` and score B' vs C on the 0–3 rubric.

## Decision
- **Adopt**: turn thinking off for CCR agent traffic (`reasoning_effort:"none"`), otherwise a
  300-token turn costs 10+ s of reasoning before any output. Where: CCR router/transformer
  config for the `lmstudio` provider (claude-studio-launch) — TODO, verify CCR passes it through.
- **Reject** MTP on the MLX qwen3.8-27b quant (no MTP head → no-op). Re-test with a GGUF
  build that ships the MTP head, or Qwen3.6/Gemma-4 MLX variants that keep it.
- **Keep** qwen3.5-35b-a3b as default for now; qwen3-coder-30b is ~15% faster per turn and
  needs no thinking control — promote it if quality scores tie.
- **Always load with `-c`**: default loads reserve full 256K context (≈58 GB est. peak for 27B).

Re-test when: LM Studio / MLX engine upgrade (KV checkpointing), new quant with MTP head,
after adding output capture + quality scoring.
