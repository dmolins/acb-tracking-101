-- 05 · Player box score for game 114243 (BAXI Manresa vs Coviran Granada).
-- Run: python -m hoops.sql projects/01-box-score/sql/05_box_score.sql

-- TODO (you): one row per player who played, with:
--   team, jersey, name, PTS, FGM, FGA, 3PM, 3PA, FTM, FTA, FG%
--   Ordered by team, then points.
--   Think hard about FGA: which rows in `shots` would the official scorer NOT count?
--   And an and-one: how many FGA, FGM, FTA does it produce?

-- TODO (you): check that each team's player points add up to its score in 04.

-- TODO (you): your prediction #2 and #3. How many `shots` rows vs FGA in this game?
--   What share of points came from free throws?
