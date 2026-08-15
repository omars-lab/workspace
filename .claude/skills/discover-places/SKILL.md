---
name: discover-places
description: Discover businesses near a location and detect whether a company has *filed to open* at a specific address — using free, no-API-key public data (OpenStreetMap for what physically exists; Socrata open-data portals for building permits, business licenses, and occupancy/use changes). Use when the user asks "what businesses are near me / near <address>", "is a new <business> opening at <location>", "did <company> file to open in <city>", "what permits were pulled on <street>", or "how do I check if a business registered/filed at an address".
---

# Discover places & new-opening signals

## When to use

The user wants to either:
1. **Inventory** what businesses exist near a point ("coffee shops near the Ferry Building"), or
2. **Detect a new opening** — evidence that a company *filed* to open at a specific
   location, before it shows up on a map. The public paper trail (permits, licenses,
   use-change filings) appears months before a storefront does.

## Mental model — the "did they file to open here?" signal chain

A new business leaves public records roughly in this order. Earlier = earlier warning:

1. **Entity registration** — LLC/corp registered with the state Secretary of State (address + agent). *Earliest, but often just a mailing address, not the storefront.*
2. **Commercial lease / property record** — county assessor / recorder shows a tenant change. Rarely free-API'd; usually a portal lookup.
3. **Building / alteration permit** — buildout or renovation filed with the city building dept. **Strong, location-specific, and usually on a free Socrata portal.** Look for `existing_use → proposed_use` changes (e.g. `retail → restaurant`).
4. **Sign permit** — an early, cheap public signal of a named new tenant.
5. **Specialty license** — alcohol (state ABC), food/health (county health dept), which are location-specific and often public.
6. **Business license / certificate** — the business registers with the city to operate. **Latest, but the clearest confirmation.** Usually on the same Socrata portal.

This skill automates steps **3 and 6** (and search for 5) via open-data portals, plus a
present-tense inventory via OpenStreetMap. Steps 1, 2, and some of 5 are portal lookups
the skill points you to (see `references/portals.md`) but can't always query headlessly.

## The tool: `scripts/discover.py`

Standard-library Python 3, **no pip installs, no API keys**. Run it as:

```bash
python3 "$CLAUDE_PLUGIN_ROOT/scripts/discover.py" <subcommand> ...
# or from the skill dir:
python3 ~/.claude/skills/discover-places/scripts/discover.py <subcommand> ...
```

Subcommands (all print JSON; add `--table` for a readable table):

| Subcommand | What it does | Source |
|---|---|---|
| `geocode "<address>"` | address/place → lat, lon, canonical name | Nominatim (OSM) |
| `nearby --address <a> \| --lat --lon [--radius m] [--category food\|retail\|services\|all]` | businesses physically present near a point | Overpass (OSM) |
| `catalog --domain <d> --query <q>` | find the right permit/license **dataset id** on a portal | Socrata |
| `permits --domain <d> --dataset <id> [--near <street>] [--since <date>] [--address-col c] [--date-col c]` | permit/license filings filtered by street + date | Socrata |
| `socrata-search --domain <d> --dataset <id> --query <q>` | full-text search any dataset (e.g. a business name) | Socrata |

## Workflow

### A. "What's near me / near <address>?" (inventory)

```bash
python3 scripts/discover.py nearby --address "Ferry Building, San Francisco" \
    --radius 400 --category food --table
```

Use `--lat/--lon` directly if you already have coordinates (skips a geocode call and
its 1-sec rate-limit sleep). Radius is meters; keep it ≤ 800 for a walkable area.
Summarize by type; call out chains vs. independents (the `brand` field). OSM shows
what's **already open**, not what's *about to* — for that, go to B.

### B. "Is something new opening at / did <company> file at <location>?" (detection)

1. **Pick the portal.** Identify the city/county from the address, then look up its
   open-data domain in `references/portals.md` (e.g. San Francisco → `data.sfgov.org`,
   NYC → `data.cityofnewyork.us`, Chicago → `data.cityofchicago.org`). If it's not
   listed, run `catalog` against a guessed domain or web-search
   "`<city> open data building permits socrata`".

2. **Find the dataset id** for permits or business licenses:
   ```bash
   python3 scripts/discover.py catalog --domain data.sfgov.org \
       --query "building permits" --table
   ```
   Note the short `id` (e.g. `i98e-djp9` for SF building permits, `g8m3-pdis` for SF
   business registrations). `references/portals.md` lists known dataset ids per city.

3. **Query by street + recency.** This is the core detection move — recent filings on
   the target street, newest first:
   ```bash
   python3 scripts/discover.py permits --domain data.sfgov.org --dataset i98e-djp9 \
       --address-col street_name --near "Valencia" \
       --date-col permit_creation_date --since 2024-01-01 --table
   ```
   **Read the columns that reveal a new business:** `proposed_use` / `existing_use`
   (a change signals a new tenant type), `description` (mentions "new restaurant",
   "tenant improvement", "change of use"), `estimated_cost` (large = real buildout),
   and `status`. Different portals name columns differently — inspect the first JSON
   record to learn the real column names before filtering, then set `--address-col`
   and `--date-col` accordingly.

4. **Search for the company by name** (business-license or registration datasets):
   ```bash
   python3 scripts/discover.py socrata-search --domain data.sfgov.org \
       --dataset g8m3-pdis --query "Blue Bottle" --table
   ```

5. **Corroborate across signals.** A single record is weak; convergence is strong.
   Report which of the six signals you found (permit + license + OSM absence = "filed,
   building out, not yet open"). Always cite the record (permit number, filing date,
   portal URL) so the user can verify.

### C. Signals not on open-data APIs

For **Secretary of State entity search**, **county property/lease records**, **state
ABC (alcohol) applications**, and **local health permits**, these are usually
per-jurisdiction web portals rather than free APIs. Point the user to the specific
portal from `references/portals.md`, or offer to drive it with the browser tools
(`claude-in-chrome`) if they want a live lookup. State plainly when a signal requires
a manual portal check rather than pretending the CLI covers it.

## Practical notes

- **No keys needed**, but be polite: Nominatim allows ~1 req/sec (the script sleeps),
  Overpass can be slow or rate-limit under load — retry once after a pause on failure.
- **Column names vary by city.** Always look at one raw JSON record first; don't assume
  `street_name`/`permit_creation_date` exist everywhere. Adjust `--address-col`/`--date-col`.
- **SoQL basics** for `--where`: `like`, `>=`, `AND`, `upper()`. The `permits` command
  builds these for you from `--near`/`--since`; use raw `--where` for anything custom.
- **Dates** are ISO (`2024-01-01`). Socrata datetime columns compare fine as strings.
- **Verify, don't assert.** "A change-of-use permit to `restaurant` was filed at 900
  Valencia on 2024-03-11 (permit 2024xxxx)" — not "a restaurant is opening there."
  Permits get withdrawn; licenses lapse. Report the record and its date, and let
  convergence of signals — not one filing — drive any confidence.

## Files

- `scripts/discover.py` — the CLI (geocode, nearby, catalog, permits, socrata-search).
- `references/portals.md` — known open-data domains + permit/license dataset ids per
  city, plus links to Secretary of State / ABC / property-record portals per state.
