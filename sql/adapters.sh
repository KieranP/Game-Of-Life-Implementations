#!/bin/bash

DB_TYPE=${DB_TYPE:-sqlite}

if [ "$DB_TYPE" = "postgres" ]; then
  PG_HOST=${PG_HOST:-localhost}
  PG_PORT=${PG_PORT:-5432}
  PG_USER=${PG_USER:-postgres}
  PG_PASSWORD=${PG_PASSWORD:-}
  PG_DATABASE=${PG_DATABASE:-gol}

  PSQL_CMD="psql -h $PG_HOST -p $PG_PORT -U $PG_USER -d $PG_DATABASE -q"
  if [ -n "$PG_PASSWORD" ]; then
    export PGPASSWORD="$PG_PASSWORD"
  fi

  DB_CMD="$PSQL_CMD -t"

  dropdb --if-exists --force $PG_DATABASE;
  createdb $PG_DATABASE;
else
  DB_FILE="gol.db"
  DB_CMD="sqlite3 $DB_FILE"

  rm -f "$DB_FILE"
fi
