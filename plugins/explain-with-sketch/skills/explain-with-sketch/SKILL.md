---
name: explain-with-sketch
description: Use when the user wants part of a codebase explained rather than changed — "how does X work", "walk me through this flow", "what happens when…", "explain this repo/module/screen/feature", onboarding to unfamiliar code — or asks for a visual, sketch, diagram, cheat sheet, or explainer page of code.
---

# Explain With Sketch

Answer "how does this code work?" with one hand-drawn cheat-sheet poster. It shows where the thing sits, the states it moves through, what it holds, its main flow with every outcome of every step, and its undo paths, rules and quirks. Every shape on it comes from code you read in full in this session. You deliver it as an artifact or as a standalone HTML page.

**You are a reader, not an editor.** This skill never changes the repository.

**Breaking the letter of these rules breaks their spirit too.**

## Rule 1: Read-only on the repo

| Allowed | Not allowed |
|---|---|
| Read, Grep, Glob, LSP, codegraph, `ls`, `cat`, `find`, `wc` | Edit / Write / NotebookEdit on any file inside the repo |
| Read-only git: `log`, `show`, `diff`, `blame`, `status`, `rev-parse` | Creating files in the repo (no notes, no `docs/`, no scratch files) |
| Writing the ledger, the poster, and read-only helper scripts (e.g. one that checks ledger quotes) **outside** the repo | Installing, building, running the app, running tests, migrations |
| | git that changes state: `checkout`, `switch`, `commit`, `stash`, `reset`, `pull`, `fetch` |

If the user asks for a change mid-explanation, say this skill only explains, and that they can ask for the change separately afterwards.

## Rule 2: No guessing

- Every claim on the poster comes from code you **read in this session**, backed by a ledger line that quotes it with its `path:line`.
- Names, numbers, the order of steps, and conditions come from the code. Never take them from file names, folder names, comments alone, or "the usual pattern".
- Can't confirm it? It goes on the poster as `?`, with what you checked, or it stays off. "Unknown" is a valid answer.
- READMEs and docs tell you where to look; they are not proof.
- Behavior that lives outside the repo (the framework, the host tool, infra, a scheduler) is Unknown unless the repo's own code shows it.

## Rule 3: Read in full before you decide

- Reading means the whole file, top to bottom (in parts if it's long), or the full verbatim body of every symbol you rely on (for example from `codegraph_explore`). A grep hit, a search snippet, a signature, an outline or a subagent's summary tells you where to read. None of them counts as reading.
- Read the branches you'd rather skip. Every `if`, `switch`, guard, early return, `throw`, `catch` and validation message on the path can become a ✗ box. Refusals are content, not noise.
- Subagents may help you locate files, but every fact on the poster comes from lines you read yourself.
- Make no drawing decision (which sections, step names, wording) until the read gate in Step 2 passes.

## Rule 4: The user's language

Write everything on the page, and your reply, in the language the user wrote the request in. That includes the template's fixed words: the legend line, and the page title. Don't add translations, glosses or a second language unless the user asks for one. Code names, values and strings stay exactly as they are in the code.

## Step 1: Survey, then decide whether the question is clear

Survey before you decide anything. List the tree, read the manifests and README (as pointers only), and read the entry file of every candidate that could match the request, in full. Then ask **only if** one of these is true:

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

Ask at most 4 questions, each answerable in a few words. If none of the conditions hold, don't ask. Go to Step 2.

**No runtime?** Some repos are docs, config, a library, or prompts and skills. For those, the entry point is whatever a consumer loads first (for example manifest → main file), and the files that drive behavior count as the code.

## Step 2: Read deeply

1. **Make a reading list.** Start from the entry point and list every repo file the flow touches: what it calls, the data layer (SQL, queries, stored procedures, schema, models), the config, constants and enums it reads, and the code that feeds work in or takes results out. If the list grows past ~40 files, stop and ask which part matters most, in the Step 1 format. Skip binary files and files the repo ignores (`.gitignore`), and note them in the ledger header.
2. **Read every file on the list in full.** Add each file you discover to the list and read it too.
3. **Keep a ledger** in a scratch file outside the repo: the session's scratchpad if one is given, else `${TMPDIR:-/tmp}/explain-with-sketch/ledger-<topic>.md`. Its header is the reading list with each file's line count. Below that, write one line per fact:
   `claim | path:line | quoted code`

   The quote goes last, so everything after the second ` | ` is code. Your notes on branches and state writers (gate boxes 2 and 3) go in the ledger too.
4. **Chase every thread.**
   - For each state or status field, search the whole repo for every place that writes it.
   - For each called function, read its body.
   - For each magic value or format, find where it's built.
   - For each table, find its other readers and writers.
5. **Fill the coverage checklist.** Mark each row Found (with ledger refs), Not in this code (with the reason), or Unknown (with what you searched). If a row doesn't fit this kind of code, mark it Not in this code. Don't reinterpret a row just to mark it Found.

| # | Row | Answer from the code | Poster section |
|---|---|---|---|
| 1 | Context | What feeds in? What takes the result out, and what does it do with it next? | context row + hand-off |
| 2 | Gist | The whole idea in one line | gist band |
| 3 | States | Every status/state field, every value, and which code makes each move | status lines |
| 4 | Shape | What one record, request or object holds | holds stack + panel |
| 5 | Main flow | The steps, in order | numbered spine |
| 6 | Outcomes | For each step: everything it writes, issues or sends, and every refusal with its exact condition | fan-outs |
| 7 | Undo | Revert, cancel and delete paths, and when each one is blocked | revert rows |
| 8 | Rules | Permissions, limits, formats, defaults | decision fork or panel |
| 9 | Quirks | Behavior a reader would not expect | quirk bar |
| 10 | Outputs | Prints, exports, files, messages, events | outputs row |
| 11 | Unknowns | What the repo can't answer | footer |

**Read gate.** Go to Step 3 only when all four boxes are true:

- [ ] Every file on the reading list was read in full this session.
- [ ] Every branch in the bodies on the path has a ledger line, or a note on why it's left off the poster.
- [ ] Every state value you will draw has its writer(s) in the ledger.
- [ ] Every checklist row has an entry.

If one box is false, keep reading. Having "enough for a sketch" doesn't pass the gate.

## Step 3: Verify, then compose

1. **Verify.** Re-open every ledger ref. Confirm the quoted code is on that line and that the claim follows from it. A read-only script can check the quotes, but you judge each claim by eye. Fix wrong line numbers. If a claim fails, drop it or move it to Unknown.
2. **Pick the size.** Use a full sheet when 4+ checklist rows are Found. Otherwise use a half sheet.
3. **Place the sections.** Read `references/sketch-style.md` first. The left column usually holds the title, context and gist, states, shape, rules, quirks and outputs. The right column usually holds the main flow (one section per real flow), undo and hand-off. Leave out rows marked Not in this code.
4. **Write the shapes.** Each shape has a main label (≤ 6 words), and optionally a plain sub line and a code line (a short technical detail, copied exactly when it is code). Give each step every outcome you found:
   - ✓ (mint) for what happens
   - ✗ (red) for a refusal, with its condition
   - beige for a neutral result, or `?` for one you couldn't confirm
5. **Add proof.** End every section with a proof drawer that lists its `path:line` refs. If composing adds a ref that isn't in the ledger, verify it the same way before you build.

## Step 4: Build the page

1. Copy `assets/template.html`.
2. Fill in the placeholders:
   - `{{NAME}}`: the thing's name as the code calls it. If it has several names, use the one closest to the question.
   - `{{TITLE}}`: the page title, a name such as "<NAME> cheat sheet", in the user's language
   - `{{WHAT}}`: what it is, in plain words
   - `{{WHERE}}`: its file, class or route
   - `{{QUESTION}}`: the user's words
   - `{{REPO}}`: the repo folder name
   - `{{COMMIT}}`: `git rev-parse --short HEAD`, or `not a git repo`. Add "+ uncommitted changes" when `git status` shows changes in files you read.
   - `{{DATE}}`: YYYY-MM-DD

   Set `<html lang>` to the user's language.
3. Delete every element marked `data-example`. Write your sections into the two `.col`s, and your lines into the footer. Keep the CSS, the SVG sprite and the wires script as they are.
4. Check four things:
   - No element still has a `data-example` attribute.
   - None of the template's placeholders above is left. A `{{` that is quoted from the repo's own code is fine.
   - Every `id` is unique.
   - Every id named in a `data-to` attribute exists.
5. Save the file **outside the repo**: the scratchpad if one is given, else `${TMPDIR:-/tmp}/explain-with-sketch/explain-<topic>.html`.

## Step 5: Deliver

- **Artifact tool available:** publish the page. If the tool wraps pages in its own skeleton, remove only the doctype line and the `<html>`, `<head>` and `<body>` tags (opening and closing). Keep everything inside them: the meta tags, title, font link, style, sprite, sheet and script. Keep the poster style, even where the tool's generic design guidance says otherwise.
- **No artifact support:** keep the HTML file, give the user its full path, and offer to open it (`open <path>` on macOS, `xdg-open` on Linux).

Then reply in the user's language with:

- 2–4 lines answering the question
- the link or path
- the Unknowns
- how much you read, e.g. "read 14 files in full, 3,200 lines"

## Red flags: stop and re-read the rules

| Thought | Reality |
|---|---|
| "The grep hits show enough" | Hits only tell you where to read. Open the file. |
| "The file is long; I'll read the part that matters" | You can't know which part matters before you read it. Read all of it, in parts. |
| "The function name says what it does" | Names lie. Read the body. |
| "That branch is just error handling" | Error branches become the ✗ boxes. Read them and record them. |
| "I have enough for a sketch; time to lay it out" | Check the read gate. If a box is unchecked, keep reading. |
| "I'll fix the line numbers later" | The verify pass isn't optional. |
| "The subagent summarized it" | A summary is only a pointer. Read the lines yourself. |
| "It's probably the standard Express/Django pattern" | Verify it in this repo, or mark it Unknown. |
| "I'll add a quick log / run it to check" | This skill is read-only. Trace it by reading. |
| "I'll keep my notes in the repo" | The ledger lives outside the repo. |
| "This section looks thin, so I'll add a likely detail" | Leave it out, or mark it Unknown. |
| "This row sort of fits if I stretch it" | Mark it Not in this code. A missing section beats a forced one. |
| "A translation or gloss would help" | Use only the user's language, unless they ask for another. |
| "I'll guess what they meant and ask later" | Still unclear after the survey? Ask now. |
