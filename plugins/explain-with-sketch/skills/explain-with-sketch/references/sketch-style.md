# Poster style

The look: one cream sheet like a whiteboard cheat sheet. Borderless pastel shapes with rough, hand-painted edges. Dark ink arrows, a handwritten font, and small gray monospace lines for exact code values. No cards, no shadows, no paragraphs. Every idea is a shape with a short label.

Every part below already exists in `assets/template.html`, and the example sections there show each one. Use them; don't write new CSS.

## The sheet

| Markup | Use |
|---|---|
| `<main class="sheet">` | Full sheet: two columns. Use it when 4+ coverage rows were Found. |
| `<main class="sheet one">` | Half sheet: one column, for one rule, one decision or one "why". |
| left `.col` | usually: title → context + gist → status lines → what one X holds → rules / decisions → quirk → outputs |
| right `.col` | usually: main flow → undo / revert → hand-off ("then it goes to…"). A second real flow gets its own flow section here too |
| `footer.foot` | one `?` line per unknown (or one combined line), a "start reading" line, and the legend line (keep its meaning; write it in the user's language) |

A rule or decision can sit next to the flow it governs instead of in the left column.

Each section is `<section class="part">` with an `h2` (optional for the context section right under the title), an optional `.lede` line (mono, what it takes in, e.g. "takes registers at P"), its shapes, then a proof drawer.

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

Leave out sections the code has nothing for. Don't draw empty ones, and don't stretch a section's meaning to fill it (a repo with no records has no "what one record holds").

## Text inside a shape

| Tier | Class | Content |
|---|---|---|
| main | `.t` | the label, ≤ 6 words |
| sub | `.s` | plain words that add meaning (optional) |
| code | `.c` | a short technical detail, ≤ ~50 chars (optional): an identifier, value, format, route, condition or message. Copy it exactly when it is code |

Marks: `<span class="ok">✓</span>` = it happens · `<span class="x">✗</span>` = refused (the `.c` line says the condition or the message) · `?` = not confirmed in the repo.

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

- Put `data-to="id1 id2 …"` on the source shape and an `id` on each target. Ids must be unique on the page.
- The script picks the sides itself. A target to the right gets a fan-out curve, and that's how a step reaches its outcomes. A target below gets a down arrow, and that's how a step reaches the next step.
- `data-wire="under"` draws a curve under two side-by-side shapes (a return trip). `data-wire="back"` draws the same curve dashed (a revert between state chips).
- `data-wire` applies to every target of that source. A shape that needs a normal wire and an under wire can't carry both, so put the under wire on the other shape (downstream → here, not here → downstream).
- Don't add a `data-to` where a static arrow already joins the two shapes (a hop, a chain); you'd draw the arrow twice.
- Short fixed arrows inside a chain, a hop or a stack are static: `<svg class="arr"><use href="#a-r"/></svg>` (right) and `<svg class="arr d"><use href="#a-d"/></svg>` (down).

## Density

- A step has 2–4 outcomes: the boxes in its `.outs`. The arrow to the next step isn't one. If you found more, the step is really two steps.
- Full sheet: usually 6–10 sections and 40–90 shapes. Half sheet: 1–3 sections. These are guides, not caps.
- Every number, format, limit and condition you found in the code gets a `.c` line. That detail is the point of the poster.
- No sentences longer than one line on the sheet. An idea that needs a paragraph needs another shape.

## Proof drawer: closes every section

```html
<details class="proof"><summary>proof · 2 refs</summary><ul>
  <li><code>src/path/file.ts:42</code>: what this line shows</li>
  <li><code>src/path/other.sql:10-18</code>: what these lines show</li>
</ul></details>
```

The count is the number of `<li>`. Put a `<details class="proof"><summary>what we checked</summary>…` in the footer for the unknowns.
