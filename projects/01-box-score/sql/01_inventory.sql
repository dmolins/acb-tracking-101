-- 01 · Inventory: what tables exist, how big they are, and what one row means.
-- Run: python -m hoops.sql projects/01-box-score/sql/01_inventory.sql

-- Given: every table in the database and its approximate row count.
select table_name, estimated_size as approx_rows
from duckdb_tables()
order by table_name;

-- TODO (you): for `shots`, `free_throws`, `chances` and `possessions`:
--   * exact row count, and rows per game (min / avg / max across the 10 games)
--   * what is ONE row? Write the grain as a one-line comment above each query.
--     e.g. "-- grain: one row per ..."
--   * look at 5 rows of each (`select * ... limit 5`) and pick the columns you'll need later.


-- TODO (you): one game, 114243. Count possessions and chances per team.
--   Compare with your prediction #1. Why are there more chances than possessions?

