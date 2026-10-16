# Learning with AI: who does what

This repo is built with Claude (Claude Code) as a tutor and pair programmer. The rule is
simple: **AI handles what I already know or don't need to learn here. I do what I need
to learn.** A finished project I can't explain is worth nothing, on a CV or in a blog post.

## I do it myself (doing it *is* the learning)

| What | Why it has to be me |
|---|---|
| **Every TODO in a project**: the SQL, the metric, the model code | Writing the query is how you learn the grain, the joins and the trap. Reading Claude's version teaches maybe 20% of that. |
| **Predictions before running** | Being wrong is what makes something stick. Without a prediction, the result is just a number. |
| **Basketball definitions**: what counts as spacing, a good closeout, "after the pick" | This is my edge as a coach. If Claude makes these choices, the project stops being mine. |
| **Reading results and deciding what they mean** | The analyst's job. Claude can challenge my reading but shouldn't write it. |
| **First 15 minutes of debugging** | Reading tracebacks and printing intermediate tables is a core skill. After 15 min, ask for a *hint*, not a fix. |
| **Journal entries and blog posts** | My voice, my learning. AI-written posts read as AI-written, and that undermines the CV. Claude may *review* a draft (clarity, technical errors), not rewrite it. |
| **Choosing the final figure** | Picking the one chart that carries the argument is a judgement call I need to practise. |
| **Committing my own work** | Keeps the history honest: my commits are mine, Claude's carry its trailer. |

## Claude does it (low learning value, or not the skill being learned)

| What | Why that's fine |
|---|---|
| Environment, setup scripts, data download | One-off plumbing. Understanding what it does is enough. |
| Project scaffolds: README, file layout, loading boilerplate, **empty TODOs** | Frees my time for the part that teaches. |
| Plot styling and court drawing helpers | Matplotlib styling is a time sink with little learning in it. I'll *modify* plots from Project 05 on. |
| Explaining concepts, with the proper name so I can read more | A tutor that's always there. |
| **Hint ladder** when I'm stuck: nudge → method → code | I choose how far down to go. |
| **Reviewing my code** after I've written it | Like a senior analyst's code review: bugs, clearer SQL, traps I missed. |
| Sanity checks and expected values to test against | Lets me know when I'm right without being handed the answer. |
| End-of-project quiz (teach-back) and the "how it can lie" debrief | Checks I actually understood. |

## Grey zone: Claude first, then me

| What | Hand-over point |
|---|---|
| Python helpers in `src/hoops/` (loading, smoothing, plotting) | Claude writes the first version and walks me through it line by line. I extend them later. |
| Animation code (Project 05) | Claude builds it; I add the event overlay myself. |
| Model evaluation code (Project 09) | I write the model fit. Claude writes the calibration plot the first time, and I write it the second time. |

## Using AI efficiently (habits worth building)

- **Ask for the hint, not the answer.** "Give me a nudge on the join", not "write the query".
- **Paste the error with context**: the code, what I expected, and what I already tried.
- **"Explain this line"** for anything Claude writes that I can't explain myself. If I
  can't explain it, it doesn't stay.
- **Ask for review after I'm done**, never before I start.
- **Use Claude to attack my result**: "how could this number be wrong?" This is the
  fastest way to find traps.
- **Let Claude do the boring 80% of plumbing**, so the hours go to thinking.

## How the history stays honest

Commits where Claude wrote code carry a `Co-Authored-By: Claude` trailer. Commits with
my own code don't. So `git log` shows exactly what I wrote, which keeps the repo honest
as a CV item and a source for blog posts.
