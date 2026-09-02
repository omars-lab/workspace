---
name: claude-studio-launch
description: Launch a Claude Code session wired to the local LM Studio model on mac-studio via CCR (Claude Code Router), ISOLATED into ~/.claude-studio/ so your global ~/.claude/ config is never touched. Use when you want an agentic coding session powered by your local M3 Ultra (qwen3.5-35b-a3b or qwen/qwen3-coder-30b) instead of Claude Pro. Contains the validated isolation fix and launch commands — tested end-to-end.
---

# Launch an isolated Claude Code session via CCR → LM Studio on mac-studio

Run Claude Code powered by your local M3 Ultra Mac Studio, with CCR (Claude Code Router)
proxying between `claude` and LM Studio's OpenAI-compatible API — **without CCR ever
mutating your global `~/.claude/` config.**

> **The whole point of this skill is the isolation.** Out of the box, CCR takes over
> `~/.claude/settings.json` (see "Why isolation is needed" below). This skill pins CCR to
> a separate config home, `~/.claude-studio/`, so your everyday Claude Code sessions are
> completely unaffected.

> **Boundary:** launch + isolation helper. It assumes mac-studio's LM Studio is up with a
> model loaded, and CCR v3+ is installed under Node ≥22 on the laptop. Model *selection*
> lives in `knowledge-manager:model-select`; this owns the *launch path*.

## Quick launch

```bash
claude-studio                       # default model qwen3.5-35b-a3b
claude-studio qwen/qwen3-coder-30b  # override model (first arg)
claude-studio qwen3.5-35b-a3b -p "…"  # extra args pass through to `claude`
```

`claude-studio` is a **function** in `~/.zshrc` (target: `Workspace/git/workspace/profiles/zshrc`). It:
1. Sources nvm, switches to **Node 22** (CCR v3 crashes under Node 18 — native-module ABI mismatch).
2. **Ensures the CCR gateway is running** — probes `http://127.0.0.1:3457/health`, and if
   it's not answering, runs `ccr start --no-open` and waits for it (this is the "make sure
   CCR is running, not paused" requirement).
3. Launches `ccr default-claude-code cli -- --model <model>`, which routes through CCR → LM Studio.

## Why isolation is needed (the trap this skill exists to solve)

CCR's `default-claude-code` **profile** does two destructive things on launch:

1. **Injects an `env` block + `hooks` into its profile `settingsFile`** — backing the file
   up first (`settings.json.ccr-original`, `settings.json.ccr-backup-<ts>`) then rewriting
   it with `ANTHROPIC_BASE_URL`, WIF token env, etc. On a non-clean exit the mutation can linger.
2. Its generated launch wrapper (`~/.claude-code-router/bin/ccr-claude-code-wrapper-default-claude-code`)
   **hardcodes `export CLAUDE_CONFIG_DIR='<dirname of settingsFile>'`** — *unconditionally*
   (not `${VAR:=…}`), so exporting `CLAUDE_CONFIG_DIR` yourself before `ccr` is **overwritten**.

Both the injection target and `CLAUDE_CONFIG_DIR` derive from **one field**:
`profile.claudeCode.settingsFile` (and the matching `profile.profiles[].settingsFile`) inside
**`~/.claude-code-router/config.sqlite`** → `app_config` key `default`.

**Gotcha that cost several reverts:** `~/.claude-code-router/global-profile-takeover.json` is
a *generated cache*, regenerated from SQLite on every `ccr start`. Editing that JSON does
**nothing** — CCR overwrites it. You must edit the **SQLite** field. Likewise `ccr start`
alone (not just launching a profile) regenerates the wrapper and re-runs the injection.

## The isolation fix (pin CCR's settingsFile to ~/.claude-studio)

Set the profile's `settingsFile` in SQLite to `~/.claude-studio/settings.json`. Then the
regenerated wrapper exports `CLAUDE_CONFIG_DIR='/Users/<you>/.claude-studio'` and injects
CCR's env into *that* home — one edit fixes both.

**Always `ccr stop` first** — CCR holds config in memory and rewrites SQLite (clobbering your
edit) on exit if it's running.

```bash
export NVM_DIR="$HOME/.nvm"; . "$NVM_DIR/nvm.sh"; nvm use 22
ccr stop                                    # MUST stop first
cp ~/.claude-code-router/config.sqlite ~/.claude-code-router/config.sqlite.bak.$(date +%Y%m%d-%H%M%S)

python3 - <<'PY'
import sqlite3, json, datetime
db="/Users/omareid/.claude-code-router/config.sqlite"
con=sqlite3.connect(db); cur=con.cursor()
cfg=json.loads(cur.execute("SELECT value_json FROM app_config WHERE key='default'").fetchone()[0])
NEW="~/.claude-studio/settings.json"
cfg["profile"]["claudeCode"]["settingsFile"]=NEW
for p in cfg["profile"]["profiles"]:
    if p.get("id")=="default-claude-code": p["settingsFile"]=NEW
now=datetime.datetime.now(datetime.timezone.utc).isoformat().replace("+00:00","Z")
cur.execute("UPDATE app_config SET value_json=?, updated_at=? WHERE key='default'",(json.dumps(cfg),now))
con.commit(); cur.execute("PRAGMA wal_checkpoint(TRUNCATE)"); con.commit(); con.close()
print("pinned settingsFile ->", NEW)
PY

mkdir -p ~/.claude-studio                    # the isolated home
ccr start --no-open
# verify the wrapper now points at the isolated dir:
grep CLAUDE_CONFIG_DIR ~/.claude-code-router/bin/ccr-claude-code-wrapper-default-claude-code
#   -> export CLAUDE_CONFIG_DIR='/Users/<you>/.claude-studio'   ✅
```

### Verify isolation held (the acceptance test)

```bash
REAL=$(readlink -f ~/.claude/settings.json)
B=$(shasum "$REAL" | awk '{print $1}')
# run a non-interactive session on the small/haiku tier as proof:
ccr default-claude-code cli -- -p "Reply with exactly: STUDIO OK" --model qwen/qwen3.8-27b
A=$(shasum "$REAL" | awk '{print $1}')
[ "$B" = "$A" ] && echo "global ~/.claude/settings.json UNCHANGED ✅" || echo "CHANGED ❌"
grep -cE "ANTHROPIC_BASE_URL|claude-code-router|3456" "$REAL"   # expect 0
```

CCR *will* write `settings.json`, `.claude.json`, `settings.json.ccr-*` backups, `projects/`,
`sessions/` under `~/.claude-studio/` — that's correct; it's the isolated home. A harmless
`[claude-code:unrecognized_model] … generate_session_title` line can appear: it's Claude
Code's cosmetic title generator probing a model name not in its catalog; the real completion
still routes and answers.

## CCR config internals (config.sqlite)

CCR v3 stores config in **SQLite**, not `config.json` (legacy `config.json` is migrated in
and archived). Tables: `app_config` (key/value_json), `api_keys`, `runtime_state`.
The live config is `app_config` row `key='default'`.

- **Providers** live at `.Providers[]` — shape `{name, api_base_url, api_key, models[]}`.
  Point `api_base_url` at LM Studio's chat-completions endpoint on the Studio LAN IP:
  `http://192.168.1.131:1234/v1/chat/completions`. `api_key` can be any placeholder (`lm-studio`).
- **Router** is v3-shaped: `{builtInRules:{claude-code,codex}, rules:[], fallback:{mode,models,retryCount}}`.
  Legacy `default`/`background` string keys (`"lmstudio,qwen3.5-35b-a3b"`) are still honored.
- **"No available models" error** = `.Providers` is empty or has no models. Repair by writing
  a valid provider (below). **Edit only while CCR is stopped**, and `PRAGMA wal_checkpoint(TRUNCATE)`
  after writing so it lands in the main db file, then read back with a fresh connection to confirm.

```bash
ccr stop
python3 - <<'PY'
import sqlite3, json, datetime
db="/Users/omareid/.claude-code-router/config.sqlite"
con=sqlite3.connect(db); cur=con.cursor()
cfg=json.loads(cur.execute("SELECT value_json FROM app_config WHERE key='default'").fetchone()[0])
cfg["Providers"]=[{
  "name":"lmstudio",
  "api_base_url":"http://192.168.1.131:1234/v1/chat/completions",
  "api_key":"lm-studio",
  "models":["qwen3.5-35b-a3b","qwen/qwen3-coder-30b","qwen/qwen3.8-27b"],
}]
r=cfg.setdefault("Router",{})
r["fallback"]={"mode":"on","models":["lmstudio,qwen3.5-35b-a3b"],"retryCount":1}
r["default"]="lmstudio,qwen3.5-35b-a3b"; r["background"]="lmstudio,qwen/qwen3.8-27b"
now=datetime.datetime.now(datetime.timezone.utc).isoformat().replace("+00:00","Z")
cur.execute("UPDATE app_config SET value_json=?, updated_at=? WHERE key='default'",(json.dumps(cfg),now))
con.commit(); cur.execute("PRAGMA wal_checkpoint(TRUNCATE)"); con.commit(); con.close()
print("providers written")
PY
ccr start --no-open
```

### Per-provider request injection: `extraBody` (turn off Qwen thinking for every CCR turn)

CCR v3's gateway (`@the-next-ai/ai-gateway`) deep-merges a provider-level `extraBody` into
every upstream body. Shape: `{"default": {...}, "<model-id>": {...}}` (per-model keys override
`default`). This is how CCR sends `reasoning_effort:"none"` to LM Studio so Qwen3.5 agent
turns skip thinking (measured 13.6 s → 3.1 s per turn; see the `lmstudio-tuning` skill):

```bash
ccr stop            # never edit config.sqlite while CCR runs
python3 - <<'PY2'
import sqlite3, json
db="/Users/omareid/.claude-code-router/config.sqlite"
con=sqlite3.connect(db)
cfg=json.loads(con.execute("SELECT value_json FROM app_config WHERE key='default'").fetchone()[0])
for p in cfg["Providers"]:
    if p["name"]=="lmstudio":
        p["extraBody"]={"default":{"reasoning_effort":"none"}}
con.execute("UPDATE app_config SET value_json=?, updated_at=datetime('now') WHERE key='default'",(json.dumps(cfg),))
con.commit(); con.execute("PRAGMA wal_checkpoint(TRUNCATE)"); con.close()
PY2
ccr start --no-open
# prove it (non-interactive; ~15 s for the 20K-token system prompt):
ccr default-claude-code cli -- --model qwen3.5-35b-a3b -p "Reply with exactly OK" --output-format json \
  | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d["result"], d["usage"]["output_tokens"], d["usage"]["output_tokens_details"])'
#   -> OK 2 {'thinking_tokens': 0}
# and on the Studio the logged request body ends with  "reasoning_effort": "none"
#   ssh mac-studio 'grep -c reasoning_effort ~/.lmstudio/server-logs/$(date +%Y-%m)/$(date +%F).1.log'
```

Do not use `zsh -ic` to call the `claude-studio` function from a script: sourcing the interactive
zshrc runs the daily Studio sync. Call `ccr default-claude-code cli -- …` directly instead.

### Switching the CCR default model (and the gateway-discovery caveat)

Two independent "defaults" decide which LM Studio model a session actually uses:

1. **Server route** — `Router.default` (and `Router.fallback.models`) in `config.sqlite`, plus the
   `models` order in the `lmstudio` provider. Set these with `ccr stop` → edit → checkpoint →
   `ccr start` (same recipe as the `extraBody` block above). To switch the default to, e.g.,
   `qwen3.6-35b-a3b-mtp`: put it first in the provider `models`, set `Router.default` to
   `lmstudio,qwen3.6-35b-a3b-mtp`, and point `Router.fallback.models` at it too. Also update the
   warm-model LaunchAgent on the Studio (`automation-hub/scripts/lmstudio/warm-model.sh`,
   `WARM_MODEL`) so the new default is the one kept resident.

2. **Client pick** — the studio settings carry `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1`, so
   Claude Code discovers models from the gateway (`GET :3456/v1/models`) and sends a **concrete**
   opaque model id (`anthropic/claude-ccr-h<hex>`, where `<hex>` is `lmstudio/<model>` hex-encoded).
   That concrete id **bypasses `Router.default`** — the gateway decodes it straight to that model.
   So after a server-side switch, `/v1/models` lists the new model first, but a client that has a
   remembered pick (or print-mode `-p`, which resolved to the old `qwen3.5-35b-a3b` in testing)
   keeps using the old one. Verify with the Studio server log (`~/.lmstudio/server-logs/.../*.log`
   tags each line with the model). To move the client default, use `/model` inside an interactive
   session (the newly-first model is at the top of the list) — that is the reliable, session-safe
   lever. `ANTHROPIC_MODEL` in the profile `env` did **not** take effect for print-mode `-p` runs.

Config surface with no CLI equivalent (`ccr provider add` does not exist): the **web UI** at
`http://127.0.0.1:3458/?ccr_web_token=…` (token printed by `ccr start`). Ports: **3456**
Anthropic proxy (`/v1/messages`), **3457** core (`/health`), **3458** web UI.

## Prerequisites

| Item | Check |
|---|---|
| mac-studio LM Server | `ssh mac-studio "'/Applications/LM Studio.app/Contents/Resources/app/.webpack/lms' server status"` → "running on port 1234" |
| Model loaded/available | `curl -s http://192.168.1.131:1234/v1/models` lists the model id |
| CCR under Node ≥22 | `nvm use 22; ccr -v` (v3.0.21). Node 18 → ABI crash |
| Gateway up | `curl -s http://127.0.0.1:3457/health` → `{"status":"ok"}` |

Note LM Studio **JIT-loads** models on first request; `lms ps` shows only what's currently
resident. Any id from `/v1/models` is routable even if not yet loaded.

## Troubleshooting

**Global `~/.claude/settings.json` got mutated again** → the SQLite `settingsFile` pin was
lost (CCR reinstall/reset, or an edit made while CCR was running). Re-apply "The isolation
fix" (stop CCR first!). Restore your clean file from `~/.claude/settings.json.ccr-original`
if a mutation lingered.

**CCR won't start / crashes with a JS dump under Node 18** → `nvm use 22`, then
`npm install -g @musistudio/claude-code-router` under Node 22, then `ccr start --no-open`.

**"No available models"** → empty `.Providers`; see "CCR config internals" to rewrite a provider
(stop CCR first, checkpoint WAL, read back).

**Model returns `reasoning_content` not `content`** → `qwen3.5-35b-a3b` emits its answer in
`reasoning_content` ("Thinking Process:"). Expected for this reasoning MoE family; Claude Code
handles it, but raw curl tests should read that field.

**LM Studio not on LAN** → `ssh mac-studio "'…/lms' server status"`; start with
`ssh mac-studio "'…/lms' start-server --port 1234"`.

## Model comparison for agentic workloads

| Model | Size | Active | Context | Best for |
|---|---|---|---|---|
| `qwen/qwen3-coder-30b` | 17GB | ~3.3B | 256K | Tool/function calling, coding |
| `qwen3.5-35b-a3b` | 22GB | ~3B | 256K | General reasoning, entity extraction, KG building |
| `qwen/qwen3.8-27b` | 16GB | — | 256K | Fast/small tier (haiku slot) |

All MoE — only active params compute per token, so on M3 Ultra (96GB unified, memory-bandwidth
bound) inference stays fast. Keep loaded models under ~75% of RAM (~72GB).

## References

- [CCR (claude-code-router) on GitHub](https://github.com/musistudio/claude-code-router)
- [CCR Basic Configuration](https://musistudio.github.io/claude-code-router/docs/cli/config/basic/)
- [Run Claude Code Locally on Apple Silicon (LM Studio + LiteLLM)](https://todatabeyond.substack.com/p/run-claude-code-locally-on-apple)
- [Claude Code With Local LLM: Ollama, LM Studio & Llama.cpp](https://jonathansblog.co.uk/using-claude-code-with-local-llm-models-the-complete-guide)
- [Best Open-Source Coding Model 2026 (Morph)](https://www.morphllm.com/best-open-source-coding-model-2026)
