# Sources — lmstudio-tuning

## LM Studio features and CLI
- LM Studio blog (0.4.0 parallel requests + continuous batching; 0.4.14 MTP stable; MLX engine 1.8.5 KV-cache checkpointing; 0.3.10 speculative decoding; 0.3.7 KV-cache quant) — https://lmstudio.ai/blog
- `lms load` reference — https://lmstudio.ai/docs/cli/load
- LM Studio tips & tricks (settings table: flash attention, KV Q8_0, batch, TTL) — https://insiderllm.com/guides/lm-studio-tips-and-tricks/
- "Cannot truncate prompt" n_keep/n_ctx fix — https://ianlpaterson.com/blog/lm-studio-fix-cannot-truncate-prompt-n-keep-n-ctx/

## MLX vs GGUF on Apple Silicon
- famstack: GGUF vs MLX, 57 tok/s on screen vs 3 tok/s in practice — https://famstack.dev/guides/mlx-vs-gguf-apple-silicon/
- famstack part 2: isolating variables (bf16, prefill chunk, prompt cache) — https://famstack.dev/guides/mlx-vs-gguf-part-2-isolating-variables/
- yage.ai: MLX vs llama.cpp benchmarks by chip, MoE vs dense, long context — https://yage.ai/share/mlx-apple-silicon-en-20260331.html
- Apple Silicon inference optimization guide — https://blog.starmorph.com/blog/apple-silicon-llm-inference-optimization-guide
- KV cache, flash attention internals on Apple Silicon — https://vijay.eu/co-authored/llm-inference-internals-apple-silicon/
- SitePoint local LLMs on Apple Silicon 2026 — https://www.sitepoint.com/local-llms-apple-silicon-mac-2026/

## Speculative decoding / MTP
- Does speculative decoding speed up Mac LLMs (MLX yes, llama.cpp-Metal no) — https://modelfit.io/blog/speculative-decoding-mac-llm/
- Speculative decoding setup + when it backfires (acceptance, VRAM, entropy) — https://runaihome.com/blog/speculative-decoding-llama-cpp-local-llm-setup-2026/
- MTP on Apple Silicon (mlx-optiq) — https://mlx-optiq.com/docs/mtp
- LM Studio adds MTP support — https://www.besthub.dev/articles/lm-studio-adds-mtp-support-boosting-qwen3-6-35b-to-130-tokens-s-6c00e146e63a

## Benchmark methodology
- CanItRun: benchmark your setup (TTFT / prefill / decode, hold variables) — https://canitrun.dev/guides/benchmark-your-setup/
- Local AI Master: tokens/sec, TTFT — https://localaimaster.com/blog/benchmark-local-ai-setup
- Benchmark before you trust: decision-record approach — https://bmdpat.com/blog/local-llm-benchmark-decision-record-2026
- Bench360 (arXiv 2511.16682) — https://arxiv.org/pdf/2511.16682
- llama-bench vs alternatives — https://www.promptquorum.com/prompt-bites/best-local-llm-benchmarking-tool
- lm-evaluation-harness — https://github.com/EleutherAI/lm-evaluation-harness ; promptfoo — https://www.promptfoo.dev

## Leaderboards and discovery
- LiveBench https://livebench.ai · Aider Polyglot https://aider.chat/docs/leaderboards/ · SWE-bench https://www.swebench.com
- BFCL https://gorilla.cs.berkeley.edu/leaderboard.html · LiveCodeBench https://livecodebench.github.io
- Artificial Analysis https://artificialanalysis.ai · LMArena https://lmarena.ai
- Vellum open LLM leaderboard https://www.vellum.ai/open-llm-leaderboard · HF Open LLM Leaderboard
- StationX monthly "best local LLM" methodology — https://app.stationx.net/articles/best-local-llm
- Authoritative leaderboards compared — https://www.unifyllm.com/blog/authoritative-llm-leaderboards-2026/
- LM Studio model catalog https://lmstudio.ai/models · r/LocalLLaMA https://www.reddit.com/r/LocalLLaMA/

## Sub-agent authoring
- Claude Code subagents reference — https://code.claude.com/docs/en/sub-agents
