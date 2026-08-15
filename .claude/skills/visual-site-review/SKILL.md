---
name: visual-site-review
description: Visually inspect a web page or site and critique its design, then verify fixes by looking again. Use when the user asks to "review the site visually", "see how the page looks", "check the gh-pages site", "screenshot and critique", "does this look right", or wants a before/after visual QA pass. Covers two modes — Claude-in-Chrome for interactive/ad-hoc review, and Playwright for repeatable automated screenshot tests. Pairs naturally with the frontend-design skill (frontend-design proposes the look; this skill verifies it on screen).
---

# Visual site review

Look at the rendered page with your own eyes (screenshots), judge it against a design bar, make changes, then **look again** to confirm. Never declare a visual change "done" without seeing the rendered result — code that compiles is not the same as a page that looks right.

## When to use

- "Can we visually inspect <url> and see what to improve?"
- "Review the gh-pages / live site."
- "Does this layout look right? Screenshot it."
- "Verify the redesign actually renders correctly."
- Before/after QA on any frontend change.

If the user wants the *design proposed* (fonts, palette, aesthetic direction), reach for **frontend-design** first; use this skill to evaluate and verify what gets built.

## The loop

1. **Serve it** — get a real URL. Prefer a local HTTP server over `file://` (relative paths, `fetch`, and module scripts break under `file://`).
2. **Look** — screenshot at desktop width; scroll through the whole page (top, middle, footer); screenshot mobile width too.
3. **Critique against a bar** — see the checklist below. Name specific problems with locations, not vibes.
4. **Fix** — edit the code.
5. **Re-serve + re-look** — screenshot again and confirm each problem is resolved and nothing regressed.
6. Repeat until it clears the bar.

## Critique checklist

Judge what you see, concretely:

- **AI-slop tells** — the `#667eea→#764ba2` purple gradient, Inter/Roboto/Arial body, evenly-spaced pill-button card grids, fake loading spinners. Flag and replace.
- **Typography** — is there a real type pairing (display + body)? Generic system fonts read as unfinished.
- **Color cohesion** — do the content images and the chrome share a palette, or fight? (e.g. cream-background renders inside white cards on a purple bg = three palettes clashing.)
- **Hierarchy & spacing** — clear focal point, intentional negative space, consistent rhythm. Cramped or evenly-gray = no hierarchy.
- **Broken assets** — images that 404 or show empty placeholders. Check the actual pixels, not just the markup.
- **Responsive** — re-screenshot at ~390px wide. Does the grid collapse, does text wrap, do actions stay reachable?
- **Content honesty** — does the page show everything it should (full catalog, real links), or silently omit items?
- **Links resolve** — spot-check that hrefs (source, downloads, nav) actually return 200.

## Mode A — Claude-in-Chrome (interactive, ad-hoc)

Best for: one-off review, exploring a live site, judging aesthetics, quick before/after.

```
# 1. load the chrome tools first (they are deferred)
ToolSearch "select:mcp__claude-in-chrome__tabs_context_mcp,mcp__claude-in-chrome__tabs_create_mcp,mcp__claude-in-chrome__navigate,mcp__claude-in-chrome__computer"

# 2. get tab context, then make a NEW tab for this session (don't reuse the user's)
tabs_context_mcp
tabs_create_mcp

# 3. serve locally if reviewing local files
python3 -m http.server 8777   # run from the project root, in the background

# 4. navigate + screenshot + scroll
navigate  -> http://localhost:8777/index.html
computer  -> screenshot
computer  -> scroll / key "End" / key "Home", screenshot each region
```

Notes:
- `navigate` can mangle `file://` URLs (it prepends `https://`). Use a local server.
- Use `computer` `key` "Home"/"End" to jump to top/bottom; `scroll` for regions.
- To share a screenshot with the user, pass `save_to_disk: true`.
- Re-screenshot after every fix. The whole value of this skill is the second look.
- Don't trigger native `alert/confirm/prompt` dialogs — they freeze the extension.

## Mode B — Playwright (automated, repeatable)

Best for: regression tests, multi-viewport sweeps, CI, "lock in this look so it can't break."

```bash
npx playwright install chromium    # one-time
```

```js
// review.spec.js — run with: npx playwright test
const { test, expect } = require('@playwright/test');

const VIEWPORTS = [
  { name: 'desktop', width: 1440, height: 900 },
  { name: 'mobile',  width: 390,  height: 844 },
];

for (const vp of VIEWPORTS) {
  test(`gallery @ ${vp.name}`, async ({ page }) => {
    await page.setViewportSize({ width: vp.width, height: vp.height });
    await page.goto('http://localhost:8777/index.html', { waitUntil: 'networkidle' });

    // full-page screenshot for human review
    await page.screenshot({ path: `shots/${vp.name}.png`, fullPage: true });

    // hard assertions — no broken images
    const broken = await page.$$eval('img', imgs =>
      imgs.filter(i => !i.complete || i.naturalWidth === 0).map(i => i.src));
    expect(broken, `broken images: ${broken.join(', ')}`).toEqual([]);

    // every download/source link returns 200
    const hrefs = await page.$$eval('a[href]', as => as.map(a => a.href));
    for (const h of hrefs.filter(h => /github|raw\.|\.stl/.test(h))) {
      const res = await page.request.head(h);
      expect(res.ok(), `dead link: ${h}`).toBeTruthy();
    }
  });
}
```

Then **open the `shots/*.png` and actually look** — assertions catch broken assets, but only eyes catch ugly. Optionally add visual-regression baselines with `expect(page).toHaveScreenshot()` to fail on unintended pixel diffs.

## Choosing a mode

- Reviewing aesthetics, a live URL, or a quick pass → **Claude-in-Chrome**.
- Want it to stay correct over time, or sweeping many viewports/pages → **Playwright**.
- Both can coexist: explore in Chrome, then codify the keepers as Playwright assertions.

## Output

Report findings as a short table (problem · location · severity) and, when useful, attach before/after screenshots. End with what was verified and what (if anything) still needs a human eye.
