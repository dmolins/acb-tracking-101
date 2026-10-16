-- 03 · A player dimension from the nested rosters in `game_data`.
-- Run: python -m hoops.sql projects/01-box-score/sql/03_players.sql
--
-- `game_data` has one row per game. `homeTeam` and `awayTeam` are STRUCTs, and each
-- holds a LIST of players. Look first:
select gameId, homeTeam.teamName, len(homeTeam.players) as n_players
from game_data;

-- TODO (you): build one row per (gameId, teamId, playerId) with name and jersey,
--   for BOTH teams. Make it a view so later files can reuse it:
--     create or replace temp view players as ...
--   Nudge: DuckDB's unnest() turns a list into rows. Look at what recursive := true does.
--   Temp views live for one run. To use `players` in 05, run both files together:
--     python -m hoops.sql projects/01-box-score/sql/03_players.sql projects/01-box-score/sql/05_box_score.sql

-- TODO (you): check it. How many player-game rows? How many distinct players?
--   Why are those two numbers different?
