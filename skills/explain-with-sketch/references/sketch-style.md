# Sketch style

The look: white cards on a dotted page, a handwritten font, thin wobbly ink outlines, pastel fills, one colored marker underline under each title, a one-line caption at the bottom. Calm, sparse, lots of white space — like a whiteboard drawing, not a dashboard.

All parts below already exist in `assets/template.html`. Use them; don't write new CSS.

## Layouts — `<main class="…">`

| Class | Looks like | Notes |
|---|---|---|
| `story` | One column of wide cards, numbered, with a hand-drawn arrow between each. Sketch on the left, 1–3 sentence caption on the right. | Default. Numbers come automatically. |
| `single` | One big card with an enlarged sketch; the extra cards sit side by side underneath. | For one flow / one rule. Put the most detail into this one sketch (it can use up to ~8 shapes). |
| `grid` | A board of small cards, 4 across on desktop. | Only when the user asks for it, or for many unordered parts. `article.card.wide` spans two columns. |

Mark the Unknown and Where-to-start cards `class="card extra"`: in `story` they get no step number, in `single` they sit under the main card.

## Pick the sketch by what you are explaining

| You are explaining… | Sketch | Parts |
|---|---|---|
| What happens when X (a request, a click, a job) | **Flow** — 2–4 boxes left→right with arrows | `.row.nowrap` · `.box.<color>` · `<svg class="arr"><use href="#arrow-r"/></svg>` |
| An ordered procedure (5+ steps or steps with conditions) | **Steps** — numbered list | `ol.steps > li` |
| How the repo / module is laid out | **Map** — 2×2 or 2×3 labeled boxes with icons | `.grid2` · `.box` · `.ico` |
| Why a value / behavior is what it is | **Why** — question bubble + code note + annotation | `.bubble` · `.note > pre` · `.hl` · `.anno` |
| Who calls what, fan-in / fan-out | **Hub** — actors around one box, pills for the calls | `.stack` + `#i-user`/`#i-bot` · `.box` · `.pill` |
| Two modes, old vs new, A vs B | **Split** — two columns with a dashed divider | `.split` · `.divider` · `h3` |
| A vertical pipeline or layers | **Stack** — boxes with down arrows | `.stack` · `<svg class="arr down"><use href="#arrow-d"/></svg>` |
| Counts, sizes, limits found in code | **Numbers** — big stats, optional bars | `.stat` · `.bars` + `.bar-labels` |
| UI screens / pages | **Window** or **Phone** frames | `.win` (`.bar`, `.ln`) · `.phone` |
| Things the code could not confirm | **Unknown** — dashed boxes | `.unknown` (always the second-to-last card when any exist) |
| Where to start reading | **Checklist** of files | `ul.checks` + `#i-doc` (always the last card) |

## Colors carry meaning — keep it consistent within one page

- `blue` — the user / caller / input
- `yellow` — the main thing being explained, or a highlight
- `purple` — internal component / service
- `green` — success, storage, output
- `orange` — rules, limits, decisions
- `pink` — errors, deletes, failure paths
- `gray` — external / out of scope

Title underline colors (`h2.u-blue`, `u-orange`, `u-purple`, `u-green`, `u-red`): rotate through them; use `u-red` only for the Unknown card.

## Icons in the sprite

`#i-user` `#i-bot` `#i-db` `#i-cloud` `#i-globe` `#i-gear` `#i-doc` `#i-folder` `#i-clock` `#i-queue` `#i-mail` `#i-lock` `#i-key` `#i-bolt` `#i-search` `#i-warn` `#i-question` `#i-check` `#i-cross` — sizes: `.ico` (26px), `.ico.lg`, `.ico.xl`. Color: add `.ok`, `.bad`, `.dim`.

Arrows: `#arrow-r`, `#arrow-l`, `#arrow-d` (with `.arr.down`), `#arrow-curve` (with `.arr.curve`), `#arrow-both`.

## Density limits (keep it sketch-like)

- A sketch has at most ~6 shapes, not counting arrows. More than that → split into two cards.
- Box text: 1–4 words, plus an optional `<small>` sub-label (a path, route, or function name).
- Code notes: ≤ 4 lines, only the lines that prove the point, copied exactly from the file. Mark skipped lines with a `…` line.
- In `grid`, a wide card (`article.card.wide`) is allowed for a flow that truly needs 5 boxes. Use at most one or two per page. `story` cards are already wide.

## Card skeleton

```html
<article class="card">
  <h2 class="u-blue"><span>Short title</span></h2>
  <div class="sketch">
    <!-- one sketch from the table above -->
  </div>
  <p class="cap">One plain sentence, 15 words or fewer.</p>
  <details class="proof"><summary>proof · 2 refs</summary><ul>
    <li><code>src/path/file.ts:42</code> — what this line shows</li>
    <li><code>src/path/other.ts:10-18</code> — what these lines show</li>
  </ul></details>
</article>
```

The summary count is the number of `<li>` refs. The Unknown card uses `<summary>what we checked</summary>` instead.

Escape `<`, `>`, `&` inside code notes (`&lt;` `&gt;` `&amp;`).
