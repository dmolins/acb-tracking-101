"""Build and open the project's DuckDB database.

The SkillCorner event file for each game is ONE big JSON object: {"shots": [...],
"passes": [...], ...}. DuckDB reads each file as a single row whose columns are lists,
and `unnest(..., recursive := true)` turns each list into a proper table: one row per
event, one column per field. We stack every downloaded game into the same table.

Build (or rebuild) with:   python -m hoops.db
Then query it from Python (`hoops.db.connect()`), the `hoops.sql` runner, or any SQL client
that opens DuckDB files (DBeaver, the duckdb CLI, VS Code extensions).
"""

from pathlib import Path

import duckdb

ROOT = Path(__file__).resolve().parents[2]
RAW = ROOT / "data/raw/opendata-basketball/data"
DB_PATH = ROOT / "data/interim/acb.duckdb"

EVENT_FAMILIES = [
    "possessions", "chances", "chance_players", "matchups", "shots", "free_throws",
    "rebounds", "turnovers", "fouls", "timeouts", "passes", "touches", "dribbles",
    "picks", "handoffs", "off_ball_screens", "drives", "isolations", "posts", "closeouts",
]


def build(db_path: Path = DB_PATH) -> None:
    events = sorted(RAW.glob("matches/*/*_dynamic_events.json"))
    if not events:
        raise SystemExit("No games found. Run ./scripts/fetch_data.sh first.")
    db_path.parent.mkdir(parents=True, exist_ok=True)
    db_path.unlink(missing_ok=True)
    con = duckdb.connect(str(db_path))

    files = ", ".join(f"'{p}'" for p in events)
    # One row per game file; each column is a list of events.
    con.sql(f"""
        create temp table raw_events as
        select * from read_json([{files}], union_by_name := true,
                                maximum_object_size := 32000000)
    """)
    for family in EVENT_FAMILIES:
        con.sql(f"create table {family} as "
                f"select unnest({family}, recursive := true) from raw_events")

    # Game metadata, kept as delivered (rosters are nested lists, left nested on purpose).
    con.sql(f"""create table game_data as
                select * from read_json('{RAW}/matches/*/*_game_data.json')""")
    con.sql(f"""create table matches as
                select * from read_json('{RAW}/matches.json')""")
    con.sql(f"""create table player_id_aliases as
                select * from read_csv('{RAW}/player_id_aliases.csv')""")
    # Season aggregates: 293 games, offence only (used from Project 04).
    for name in ("shots", "drives", "picks"):
        con.sql(f"""create table agg_{name} as select * from
                    read_csv('{RAW}/aggregates/acb_{name}aggregates_20252026.csv')""")

    games = con.sql("select count(distinct gameId) from shots").fetchone()[0]
    print(f"Built {db_path.relative_to(ROOT)}: {games} games, "
          f"{len(EVENT_FAMILIES)} event tables + game_data, matches, aliases, aggregates")
    con.close()


def connect(read_only: bool = True) -> duckdb.DuckDBPyConnection:
    if not DB_PATH.exists():
        build()
    return duckdb.connect(str(DB_PATH), read_only=read_only)


if __name__ == "__main__":
    build()
