Fixed prompt set for A/B runs. Keep these files stable; add new ones rather than editing,
so historical records in `records/bench-log.jsonl` stay comparable.

- `agent-turn.md` — ~450 tokens, tool-calling next-step; the shape of a Claude Code turn.
- `kg-extract.md` — ~250 tokens, structured KG extraction; the knowledge-graph workload.
- (add) `long-context.md` — paste a 30–60K-token transcript to test the long-context cliff.

Quality scoring (manual, 0–3 each): correctness, format compliance, hallucination-free,
tool-call validity. Record scores in the decision record, not the jsonl.
