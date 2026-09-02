# <date> — <topic> (e.g. "MTP on qwen3.8-27b", "GGUF vs MLX for agent turns")

**Hypothesis:** …
**Variable changed:** one lever. **Held constant:** prompt file, max_tokens, temperature 0, N runs, resident set.

## Configs
| id | model | engine/quant | load flags | notes |
|---|---|---|---|---|
| A | | | | |
| B | | | | |

## Speed (paste SUMMARY lines from records/bench-log.jsonl)
```
```
Effective tok/s per agent turn (completion_tokens / wall_s): A … B …

## Quality (0–3 each, per prompt)
| prompt | correctness | format | no-halluc. | tool-call | notes |
|---|---|---|---|---|---|

## Decision
Adopt / reject / needs more data. Applied to: (claude-studio-launch / model-select / LaunchAgent).
Re-test when: (LM Studio or engine upgrade, new quant, new model family).
