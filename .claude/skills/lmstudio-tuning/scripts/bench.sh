#!/usr/bin/env bash
# bench.sh — measure TTFT, prefill tok/s, decode tok/s for a model on LM Studio's
# OpenAI-compatible endpoint. Holds prompt, max_tokens and temperature constant;
# runs N iterations; prints one JSON line per run + a summary. Works from the laptop
# (LAN) or on the Studio itself.
#
#   scripts/bench.sh <model-id> [runs=3] [prompt-file] [max_tokens=256]
#   LMS_URL=http://192.168.1.131:1234  (default)
#   BENCH_LABEL=gguf-fa-on-kvq8        (free text stored with the result)
#   BENCH_EXTRA='{"reasoning_effort":"none"}'  (JSON merged into every request body: per-request levers)
#   BENCH_NOCACHE=1                    (prepend a per-run nonce: measures true prefill instead of prompt-cache reuse;
#                                       default keeps the prompt identical, which is what an agent loop sees)
#
# Cold vs warm: the FIRST run of a non-resident model includes JIT load time — the
# script reports it separately. Compare warm numbers between configurations.
set -euo pipefail
MODEL="${1:?model id}"; RUNS="${2:-3}"; PROMPT_FILE="${3:-}"; MAXTOK="${4:-256}"
LMS_URL="${LMS_URL:-http://192.168.1.131:1234}"
LABEL="${BENCH_LABEL:-}"
HERE="$(cd "$(dirname "$0")" && pwd)"
[ -z "$PROMPT_FILE" ] && PROMPT_FILE="$HERE/../prompts/agent-turn.md"
[ -f "$PROMPT_FILE" ] || { echo "no prompt file: $PROMPT_FILE" >&2; exit 2; }

python3 - "$MODEL" "$RUNS" "$PROMPT_FILE" "$MAXTOK" "$LMS_URL" "$LABEL" "${BENCH_NOCACHE:-0}" "${BENCH_EXTRA:-{\}}" <<'PY'
import uuid, json, sys, time, urllib.request, statistics, datetime
model, runs, pf, maxtok, url, label = sys.argv[1], int(sys.argv[2]), sys.argv[3], int(sys.argv[4]), sys.argv[5], sys.argv[6]
prompt = open(pf).read()
nocache = sys.argv[7] == "1"
extra = json.loads(sys.argv[8] or "{}")

def resident():
    try:
        with urllib.request.urlopen(url + "/api/v0/models", timeout=5) as r:
            for m in json.load(r).get("data", []):
                if m.get("id") == model: return m.get("state") == "loaded"
    except Exception: pass
    return None

def one():
    ptext = (f"[bench nonce {uuid.uuid4().hex}]\n" + prompt) if nocache else prompt
    body = {"model": model, "messages": [{"role": "user", "content": ptext}], **extra,
            "max_tokens": maxtok, "temperature": 0, "stream": True,
            "stream_options": {"include_usage": True}}
    req = urllib.request.Request(url + "/v1/chat/completions", data=json.dumps(body).encode(),
                                 headers={"Content-Type": "application/json"})
    t0 = time.time(); first = None; n = 0; usage = None
    with urllib.request.urlopen(req, timeout=900) as r:
        for line in r:
            line = line.decode().strip()
            if not line.startswith("data:"): continue
            b = line[5:].strip()
            if b == "[DONE]": break
            d = json.loads(b)
            if d.get("usage"): usage = d["usage"]
            ch = d.get("choices") or []
            if ch:
                delta = ch[0].get("delta", {})
                if delta.get("content") or delta.get("reasoning_content"):
                    if first is None: first = time.time()
                    n += 1
    t1 = time.time()
    pt = (usage or {}).get("prompt_tokens"); ct = (usage or {}).get("completion_tokens") or n
    ttft = (first - t0) if first else None
    return {"ttft_s": round(ttft, 3) if ttft else None,
            "prefill_tps": round(pt / ttft, 1) if (pt and ttft) else None,
            "decode_tps": round(ct / (t1 - first), 1) if (first and t1 > first) else None,
            "prompt_tokens": pt, "completion_tokens": ct,
            "reasoning_tokens": ((usage or {}).get("completion_tokens_details") or {}).get("reasoning_tokens"),
            "wall_s": round(t1 - t0, 3)}

was_loaded = resident()
out = []
for i in range(runs):
    r = one(); r.update({"run": i + 1, "cold": (i == 0 and was_loaded is False)})
    print(json.dumps(r)); out.append(r)
warm = [r for r in out if not r["cold"]] or out
def med(k):
    v = [r[k] for r in warm if r.get(k) is not None]
    return round(statistics.median(v), 2) if v else None
summary = {"model": model, "label": label, "ts": datetime.datetime.now().isoformat(timespec="seconds"),
           "runs": runs, "warm_runs": len(warm), "prompt_file": pf.split("/")[-1], "max_tokens": maxtok, "extra": extra, "nocache": nocache,
           "median_ttft_s": med("ttft_s"), "median_prefill_tps": med("prefill_tps"),
           "median_decode_tps": med("decode_tps"), "prompt_tokens": warm[0].get("prompt_tokens")}
print("SUMMARY " + json.dumps(summary))
PY
