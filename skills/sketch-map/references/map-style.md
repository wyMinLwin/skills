# Map style

The look: one cream sheet, like a whiteboard cheat sheet. Borderless pastel shapes with rough, hand-painted edges, dark ink arrows, a handwritten font, and small gray monospace lines for exact code values. Short words and arrows only: every idea is a shape with a short label, and a reader takes in the whole page at a glance.

Every part below already exists in `assets/template.html`, and the example sections there show each one. Use them; the CSS is complete.

## The sheet

| Markup | Use |
|---|---|
| `<main class="sheet">` | Full sheet: two columns. Use it when 4+ coverage rows were Found. |
| `<main class="sheet one">` | Half sheet: one column, for one rule, one decision or one "why". |
| left `.col` | usually: title → context + gist → status lines → what one X holds → rules / decisions → quirk → outputs |
| right `.col` | usually: main flow → undo / revert → hand-off ("then it goes to…"). A second real flow gets its own flow section, in whichever column is shorter |
| `footer.foot` | one `?` line per unknown (or one combined line), a "start reading" line, and the legend line (keep its meaning; write it in the user's language) |

A rule or decision can sit next to the flow it governs instead of in the left column. Keep the two columns about the same height (count shapes per column; they should be within about a fifth of each other): move a rule, an undo or a second flow to the shorter one.

Each section is `<section class="part">` with an `h2` of ≤ 6 words (optional for the context section right under the title), an optional `.lede` line (mono, ≤ 6 words, what it takes in, e.g. "takes claims at A"), its shapes, then a proof drawer.

## Sections, one per coverage row

| Coverage row | Section | Parts |
|---|---|---|
| Context (+ hand-off) | upstream → **you are here** → downstream, with a circled number and a note over each hop | `.ctx` › `.blob` · `.hop` (`.note` with `.n` + `.c`, then `<svg class="arr"><use href="#a-r"/></svg>`) · `.blob.big.here`; return trip: `data-wire="under"` + `p.ctx-after` |
| Gist | the whole idea in one line | `.band` › `.t` |
| States | one lane per status field: value chips in order, who sets each under it, dashed back-arrows for reverts, a tag legend | `.lane` › `.lane-name` · `.chain` › `.st` (`.chip` › `.L` + `.c`, then `.by`) + `.arr`; `data-wire="back"` on the `.st`; `.backs` labels; `.tags` › `.tag` |
| Shape | parts of one record stacked with down arrows, plus a side panel for roles or kinds | `.pair` › `.stack` (`.box` + `<svg class="arr d"><use href="#a-d"/></svg>`) · `.panel` › `dl.kv` |
| Main flow | a start shape, then numbered steps down a spine with a label on each gap, each step fanning out to its outcomes | `.flow` › `.blob.wide` · `.row` (`.step[data-n]` + `.outs` › `.out`) · `.via` › `span` |
| Outcomes | 2–4 per step, every refusal with its condition | `.out.mint` / `.out.red` / `.out.beige` inside the step's `.outs` |
| Undo | condition → result rows | `.cases` › `.row` (`.box.beige` + `.outs` › `.out`) |
| Rules | one question → its branches | `.row` (`.blob` + `.outs`), or a `.panel` with `dl.kv` for a table of limits |
| Quirks | the surprise, then why in code terms | `.quirk` › `.t` (starts with ⚠) + `.c` |
| Outputs | prints, exports, messages | `.outputs` › text + `.tag.mint` chips |
| Context: hand-off | what the next place does with the result, when the code shows it | `.row` (`.blob` + `.outs` › `.out.mint`) |
| Unknowns | `?` lines in the footer; an unconfirmed outcome can also be a beige `.out` ending in `?` | `footer.foot` › `p` |

Draw only the sections the code has something for. A section's meaning stays plain: a repo with no records has no "what one record holds".

## Words inside a shape

A shape holds a label and at most one detail line. Phrases only, never sentences, no full stops.

| Tier | Class | Content |
|---|---|---|
| label | `.t` | ≤ 4 words. The gist band and the quirk bar may use up to 8 |
| detail, words | `.s` | a plain phrase, ≤ 5 words |
| detail, code | `.c` | one exact code value, ≤ ~40 chars: an identifier, value, format, route, condition or message, copied exactly |

Pick `.s` or `.c` for a shape's detail line, not both. A chip (`.chip`) holds its letter `.L` and one `.c` word; a hop note holds its words and one `.c`. The side blobs of the context row are narrow: keep their detail line ≤ ~20 chars, and put a long path in the proof drawer. Exact values (numbers, formats, limits, conditions) make the best detail lines: they are why someone keeps the map open.

Marks: `<span class="ok">✓</span>` = it happens · `<span class="x">✗</span>` = refused (the detail line says the condition or the message) · `?` = not confirmed in the repo.

Escape `<`, `>`, `&` in labels (`&lt;` `&gt;` `&amp;`).

## Colors carry meaning

| Class | Means |
|---|---|
| `here` (purple) | the thing explained; states set right here |
| `lav` (lavender) | other places, start points, questions |
| `peach` | steps the user or caller takes; data panels |
| `mint` | what happens; success; the gist |
| `red` | refused or blocked |
| `beige` | conditions, neutral results, states set elsewhere, unconfirmed |
| `pink` | quirks and warnings |

Defaults: `.blob` lav, `.step` and `.panel` peach, `.out` and `.band` mint, `.box` / `.chip` / `.tag` beige, `.quirk` pink. Add a color class to change one.

## Wires (arrows between shapes)

- Put `data-to="id1 id2 …"` on the source shape and an `id` on each target. Ids are unique on the page.
- The script picks the sides itself. A target to the right gets a fan-out curve: that's how a step reaches its outcomes. A target below gets a down arrow: that's how a step reaches the next step.
- `data-wire="under"` draws a curve under two side-by-side shapes (a return trip). `data-wire="back"` draws the same curve dashed (a revert between state chips).
- `data-wire` applies to every target of that source. A shape that needs a normal wire and an under wire carries only one, so put the under wire on the other shape (downstream → here, not here → downstream).
- Where a static arrow already joins two shapes (a hop, a chain), that arrow is the link; a `data-to` there would draw it twice.
- Short fixed arrows inside a chain, a hop or a stack are static: `<svg class="arr"><use href="#a-r"/></svg>` (right) and `<svg class="arr d"><use href="#a-d"/></svg>` (down).

## One page

- A shape is any filled shape: blob, step, out, box, band, chip, panel, tag, quirk. Hop notes, gap labels, arrows and proof drawers don't count.
- Full sheet: 5–8 sections and 25–50 shapes. Half sheet: 1–3 sections. Past that, drop the sections furthest from the question.
- A flow holds 3–5 numbered steps. More? Merge neighboring steps into one, or split a second flow into its own section.
- A step has 2–4 outcomes: the boxes in its `.outs`. The arrow to the next step isn't one. Found more? Split the step in two while the flow has room (≤ 5 steps); otherwise keep the 4 that matter most for the question and list the rest in the section's proof drawer.
- A status lane holds ≤ 6 chips, a `kv` panel ≤ 5 rows (each `dd` ≤ 4 words), a tag row ≤ 5 tags, a `.via` gap label ≤ 4 words.
- Every number, format, limit and condition on the path that the page shows gets its detail line, copied exactly.

## Proof drawer: closes every section

```html
<details class="proof"><summary>proof · 2 refs</summary><ul>
  <li><code>src/path/file.ts:42</code>: what this line shows</li>
  <li><code>src/path/other.sql:10-18</code>: what these lines show</li>
</ul></details>
```

The count is the number of `<li>`. Proof lines may be longer than shape text: they sit folded. Put a `<details class="proof"><summary>what we checked</summary>…` in the footer for the unknowns.
