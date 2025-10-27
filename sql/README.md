# SQL

## Installation

### SQLite

* `brew install sqlite3`

### PostgreSQL

* `brew install postgresql`

## Usage

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
