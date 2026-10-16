-- 04 · Team score per game, rebuilt from events, checked against the official result.
-- Run: python -m hoops.sql projects/01-box-score/sql/04_team_score.sql
--
-- Read shots.md and free_throws.md first: which columns tell you made / missed and 2 / 3?

-- TODO (you): points per (gameId, teamId) from `shots` + `free_throws`.

-- TODO (you): join to `matches` (official home_score / away_score) and output one row per
--   game: gameId, home team, rebuilt home, official home, rebuilt away, official away,
--   and a boolean `ok`. You want 10 rows, all ok.

-- TODO (you): the data dictionary warns that `chances.ptsScored` can differ from the
--   real score. Does it differ in these 10 games? What does that tell you about using
--   a "convenience" column you haven't verified?
