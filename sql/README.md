# SQL

## Install

```bash
brew install go postgresql@18
brew services start postgresql@18
$(brew --prefix postgresql@18)/bin/createuser -s postgres
```

## Build

```bash
go build -o play .
```

## Run

### SQLite

```bash
DB_TYPE=sqlite \
./play
```

### PostgreSQL

```bash
DB_TYPE=postgres \
PG_HOST=localhost \
PG_PORT=5432 \
PG_USER=postgres \
PG_PASSWORD=postgres \
PG_DATABASE=gol \
./play
```

## Notes

- Set-based rather than imperative, so each tick is three `UPDATE`s (reset,
  scatter, flip) rather than a loop over cells (see tick.sql).
- No support for pointers/shared references (see `neighbours` in init.sql).
- No support for continuous loops; fallback to a Go runner holding a single
  connection (see play.go).
- No support for native exceptions; emulated with the `PRIMARY KEY` constraint
  (see init.sql).
