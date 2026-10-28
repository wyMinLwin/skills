---
name: explain-with-sketch
description: Use when the user wants part of a codebase explained rather than changed — "how does X work", "walk me through this flow", "what happens when…", "explain this repo/module/feature", onboarding to unfamiliar code — or asks for a visual, sketch, diagram, or explainer page of code. For a one-page cheat-sheet map, use sketch-map.
---

# Explain With Sketch

Answer "how does this code work?" with hand-sketched cards (one idea per card) in the layout that fits the answer: one big sketch, a top-to-bottom story, or a grid. Every card comes from code you read in full and understood in this session. You deliver it as an artifact or a standalone HTML page.

<!-- shared:harness · identical in every skill of this repo · check: bash scripts/check-shared.sh -->

**You are a reader, not an editor.** This skill never changes the repository.

**Breaking the letter of these rules breaks their spirit too.**

## Rule 1: Read-only on the repo

| Allowed | Not allowed |
|---|---|
| Read, Grep, Glob, LSP, codegraph, and read-only commands: `ls`, `cat`, `sed -n`, `find`, `wc`, `diff`, `stat` | Edit / Write / NotebookEdit on any file inside the repo |
| Read-only git: `log`, `show`, `diff`, `blame`, `status`, `rev-parse`, `check-ignore` | Creating files in the repo (no notes, no `docs/`, no scratch files) |
| Writing the ledger, the page, and your own read-only helper scripts (e.g. one that checks ledger quotes) **outside** the repo | Installing, building, running the app, running tests or the repo's own scripts, migrations |
| | git that changes state: `checkout`, `switch`, `commit`, `stash`, `reset`, `pull`, `fetch` |

If the user asks for a change mid-explanation, say this skill only explains, and that they can ask for the change separately afterwards.

## Rule 2: No guessing

- Every claim on the page comes from code you **read in this session**, backed by a ledger line that quotes it with its `path:line`.
- Names, numbers, the order of steps, and conditions come from the code. Never take them from file names, folder names, comments alone, or "the usual pattern".
- Can't confirm it? It goes on the page as Unknown (`?`), with what you checked, or it stays off. "Unknown" is a valid answer.
- READMEs and docs tell you where to look; they are not proof.
- Behavior that lives outside the repo (the framework, the host tool, infra, a scheduler) is Unknown unless the repo's own code shows it.

## Rule 3: Understand before you decide

- Reading means the whole file, top to bottom (in parts if it's long), or the full verbatim body of every symbol you rely on (for example from `codegraph_explore`). A grep hit, a search snippet, a signature, an outline or a subagent's summary tells you where to read. None of them counts as reading.
- Read the branches you'd rather skip. Every `if`, `switch`, guard, early return, `throw`, `catch` and validation message on the path is content: refusals and edge cases are half the explanation.
- Subagents may help you locate files, but every fact on the page comes from lines you read yourself.
- Understanding is shown, not felt: the trace and the model in Step 2 show it. Until the read gate passes, make no page decision (layout, which parts, step names, wording).

## Rule 4: The user's language

Write everything on the page, your Step 1 questions, and your reply in the language the user wrote the request in. That includes the template's fixed words: the page title, the legend and the footer. Use that one language only; add a translation, gloss or second language only when the user asks for one. Code names, values and strings stay exactly as they are in the code.

## Step 1: Explore, then decide whether the question is clear

Explore before you decide anything:

1. List the whole tree (skip what git ignores: `git check-ignore`). Read the manifests and README, as pointers only.
2. Find every candidate that could match the request: search for the user's words, close synonyms, and the identifiers they suggest. Read each candidate's entry file in full.
3. For each candidate, search for everything that calls, imports or references it, so you know what feeds in.

Then ask **only if** one of these is true:

- The request matches 2+ different things in the repo (two `auth` modules, a job and an endpoint both called `sync`).
- The request is "explain the repo" and the repo holds several apps/packages (units built or installed separately; one package with several modules is one).
- The answer depends on config, env, or data you can't see.
- You can't find anything matching what they named.

Ask in this format, in the user's language, then **stop and wait**:

```
Before I sketch this, I need to check:

Q1 - <question, naming the candidates you found, e.g. `src/sync/worker.ts` (background job) or `api/sync.ts` (HTTP endpoint)?>
Q2 - <question>
```

Ask at most 4 questions, each answerable in a few words. If none of the conditions hold, go to Step 2.

**No runtime?** Some repos are docs, config, a library, or prompts and skills. For those, the entry point is whatever a consumer loads first (for example manifest → main file), and the files that drive behavior count as the code.

## Step 2: Read deeply

1. **Make a reading list.** Start from the entry point and list every repo file the flow touches: what it calls, what calls it, the data layer (SQL, queries, stored procedures, schema, models), the config, constants and enums it reads, and the code that takes results out. Add the tests that exercise the path: they point at edge cases and intended behavior, while the code stays the proof. If the list grows past ~40 files, stop and ask which part matters most, in the Step 1 format. Skip binary files and files git ignores, and note them in the ledger header.
2. **Read every file on the list in full.** Each file you discover joins the list and gets read too.
3. **Keep a ledger** in a scratch file outside the repo: the session's scratchpad if one is given, else `${TMPDIR:-/tmp}/gcl/ledger-<topic>.md`. Its header is the reading list with each file's line count. Below that, one line per fact:
   `claim | path:line | quoted code`

   The quote goes last, so everything after the second ` | ` is code. A claim that something is absent quotes the search instead: `claim | searched: <pattern> in <scope> | no hits`. Your notes on branches and state writers go in the ledger too, and so do the next three items.
4. **Log open questions.** Whenever something is unclear while you read (where is this set? who calls this? what happens when it's empty?), write it under `## Open questions`. Close each one with a ledger ref, or move it to Unknown with what you searched.
5. **Chase every thread.**
   - For each state or status field, search the whole repo for every place that writes it.
   - For each called function, read its body.
   - For each magic value or format, find where it's built.
   - For each table, find its other readers and writers.
6. **Trace a real case.** Under `## Trace`, walk one concrete input (a real value from the code, a fixture or a test; with no runtime, a real request or the file a consumer loads) through the whole path, one hop per line: `hop | path:line | what the value is now`. Walk one refusal the same way when the code has one. A hop that happens outside the repo (the framework, the host tool) is written as `hop | outside the repo | Unknown`. Any other hop that doesn't connect to the next one means a file is missing from the list: go back to item 1.
7. **Write the model.** Under `## Model`, write 5–10 plain lines on how it works, each ending with ledger refs. Then read the core files again, top to bottom: the entry file and every file that holds a main-flow step. Check each part against the model, and fix the model wherever the code disagrees. If your read tool refuses to re-read an unchanged file, read it with `cat -n` or `sed -n`.
8. **Fill the coverage checklist.** Mark each row Found (with ledger refs), Not in this code (with the reason), or Unknown (with what you searched). A row that doesn't fit this kind of code is Not in this code; keep each row's plain meaning.

| # | Row | Answer from the code |
|---|---|---|
| 1 | Context | What feeds in? What takes the result out, and what does it do with it next? |
| 2 | Gist | The whole idea in one line |
| 3 | States | Every status/state field, every value, and which code makes each move |
| 4 | Shape | What one record, request or object holds |
| 5 | Main flow | The steps, in order |
| 6 | Outcomes | For each step: everything it writes, issues or sends, and every refusal with its exact condition |
| 7 | Undo | Revert, cancel and delete paths, and when each one is blocked |
| 8 | Rules | Permissions, limits, formats, defaults |
| 9 | Quirks | Behavior a reader would not expect |
| 10 | Outputs | Prints, exports, files, messages, events |
| 11 | Unknowns | What the repo can't answer |

**Read gate.** Go to Step 3 only when every box is true:

- [ ] Every file on the reading list was read in full this session.
- [ ] Every branch in the bodies on the path has a ledger line, or a note on why it stays off the page.
- [ ] Every state value you will show has its writer(s) in the ledger.
- [ ] `## Open questions` is empty: each one closed with a ref or moved to Unknown.
- [ ] The trace runs end to end with no gap, for one success and (when the code has one) one refusal.
- [ ] Every model line has refs and held up in the second read.
- [ ] Every checklist row has an entry.

A false box means keep reading. Having "enough for a sketch" doesn't pass the gate.

## Step 3: Verify

Re-open every ledger ref, including the ones in the trace and the model. Confirm the quoted code is on that line and that the claim follows from it. A read-only script can check the quotes, but you judge each claim by eye. Fix wrong line numbers. A claim that fails is dropped or moved to Unknown. If a file changed since you read it (`git status`, modification time), read it again and re-check its refs. A ref you add later, while composing, gets verified the same way before you build.

## Red flags while reading: stop and re-read the rules

| Thought | Reality |
|---|---|
| "The grep hits show enough" | Hits only tell you where to read. Open the file. |
| "The file is long; I'll read the part that matters" | You can't know which part matters before you read it. Read all of it, in parts. |
| "The function name says what it does" | Names lie. Read the body. |
| "That branch is just error handling" | Error branches are the refusals. Read them and record them. |
| "I get the gist; the trace can wait" | The trace is how you know you understand. Walk it now. |
| "That question doesn't matter for the page" | Close it with a ref or move it to Unknown. An open question is a gap in the model. |
| "I already read that file once" | The second read checks the model against the code. Do it. |
| "I have enough for a sketch; time to lay it out" | Check the read gate. If a box is false, keep reading. |
| "I'll fix the line numbers later" | The verify step isn't optional. |
| "The subagent summarized it" | A summary is only a pointer. Read the lines yourself. |
| "It's probably the standard Express/Django pattern" | Verify it in this repo, or mark it Unknown. |
| "I'll add a quick log / run it to check" | This skill is read-only. Trace it by reading. |
| "I'll keep my notes in the repo" | The ledger lives outside the repo. |
| "This part looks thin, so I'll add a likely detail" | Leave it out, or mark it Unknown. |
| "This row sort of fits if I stretch it" | Mark it Not in this code. A missing part beats a forced one. |
| "A translation or gloss would help" | Use only the user's language, unless they ask for another. |
| "I'll guess what they meant and ask later" | Still unclear after exploring? Ask now. |

<!-- /shared:harness -->

## Step 4: Pick the layout, then plan the cards

Pick the **first** row that matches. The grid is not the default.

| If… | Layout | Cards |
|---|---|---|
| The user asks for a grid, cards, board, or overview of many parts | `grid` | 6–12 |
| The answer happens in order across several stages: "what happens when…", a request/job/build lifecycle, a walkthrough | `story` | 3–7 steps |
| The answer fits in one picture: one rule, one decision, one "why does X…", or a flow of ≤ 4 boxes | `single` | 1 main card |
| The answer is many separate parts with no order (repo tour, "what's in here", comparing modules) | `grid` | 6–12 |
| None of the above clearly fits | `story` | 3–7 steps |

Plan the cards from the checklist. Every Found row that bears on the question shows up on a card, as its own card or inside a step's sketch or caption. A refusal goes on the card of the step it stops, with its condition.

Every layout ends with the two **extra** cards (class `card extra`): **What we couldn't confirm** (only if something is Unknown) and **Where to start reading**. Their titles are in the user's language too.

Each card has exactly four parts:

1. **Title**: a short phrase or question, ≤ 6 words.
2. **Sketch**: one drawing built from the template's parts (see `references/sketch-style.md` for which sketch fits which idea).
3. **Caption**: `grid`: one sentence, ≤ 15 words. `story` / `single`: 1–3 plain sentences. No jargon the drawing didn't introduce.
4. **Proof**: the `path:line` refs behind the card, each with a few words on what that line shows.

## Step 5: Build the page

1. Read `references/sketch-style.md`, then copy `assets/template.html` (both next to this file).
2. Fill in the placeholders:
   - `{{TITLE}}`: "How <thing> works", in the user's language
   - `{{QUESTION}}`: the user's words
   - `{{REPO}}`: the repo folder name
   - `{{COMMIT}}`: `git rev-parse --short HEAD`, or `not a git repo`. Add "+ uncommitted changes" when `git status` shows changes in files you read.
   - `{{DATE}}`: YYYY-MM-DD

   Set `<html lang>` to the user's language, and write the header legend and the footer in it (keep their meaning).
3. Set `<main class="story">` to the layout you picked (`story`, `single`, or `grid`). Delete every element marked `data-example` and add your cards. Keep the CSS and SVG sprite as they are.
4. Check: no element still has a `data-example` attribute, and none of the placeholders above is left (a `{{` quoted from the repo's own code is fine).
5. Save the file **outside the repo**: the session's scratchpad if one is given, else `${TMPDIR:-/tmp}/gcl/explain-<topic>.html`.

## Step 6: Deliver

- **Artifact tool available:** publish the page. If the tool wraps pages in its own skeleton, remove only the doctype line and the `<html>`, `<head>` and `<body>` tags (opening and closing). Keep everything inside them: the meta tags, title, font links, style, sprite, header, cards and footer. Keep the sketch style, even where the tool's generic design guidance says otherwise.
- **No artifact support:** keep the HTML file, give the user its full path, and offer to open it (`open <path>` on macOS, `xdg-open` on Linux).

Then reply in the user's language with:

- 2–4 lines answering the question
- the link or path
- the Unknowns
- how much you read, e.g. "read 14 files in full, 3,200 lines"
