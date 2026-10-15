# gpl

A Claude Code plugin marketplace by Wai Yan Min Lwin.

| Plugin | What it does |
|---|---|
| `explain-with-sketch` | Read-only codebase explainer. Answers "how does X work?" with facts verified in the code, drawn as hand-sketched diagrams — one big sketch, a step-by-step story, or a card grid, whichever fits the answer (artifact, or a standalone HTML page). Asks `Q1 - … / Q2 - …` when the question is unclear. |

## Install

From GitHub (after pushing this folder to a repo):

```
/plugin marketplace add <github-user>/<repo>
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
    SKILL.md                             the rules + workflow
    references/sketch-style.md           which sketch fits which idea
    assets/template.html                 the hand-drawn card page (open it to preview)
```

## Release a new version

Bump `version` in both `plugins/explain-with-sketch/.claude-plugin/plugin.json` and the plugin entry in `.claude-plugin/marketplace.json`, then check:

```
claude plugin validate .
```
