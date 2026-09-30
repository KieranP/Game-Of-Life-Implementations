#!/bin/bash

source ../helpers.sh

# The sampler sees only the Go client, not the PostgreSQL backend that holds
# the world, so its Max RSS would understate memory
if [ "${MODE}" = "memory" ]; then
  echo "SQL - skipped, memory mode not applicable"
  exit 0
fi

compile go build -o play .

echo -n "SQL - SQLite - "
sqlite3 --version | head -n 1
DB_TYPE=sqlite benchmark ./play

echo ""

echo -n "SQL - PostgreSQL - "
psql --version | head -n 1
DB_TYPE=postgres benchmark ./play
