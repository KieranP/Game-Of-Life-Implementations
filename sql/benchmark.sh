#!/bin/bash

source ../helpers.sh

# The sampler sees only the Go client, not the PostgreSQL backend that holds
# the world, so its Max RSS would understate memory
if [ "${MODE}" = "memory" ]; then
  echo "SQL - skipped, memory mode not applicable"
  exit 0
fi

compile go build -o play .

# go-sqlite3 compiles in its own SQLite, which can differ from the sqlite3 CLI's
sqlite_driver=github.com/mattn/go-sqlite3
sqlite_dir=$(go list -m -f '{{.Dir}}' $sqlite_driver)
sqlite_version=$(grep -m1 '#define SQLITE_VERSION ' "$sqlite_dir/sqlite3-binding.h" | cut -d'"' -f2)
echo -n "SQL - SQLite - SQLite $sqlite_version, "
go list -m $sqlite_driver
DB_TYPE=sqlite benchmark ./play

echo ""

echo -n "SQL - PostgreSQL - "
go list -m github.com/lib/pq
DB_TYPE=postgres benchmark ./play
