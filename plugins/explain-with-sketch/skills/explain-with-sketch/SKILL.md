---
name: explain-with-sketch
description: Use when the user wants part of a codebase explained rather than changed — "how does X work", "walk me through this flow", "what happens when…", "explain this repo/module/feature", onboarding to unfamiliar code — or asks for a visual, sketch, diagram, or explainer page of code.
---

# Explain With Sketch

Answer "how does this code work?" with facts you verified in the code, drawn as hand-sketched cards (one idea per card) in the layout that fits the answer — one big sketch, a top-to-bottom story, or a grid — delivered as an artifact or a standalone HTML page.

**You are a reader, not an editor.** This skill never changes the repository.

## Rule 1 — Read-only on the repo

| Allowed | Not allowed |
|---|---|
| Read, Grep, Glob, LSP, codegraph, `ls`, `cat`, `find` | Edit / Write / NotebookEdit on any file inside the repo |
| Read-only git: `log`, `show`, `diff`, `blame`, `status`, `rev-parse` | Creating files in the repo (no notes, no `docs/`, no scratch files) |
| Writing the explainer HTML **outside** the repo | Installing, building, running the app, running tests, migrations |
| | git that changes state: `checkout`, `switch`, `commit`, `stash`, `reset`, `pull`, `fetch` |

If the user asks for a change mid-explanation, say this skill only explains, and that they can ask for the change separately after.

## Rule 2 — No guessing

- Every claim on a card comes from code you **read in this session**, with a `path:line` you can cite.
- Names, numbers, order of steps, and conditions come from the code — never from file names, folder names, comments alone, or "the usual pattern".
- Can't confirm it? It goes on the card as **Unknown** (with what you checked), or it stays off the page. "Unknown" is a valid answer.
- READMEs and docs tell you where to look; they are not proof. If the code doesn't confirm a doc's claim, it's Unknown (cite the doc under "what we checked").
- Behavior that lives outside the repo (the framework, the host tool, infra, a scheduler) is Unknown unless the repo's own code shows it.
- Fewer true cards beat more padded ones.

## Step 1 — Is the question clear?

Do a quick search first (a minute, not a deep dive). Then ask **only if** one of these is true:

- The request matches 2+ different things in the repo (two `auth` modules, a job and an endpoint both called `sync`).
- The request is "explain the repo" and the repo holds several apps/packages.
- The answer depends on config, env, or data you can't see.
- You can't find anything matching what they named.

Ask in exactly this format, then **stop and wait**:

```
Before I sketch this, I need to check:

Q1 - <question, naming the candidates you found, e.g. `src/sync/worker.ts` (background job) or `api/sync.ts` (HTTP endpoint)?>
Q2 - <question>
```

At most 4 questions, each answerable in a few words. If none of the conditions hold, don't ask — start.

## Step 2 — Investigate

1. Find the entry point (route, command, handler, `main`, exported function).
2. Trace the real call path by reading bodies, not just signatures. Follow it until the answer is complete.
3. Keep an evidence list as you go: `claim → path:line`. This becomes each card's proof.
4. Note the commit: `git rev-parse --short HEAD`. Not a git repo → use `not a git repo` for `{{COMMIT}}`.

## Step 3 — Pick the layout, then plan the cards

Pick the **first** row that matches. The grid is not the default.

| If… | Layout | Cards |
|---|---|---|
| The user asks for a grid, cards, board, cheat sheet, or overview of many parts | `grid` | 6–12 |
| The answer happens in order across several stages: "what happens when…", a request/job/build lifecycle, a walkthrough | `story` | 3–7 steps |
| The answer fits in one picture: one rule, one decision, one "why does X…", or a flow of ≤ 4 boxes | `single` | 1 main card |
| The answer is many separate parts with no order (repo tour, "what's in here", comparing modules) | `grid` | 6–12 |
| None of the above clearly fits | `story` | 3–7 steps |

Every layout ends with the two **extra** cards (class `card extra`): **What we couldn't confirm** (only if something is Unknown) and **Where to start reading**.

Each card has exactly four parts:
1. **Title** — a short phrase or question, ≤ 6 words.
2. **Sketch** — one drawing built from the template's parts (see `references/sketch-style.md` for which sketch fits which idea).
3. **Caption** — `grid`: one sentence, ≤ 15 words. `story` / `single`: 1–3 plain sentences. No jargon the drawing didn't introduce.
4. **Proof** — the `path:line` refs behind the card, each with a few words on what that line shows.

## Step 4 — Build the page

1. Read `references/sketch-style.md`, then copy `assets/template.html` (both next to this file).
2. Fill the header: `{{TITLE}}` ("How <thing> works"), `{{QUESTION}}` (the user's words), `{{REPO}}` (repo folder name), `{{COMMIT}}`, `{{DATE}}` (YYYY-MM-DD).
3. Set `<main class="story">` to the layout you picked (`story`, `single`, or `grid`). Delete every element marked `data-example` and add your cards. Keep the CSS and SVG sprite as they are.
4. Check: the file contains no `data-example` and no `{{` left.
5. Save the file **outside the repo**: the session's scratchpad directory if one is given, else `${TMPDIR:-/tmp}/explain-with-sketch/explain-<topic>.html`.

## Step 5 — Deliver

- **Artifact tool available** (Claude Code `Artifact` tool, or native artifacts on claude.ai): publish the page as an artifact. Follow that tool's own requirements (it may ask you to load a design skill first) while keeping this sketch style.
- **No artifact support:** keep the HTML file, give the user its full path, and offer to open it (`open <path>` on macOS, `xdg-open` on Linux).

Then reply in chat with: 2–4 lines answering the question, the link or path, and the list of Unknowns.

## Red flags — stop and re-read the rules

| Thought | Reality |
|---|---|
| "The file is named `PaymentService`, so it handles payments" | Read it. Names lie. |
| "It's probably the standard Express/Django pattern" | Verify in this repo or mark Unknown. |
| "I'll add a quick log / run it to check" | Read-only. Trace it by reading instead. |
| "I'll save notes in the repo while I work" | Nothing gets written inside the repo. |
| "This card looks empty, I'll add a likely detail" | Leave it out or mark it Unknown. |
| "I'll guess what they meant and ask later" | Ambiguous? Ask Q1/Q2 now, before building. |
