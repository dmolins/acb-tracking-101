-- 02 · Data tests, dbt-style. Each query should return ZERO rows when the test passes.
-- Run: python -m hoops.sql projects/01-box-score/sql/02_tests.sql

-- Example (given): ids in `shots` are unique.
select id, count(*) as n
from shots
group by id
having count(*) > 1;

-- TODO (you): `id` is unique in `chances` and `possessions`.

-- TODO (you): not null: every shot and every free throw has a chanceId and a shooterId.

-- TODO (you): referential integrity: every shot's chanceId exists in `chances`,
--   and every chance's possessionId exists in `possessions`.

-- TODO (you): every shooterId appears in that game's roster.
--   (You need 03_players.sql for this one. Come back to it.)

-- Question to answer in a comment: if one of these failed, what would it break later?
