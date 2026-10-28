# gpl

Claude Code skills by Wai Yan Min Lwin. One plugin, `gcl`, holds every skill, so one install gets them all.

| Skill | What it does |
|---|---|
| `explain-with-sketch` | Answers "how does X work?" with hand-sketched cards in a story, single or grid layout. Each card has a sketch, a short caption and its proof. |
| `sketch-map` | Answers "how does X work?" with one cheat-sheet map on a single page: where it sits, its states, the main flow with every outcome (✓ happens / ✗ refused), undo paths, rules and quirks. Short words and arrows only, no sentences. |

Both are read-only. Before they draw anything they:

- explore the whole tree and every candidate
- read every file on the path in full
- log each fact with a quoted `path:line`
- trace one real case end to end
- write and re-check a model of how the code works
- pass a read gate
- re-check every ref

Pages and replies stay in the user's language. When a question is unclear, they ask `Q1 - … / Q2 - …` first.

## Install

```
/plugin install gcl --marketplace wyMinLwin/skills
```

On older Claude Code:

```
/plugin marketplace add wyMinLwin/skills
/plugin install gcl@gpl
```

Restart Claude Code after installing.

**Coming from an older version?** The plugin used to be called `explain-with-sketch` (0.1.0–0.2.0), `gpl-skills` (0.3.0) or `gpl` (0.3.1). Replace it:

```
/plugin marketplace update gpl
/plugin uninstall explain-with-sketch@gpl
/plugin install gcl@gpl
```

If you had 0.3.0 or 0.3.1, uninstall `gpl-skills@gpl` or `gpl@gpl` instead.

## Use

Both skills trigger on their own: "how does checkout work?" usually gets cards, while "cheat sheet of the auth flow" or "map out checkout" gets a map. To call one directly:

```
/gcl:explain-with-sketch how does the login flow work?
/gcl:sketch-map map the login flow
```

## Layout

```
.claude-plugin/
  marketplace.json                 marketplace "gpl", one plugin at ./
  plugin.json                      plugin "gcl" (the version lives here)
skills/
  explain-with-sketch/
    SKILL.md                       reading harness + card workflow
    references/sketch-style.md     layouts, sketches, colors, density
    assets/template.html           card page (open it to preview)
  sketch-map/
    SKILL.md                       reading harness + map workflow
    references/map-style.md        sections, word limits, colors, wires
    assets/template.html           one-page map (open it to preview)
scripts/check-shared.sh            checks both skills carry the same harness
```

The reading harness (rules, explore, read deeply, verify, red flags) is copied into each SKILL.md between `<!-- shared:harness -->` markers, so each skill still works on its own. Edit it in one place, copy it to the other, then run the check.

## Add a skill

Make `skills/<name>/SKILL.md`. Claude Code picks up every folder in `skills/` on its own. If the new skill reads code, give it the shared harness block too.

## Release a new version

Bump `version` in `.claude-plugin/plugin.json` and `metadata.version` in `.claude-plugin/marketplace.json`. Then run:

```
bash scripts/check-shared.sh
claude plugin validate .
```

## Versions

- **0.3.2**: the plugin is renamed from `gpl` to `gcl`. Install it with `/plugin install gcl@gpl`; the commands are `/gcl:explain-with-sketch` and `/gcl:sketch-map`. The marketplace is still `gpl`.
- **0.3.1**: the plugin is renamed from `gpl-skills` to `gpl`. Install it with `/plugin install gpl@gpl`; the commands are `/gpl:explain-with-sketch` and `/gpl:sketch-map`.
- **0.3.0**: one plugin, `gpl-skills`, holds every skill. `explain-with-sketch` goes back to the 0.1.0 cards. The 0.2.0 poster becomes its own skill, `sketch-map`, now with short words only and sized to fit one page. The reading harness goes deeper, and both skills share it:
  - explore every candidate and what calls it
  - log open questions
  - trace one real case end to end
  - write a model, then read the core files a second time to check it
  - a 7-box read gate
- **0.2.0**: the cheat-sheet poster replaces the card layouts, with deeper reading: a full survey before deciding anything, every file on the path read in full, a quoted ledger, an 11-row coverage checklist, a read gate and a verify pass.
- **0.1.0**: first release, with hand-sketched cards in a story, single or grid layout.
