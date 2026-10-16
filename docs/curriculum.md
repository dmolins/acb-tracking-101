# Curriculum: ten projects

Ten short projects on the
[SkillCorner ACB 2025/26 open data](https://github.com/SkillCorner/opendata-basketball),
from "what's in the file" up to "a small finished study". Each one teaches a few ideas
you will use in the real entry.

---

## Why these ten

I looked at what people actually do with player tracking: the NBA SportVU and Second
Spectrum work, public research on spacing and gravity, xFG/shot-quality models, and the
SkillCorner primer and data dictionary. Almost everything falls into five skills:

| Skill | What it means | Projects |
|---|---|---|
| **Read the data model** | Know what one row means and how tables join, and check it against known truth | 01, 03 |
| **Describe with rates** | Pick the right denominator, compare fairly, respect small samples | 02, 03, 04 |
| **Work with tracking** | Frames, coordinates, noise, smoothing, geometry | 05, 06, 07 |
| **Link actions to outcomes** | Connect a pick, drive or closeout to what came after it, without fooling yourself | 08, 09 |
| **Model and communicate** | A simple, honest model, plus one figure and a short write-up someone can trust | 09, 10 |

The order runs from SQL-only (your strength) to Python geometry and a first model (the
new ground). Every project uses the competition's data and nothing else, so the habits
carry over without changing.

---

## The ten projects

Each one should take **one or two sittings (2–4 h)**. Each has a basketball question,
the concepts it teaches, what you build, and a **"how it can lie to you"** note. Those
notes matter more than anything else here.

### 01 — Rebuild the box score  ·  *SQL · easy*
**Question:** Can I reproduce the final score and each player's points from the event file alone?
- Load `dynamic_events.json` into DuckDB and list all 20 tables, their row counts and their keys.
- Work out the **grain** of each table (what one row is) and draw the join diagram:
  `game → possession → chance → event`, with players joined through `game_data`.
- Rebuild points, FGM/FGA, 3PM/3PA and FT for every player, and check them against the real result (83–68).

**Concepts:** table grain, primary and foreign keys, the four join keys, validation against ground truth.
**How it can lie:** `chances.ptsScored` gives a different score than shots plus free throws. `shots` also contains fouled misses, which a box score doesn't count as attempts. Duplicate player ids need `player_id_aliases.csv`.

### 02 — Shot profile and shot chart  ·  *SQL + first plot · easy*
**Question:** Where does each team shoot from, and how well?
- FGA, FG%, **eFG%** and **points per shot** by region. One team against the other, then all 10 games.
- First court plot (with `mplbasketball`): every shot coloured by make or miss.
- Put an uncertainty band on each zone's percentage.

**Concepts:** eFG% and why plain FG% misleads, points per shot, **binomial confidence intervals** (Wilson), how to draw a court.
**How it can lie:** 7/10 from the left corner is not "70%". With n=10 the interval runs from about 40% to 89%. Event locations are normalised (offense always attacks −x), so don't mix them with raw tracking yet.

### 03 — Possessions, pace and the Four Factors  ·  *SQL · easy–medium*
**Question:** Why did the winner win?
- Count possessions and chances per team. Compute **points per possession** (offensive rating) and pace.
- Dean Oliver's **Four Factors** (eFG%, TOV%, ORB%, FT rate), built from the event tables.
- Write a three-sentence "why they won" for two of the games.

**Concepts:** denominators (per shot, per chance, per possession), rate stats against counting stats, possession against chance (an offensive rebound starts a new chance in the same possession).
**How it can lie:** the same points look different per chance and per possession. Garbage time and end-of-quarter heaves inflate or deflate these numbers.

### 04 — Player profiles from the season aggregates  ·  *SQL · medium*
**Question:** Who are the league's best shooters off the catch? Who gets to the rim on drives?
- Query the 293-game aggregate CSVs: shot diet, contest levels, drive and pick outcomes.
- Rank players, then rank them again after **shrinkage**: pull small samples towards the league average.
- Make percentile "player cards" for three players you know as a coach, and see whether the numbers match your eye.

**Concepts:** volume against efficiency, minimum-sample thresholds, **regression to the mean / empirical Bayes shrinkage**, percentiles.
**How it can lie:** the top of any raw percentage leaderboard is mostly small samples. Aggregates are offense-only and cover direct picks only. Traded players have a `total` row, which double-counts them if you aren't careful.

### 05 — Your first tracking possession  ·  *Python · medium*
**Question:** What does one possession look like as moving dots?
- Stream `tracking_data.jsonl.gz`, pull one chance's frames using `startFrame`/`endFrame`, plot one frame, then animate it.
- Overlay the events (pass, pick, shot) on the animation at their frame numbers.
- Colour each dot by `isDetected`, so you can see when the tracker is guessing.

**Concepts:** frames and fps (25 fps means 0.04 s per frame), wide against long data, coordinate frames, the line between detected and extrapolated positions.
**How it can lie:** `frameIdx` is not the line number in the file. Raw tracking xyz is **fixed to the court**, while event locations are **flipped per chance**. Mix them and the dots land on the wrong half.

### 06 — Speed, distance and the noise problem  ·  *Python · medium*
**Question:** Who covers the most ground? Who is the fastest in transition?
- Compute distance and speed from positions. First the naive way, then with **smoothing** (moving average, then Savitzky–Golay).
- Plot raw against smoothed speed for one player and watch the impossible 40 ft/s spikes disappear.
- Leave out (or down-weight) frames where `isDetected` is false or `predError` is high, and see how much the answer moves.

**Concepts:** numerical differentiation, **why differentiation amplifies noise**, smoothing windows and their trade-off (lag against jitter), data-quality filtering.
**How it can lie:** acceleration from raw positions is mostly noise. Missing frames and dead time between periods produce fake "teleports".

### 07 — Spacing: measuring the floor  ·  *Python geometry · medium*
**Question:** Do well-spaced possessions produce better shots?
- At the moment of each shot, compute the offense's **convex hull area**, the average pairwise distance, how many players stand beyond the arc, and the nearest defender to each off-ball player.
- Compare spacing for shots that score against shots that miss, and for open against contested shots.

**Concepts:** geometric features from coordinates, choosing *when* to measure, **correlation against causation**, confounders (transition shots look "spaced" because the defense hasn't set).
**How it can lie:** a large hull can mean great spacing or a broken play. Always split by transition against half-court before concluding anything.

### 08 — Pick-and-roll anatomy  ·  *SQL + animation · medium–advanced*
**Question:** How do ACB teams defend the pick, and what does each coverage give up?
- From `picks`: frequency of each coverage (`drop`, `switch`, `ice`, `blitz`, ...), and points per chance after each one.
- Animate two or three picks of each coverage. **You** judge whether SkillCorner's label matches what a coach would call it.
- Do the same check with the season aggregates for scale.

**Concepts:** linking an action to an outcome (**attribution window**: what counts as "after the pick"?), **selection bias** (teams choose a coverage *because of* the ball-handler), validating model labels with expert judgement.
**How it can lie:** "switch allows 0.85 PPP and blitz 1.10" may only mean teams blitz the best ball-handlers. The labels are a model's output, not the truth.

### 09 — A first shot-quality model (xFG)  ·  *Python modelling · advanced*
**Question:** How good was each shot *before* it went in or out?
- Features: shot distance, `closestDefDist`, contest level, release time, catch-and-shoot or off the dribble.
- Baseline first (league FG% by zone). Then a **logistic regression**. Evaluate it with log loss, Brier score and a **calibration plot**, using **cross-validation grouped by game**.
- Shot-making = actual minus expected. Who beats their xFG, and is the gap bigger than the noise?

**Concepts:** baseline models, train/test split and **leakage**, why grouped CV matters, calibration against accuracy, reading coefficients, the difference between shot quality and shot-making.
**How it can lie:** about 1,500 shots is a small dataset. A model that "beats" the baseline on one split may just be fitting noise. This is also the competition's crowded lane. The point here is to understand the tool, not to enter with it.

### 10 — Mini capstone: one question, done properly  ·  *everything · advanced*
**Question (your choice, coach-driven):** e.g. *"Do hard closeouts actually lower shot quality?"* or *"What happens to the shot after a blow-by on a drive?"*
- A reproducible pipeline: one command rebuilds every number from the raw data (`sql/` + `src/`, no notebook-only results).
- **One** figure good enough to publish, a **300-word** write-up, and a **60-second** spoken pitch.
- A short "limitations" section: what the data can't tell you.

**Concepts:** reproducibility, a pinned environment, picking the one figure that carries the argument, saying uncertainty out loud. It's a dress rehearsal of the competition format, with half the stakes.

---

## How each project runs

Who does what between me and the AI: [`learning-with-ai.md`](learning-with-ai.md).

### Every project has the same shape
1. **The basketball question first.** You explain it as a coach, before any code.
2. **Predict before you run.** You write down what you expect (e.g. "corner threes will be the best shot"). Then we look. Being surprised is when learning happens.
3. **Scaffold, not solution.** I write the boilerplate (loading, plotting helpers) and leave **TODOs** for the parts that teach the concept. You write those. If you get stuck, I give a **hint ladder**: first a nudge, then the method, then the code. You choose how far down to go.
4. **Concept boxes.** Each new idea gets 3–5 lines: what it does, what it assumes, how it misleads, and its proper name, so you can read more.
5. **"How it can lie" check.** Every project ends with you naming at least one way the result could be wrong, before I tell you mine.
6. **Teach-back.** Three short questions at the end (e.g. "why did we group by game in the CV?"). If you can't answer, we revisit before moving on.

### Ways of working you'll practise every time
- **Validate against known truth first.** Final scores, box scores, a possession you can see. If a simple number is wrong, nothing built on it can be right.
- **Know the grain.** Before every query, say what one row is.
- **SQL for logic, Python for geometry.** DuckDB over the JSON and CSV, so you can read every rule. Python only where SQL doesn't fit (frames, smoothing, plots, models).
- **Look at the dots.** Any metric gets checked against two or three animated examples. Your coaching eye is the validation tool.
- **Notebooks to explore, scripts to produce.** Anything you'd defend goes in `src/` or `sql/` and runs end to end.
- **Small commits, a learning journal.** After each project, five lines in `notes/journal.md`: what you learned, what surprised you, what you'd reuse in the Cup.
- **Git and GitHub habits** you'll need for the public submission: commit messages, `.gitignore` for data, a README a stranger can follow.

---

## Sources consulted
- SkillCorner open data repo: README, `PRIMER.md`, data dictionary, `KNOWN_ISSUES.md`
- Spacing via convex hull and graph metrics: [Graph-Based Quantification of Basketball Spacing](https://dea.lib.unideb.hu/items/336f64cc-e81a-4e19-b1cf-2bca04cef27b/full)
- Gravity and xFG features from tracking: [Duke Data+ off-ball gravity](https://bigdata.duke.edu/wp-content/uploads/2022/08/Team22bExecSumm.pdf), [CMU tracking overview](https://www.stat.cmu.edu/cmsac/conference/2020/assets/pdf/nba_tracking_data.pdf)
- Tracking in Python, convex hulls, gravity: [Squared Statistics (Justin Jacobs)](https://squared2020.com/2017/01)
- Micro-actions from spatio-temporal data: [DeepHoops](https://arxiv.org/pdf/1902.08081)
- 2026 Analytics Cup finalists (what the jury rewarded): [SkillCorner event page](https://skillcorner.com/event-2026/5-02-skillcorner-x-pysport-analytics-cup)
