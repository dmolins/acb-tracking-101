# ACB Tracking 101

**Learning basketball tracking analytics from scratch, as a coach. Ten projects on real
player-tracking data from the Spanish Liga ACB.**

I'm a basketball coach. I know the game, I've read the analytics, and I'm strong in SQL.
I hadn't worked with player tracking data before this. This repo is how I'm learning it, in
public: ten projects that start with rebuilding a box score and end with a small
study done end to end.

Data: [SkillCorner open data, ACB 2025/26](https://github.com/SkillCorner/opendata-basketball).
That's 10 full games of broadcast tracking (player and ball positions at 25 fps), plus
SkillCorner's event data (picks, drives, closeouts, shots with defender distance...), plus
season aggregates for 293 games.

## Projects

| # | Project | Question | Skills | Status |
|---|---|---|---|---|
| 01 | Rebuild the box score | Can I reproduce the final score from events alone? | SQL, data modelling, validation | ⬜ |
| 02 | Shot profile and shot chart | Where does each team shoot from, and how well? | eFG%, confidence intervals, court plots | ⬜ |
| 03 | Possessions, pace and the Four Factors | Why did the winner win? | Rate stats, denominators | ⬜ |
| 04 | Player profiles at season scale | Who really shoots well off the catch? | Shrinkage, small samples | ⬜ |
| 05 | First tracking possession | What does a possession look like as data? | Frames, coordinates, animation | ⬜ |
| 06 | Speed, distance and noise | Who covers the most ground? | Smoothing, differentiation | ⬜ |
| 07 | Spacing | Do well-spaced possessions produce better shots? | Geometry, confounders | ⬜ |
| 08 | Pick-and-roll anatomy | What does each coverage give up? | Attribution, selection bias | ⬜ |
| 09 | A first shot-quality model (xFG) | How good was a shot before it went in? | Logistic regression, calibration, CV | ⬜ |
| 10 | Mini capstone | One question, done properly | Reproducibility, communication | ⬜ |

Full curriculum, with what each project teaches and how each result can mislead:
[`docs/curriculum.md`](docs/curriculum.md).

## How I'm learning

Each project follows the same loop: **basketball question → predict → write the code →
check against known truth → "how could this be wrong?" → short write-up**. What I
learned along the way goes in [`notes/journal.md`](notes/journal.md), and the longer
reflections become [blog posts](blog/).

### On using AI
I use Claude as a tutor and pair programmer, deliberately. It handles setup, scaffolding
and code review. I write the analysis code, the basketball definitions and the
conclusions. The split and the reasons for it are in
[`docs/learning-with-ai.md`](docs/learning-with-ai.md). Commits with AI-written code are
marked `Co-Authored-By: Claude`, so the history shows what's mine.

## Run it

```bash
./scripts/setup.sh                      # venv + deps + one game (~40 MB)
source .venv/bin/activate
./scripts/fetch_data.sh --all           # optional: all 10 games (~400 MB)
```
Already have the SkillCorner data downloaded? `ACB_DATA_DIR=/path/to/opendata-basketball ./scripts/setup.sh`
links it instead of downloading it again.

```
projects/NN-name/   # each project: README (question, concepts, findings) + sql/ + notebook
src/hoops/          # reusable helpers built along the way (loading, court plots, smoothing)
sql/                # shared DuckDB views
docs/               # curriculum and the AI working agreement
notes/journal.md    # learning log
blog/               # drafts and published posts
```

## Licence and data
Code: MIT, see [`LICENSE.md`](LICENSE.md). Data © [SkillCorner](https://skillcorner.com),
distributed under MIT at <https://github.com/SkillCorner/opendata-basketball>. It is not
redistributed here.
