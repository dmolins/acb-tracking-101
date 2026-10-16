# 01 · Rebuild the box score

**Question:** Can I reproduce the official result and every player's points using only
SkillCorner's event data?

It looks trivial. It isn't. To get it right you have to understand how the dataset is
modelled: what one row means, how the tables join, and where the data's rules differ from
a box score's rules. Every later project depends on this.

**Tools:** SQL (DuckDB) only. **Time:** 2–3 hours.

---

## Setup

```bash
source .venv/bin/activate
python -m hoops.db                                          # builds data/interim/acb.duckdb (all 10 games)
python -m hoops.sql projects/01-box-score/sql/01_inventory.sql   # runs a file, prints each result
```
You can also open `data/interim/acb.duckdb` in any SQL client that reads DuckDB
(DBeaver, the `duckdb` CLI, a VS Code extension) and work there.

**What's in the database** (built by `src/hoops/db.py`, Claude's plumbing): the 20 event
tables (`shots`, `free_throws`, `chances`, `possessions`, ...) stacked across all 10 games,
plus `game_data` (rosters, still nested), `matches` (official scores),
`player_id_aliases`, and the season aggregates (`agg_*`, used from Project 04).

Reference: `data/raw/opendata-basketball/docs/data_dictionary/` has one page per table.
**Read `README.md`, `shots.md`, `free_throws.md` and `chances.md` before you start.**

---

## Predict first ✍️
Write your answers here *before* running anything. Don't edit them afterwards; being
wrong is the point.

1. How many possessions per team in a 40-minute ACB game?
2. Across the 10 games, will the number of rows in `shots` be equal to, higher than or
   lower than the box-score FGA total? Why?
3. What share of all points come from free throws?
4. What's the difference between a *possession* and a *chance* in this data? Guess from
   the names, then check the dictionary.

> Your answers:
>
> 1.
> 2.
> 3.
> 4.

---

## Concepts

You know grain, keys and tests from your day job. What's new here is how they apply to
**sports event data**.

**Event data vs state data.** Most tables here are *events*: something happened at a
frame (a shot, a pass, a foul). A box score is *state*: totals at the end. Rebuilding state
from events is the most common job in sports analytics, and the most common place to be
wrong. One event can count in several box-score columns (an and-one is a FGM and an FTA),
and some events count in none.

**Possession vs chance.** A possession lasts until the other team gets the ball. An
offensive rebound keeps the same possession but starts a new *chance*. Almost every event
hangs off `chanceId`. This difference becomes the denominator problem in Project 03.

**Data rules vs scoring rules.** SkillCorner logs *every shooting motion*, including
shots where the shooter was fouled and missed. The official scorer doesn't count those as
field-goal attempts. Neither is wrong; they are different definitions. Any time you
compare to an outside number, check that the definitions match first. *(Name to look up:
"operational definitions" in measurement.)*

**Entity resolution.** One real player can have two ids (a name spelled two ways in the
source). Per game, nothing breaks. Summed across games, the player splits into two people.
`player_id_aliases.csv` is the fix. *(Name: entity resolution / master data management,
which you probably know from BI.)*

**Validation against ground truth.** `matches.score` is the official result. If your
rebuilt score doesn't match it in **all 10** games, nothing built on top can be trusted.
One matching game might be luck. Ten is evidence.

---

## Steps

Each SQL file has `TODO (you):` blocks. Write the SQL, run it, and look at the output
before moving on.

| File | What you build |
|---|---|
| `sql/01_inventory.sql` | Row counts per table and the **grain** of the core tables, written in one sentence each |
| `sql/02_tests.sql` | dbt-style data tests: unique ids, not-null keys, every shot belongs to an existing chance |
| `sql/03_players.sql` | A clean player dimension from the nested rosters in `game_data` |
| `sql/04_team_score.sql` | Team points per game, compared against `matches`, for all 10 games |
| `sql/05_box_score.sql` | Player box score for game 114243: PTS, FGM-FGA, 3PM-3PA, FTM-FTA |
| `sql/06_season_totals.sql` | *Stretch:* player totals across all 10 games, with aliases merged |

Draw the join diagram (`game → possession → chance → events`, with players on the side)
in this README, in Mermaid or ASCII, whichever you prefer. In a portfolio repo, the
diagram is what readers look at first.

### Sanity checks (tell you if you're right, without the answer)
- 20 event tables. `shots` has **1,459** rows across the 10 games.
- Game 114243 ends **83–68** (BAXI Manresa – Coviran Granada).
- Your team points match `matches` in **10 of 10** games.
- Across the 10 games, box-score FGA = **1,348**.
- In 05, your players' points add up exactly to their team's score.
- In 06, **3** player ids that appear in these games are aliases of another id.

### Optional outside check
This is a learning repo, not the Cup, so outside data is allowed here. Compare your 05
box score with the official one on acb.com for BAXI Manresa – Coviran Granada (11 Oct
2025). Where they differ, which definition explains it?

---

## Findings ✍️
*(3–5 sentences, in your words. What matched, what didn't, and what surprised you.)*

## How it can lie ✍️
*(List at least two ways a number from this project could be wrong or misleading.
Write yours before Claude adds its own.)*

## Teach-back
At the end, Claude asks three questions. Answer them here or in your journal.
