"""Run a .sql file against the project database and print each statement's result.

    python -m hoops.sql projects/01-box-score/sql/04_team_score.sql

Several files run in order on ONE connection, so a temp view created in the first file
is visible in the next:

    python -m hoops.sql projects/01-box-score/sql/03_players.sql projects/01-box-score/sql/05_box_score.sql

Statements are split on ';'. Every statement that returns rows is printed.
"""

import sys
from pathlib import Path

from hoops.db import connect


def run(path: str, con=None) -> None:
    con = con or connect()
    text = Path(path).read_text()
    for stmt in (s.strip() for s in text.split(";")):
        # Skip empty chunks and chunks that are only comments.
        if not any(line.strip() and not line.strip().startswith("--")
                   for line in stmt.splitlines()):
            continue
        result = con.sql(stmt)
        if result is not None:
            result.show(max_rows=60, max_width=200)


if __name__ == "__main__":
    con = connect()
    for p in sys.argv[1:]:
        print(f"== {p}")
        run(p, con)
