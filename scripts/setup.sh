#!/usr/bin/env bash
# One-command setup. Safe to re-run.
#
# Data: if you already have the SkillCorner repo downloaded somewhere, point at it with
#   ACB_DATA_DIR=/path/to/opendata-basketball ./scripts/setup.sh
# and it is linked instead of downloaded again. Otherwise one game (114243) is fetched.
set -euo pipefail
cd "$(dirname "$0")/.."

echo "==> python env"
python3 -m venv .venv
.venv/bin/python -m pip install -q --upgrade pip
.venv/bin/pip install -q -e ".[dev]"

echo "==> data"
mkdir -p data/raw
if [[ -e data/raw/opendata-basketball ]]; then
  echo "  data/raw/opendata-basketball already present"
elif [[ -n "${ACB_DATA_DIR:-}" ]]; then
  ln -s "$ACB_DATA_DIR" data/raw/opendata-basketball
  echo "  linked data/raw/opendata-basketball -> $ACB_DATA_DIR"
else
  ./scripts/fetch_data.sh 114243
fi

echo
echo "Done. Activate with:  source .venv/bin/activate"
echo "Pull more games with: ./scripts/fetch_data.sh <gameId> [<gameId> ...]   (or --all, ~400 MB)"
