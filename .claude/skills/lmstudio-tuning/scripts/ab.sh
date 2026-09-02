#!/usr/bin/env bash
# ab.sh — A/B two model configurations back to back with the same prompt set and
# append both summaries to records/bench-log.jsonl. Each "config" is a model id plus
# optional lms load flags; the script (re)loads it on the Studio, benches, unloads.
#
#   scripts/ab.sh "<modelA>[|<lms load flags>]" "<modelB>[|<lms load flags>]" [runs=3] [prompt-file] [max_tokens=256]
#   env BENCH_NOCACHE=1 prepends a per-run nonce so true prefill is measured instead of prompt-cache reuse.
#   e.g. scripts/ab.sh "qwen/qwen3.8-27b" "qwen/qwen3.8-27b|--speculative-draft-mtp" 3
set -euo pipefail
A="${1:?config A}"; B="${2:?config B}"; RUNS="${3:-3}"; PF="${4:-}"; MAXTOK="${5:-256}"
HERE="$(cd "$(dirname "$0")" && pwd)"; LOG="$HERE/../records/bench-log.jsonl"; export BENCH_OUT="${BENCH_OUT:-$HERE/../records/out}"
LMS="'/Applications/LM Studio.app/Contents/Resources/app/.webpack/lms'"
run_cfg() {
  local cfg="$1" model flags
  model="${cfg%%|*}"; flags=""; [[ "$cfg" == *"|"* ]] && flags="${cfg#*|}"
  echo "### $model $flags" >&2
  ssh mac-studio "$LMS unload --all >/dev/null 2>&1; $LMS load '$model' --yes $flags" >&2
  BENCH_LABEL="$flags" "$HERE/bench.sh" "$model" "$RUNS" "$PF" "$MAXTOK" | tee /dev/stderr | grep '^SUMMARY ' | sed 's/^SUMMARY //' >> "$LOG"
}
run_cfg "$A"; run_cfg "$B"
echo; echo "last two records:"; tail -2 "$LOG" | python3 -c '
import sys,json
for l in sys.stdin:
    d=json.loads(l)
    print("%-28s %-32s ttft=%ss prefill=%s decode=%s tok/s" % (d["model"], d["label"], d["median_ttft_s"], d["median_prefill_tps"], d["median_decode_tps"]))'
