# gpl

A Claude Code plugin marketplace by Wai Yan Min Lwin.

| Plugin | What it does |
|---|---|
| `explain-with-sketch` | Read-only codebase explainer. Answers "how does X work?" with one hand-drawn cheat-sheet poster: where the thing sits, its status lines, what it holds, the main flow with every outcome of every step (✓ happens / ✗ refused), undo paths, rules and quirks. Before it draws anything, it reads every file the flow touches in full, logs each fact with a quoted `path:line`, and re-checks every ref. Delivered as an artifact or a standalone HTML page, in the user's language. Asks `Q1 - … / Q2 - …` when the question is unclear. |

## Install

From GitHub:

```
/plugin marketplace add wyMinLwin/skills
/plugin install explain-with-sketch@gpl
```

From this folder locally (for testing):

```
/plugin marketplace add /Users/l/Desktop/skills
/plugin install explain-with-sketch@gpl
```

Restart Claude Code after installing.

## Use

It triggers on its own for questions like "how does checkout work?" or "walk me through the auth flow". To call it directly:

```
/explain-with-sketch:explain-with-sketch how does the login flow work?
```

## Layout

```
.claude-plugin/marketplace.json          marketplace catalog
plugins/explain-with-sketch/
  .claude-plugin/plugin.json             plugin manifest
  skills/explain-with-sketch/
    SKILL.md                             the rules, reading discipline + workflow
    references/sketch-style.md           poster sections, shapes, colors, wires
    assets/template.html                 the cheat-sheet poster (open it to preview)
```

## Release a new version

Bump `version` in `plugins/explain-with-sketch/.claude-plugin/plugin.json`, in the plugin entry in `.claude-plugin/marketplace.json`, and in that file's `metadata`. Then check:

```
claude plugin validate .
```

## Versions

- **0.2.0**: the cheat-sheet poster replaces the card layouts. It has a context row with "you are here", status lines, a numbered step spine where each step fans out to its outcomes, and revert rows. Reading is deeper: a full survey before deciding anything, every file on the path read in full, a quoted ledger, an 11-row coverage checklist, a read gate, and a verify pass. Pages stay in the user's language.
- **0.1.0**: first release, with hand-sketched cards in a story, single or grid layout.
