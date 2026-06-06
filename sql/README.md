# SQL

## Install

```bash
brew install sqlite3 postgresql
```

## Build

(no build step required)

## Run

### SQLite

```bash
DB_TYPE=sqlite \
./play.sh
```

### PostgreSQL

```bash
DB_TYPE=postgres \
PG_HOST=localhost \
PG_PORT=5432 \
PG_USER=postgres \
PG_PASSWORD=postgres \
PG_DATABASE=gol \
./play.sh
```

## Notes

- No support for continuous loops; fallback to a shell script (see play.sh).
- No support for pointers/references (see `neighbours` in init.sql).
- No support for native exceptions; emulated with the `PRIMARY KEY` constraint (see init.sql).
- Set-based rather than imperative, so each tick is a single UPDATE across all cells (see tick.sql).
