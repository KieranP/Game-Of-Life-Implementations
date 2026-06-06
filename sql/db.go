package main

import (
  "database/sql"
  "fmt"
  "os"
  "strings"

  "github.com/lib/pq"
  _ "github.com/mattn/go-sqlite3"
)

// Hold a single database connection open for the whole run (other
// implementations keep the world in memory between ticks; reconnecting per
// tick is overhead none of them pay).
func openDatabase(dbType string) *sql.DB {
  var db *sql.DB

  if dbType == "postgres" {
    database := envOr("PG_DATABASE", "gol")

    admin := connect("postgres", pgDSN("postgres"))
    execSQL(admin, "DROP DATABASE IF EXISTS "+pq.QuoteIdentifier(database)+" WITH (FORCE)")
    execSQL(admin, "CREATE DATABASE "+pq.QuoteIdentifier(database))
    admin.Close()

    db = connect("postgres", pgDSN(database))
  } else {
    os.Remove("gol.db")
    os.Remove("gol.db-journal") // left behind if a previous run was killed mid-commit

    db = connect("sqlite3", "gol.db")
  }

  db.SetMaxOpenConns(1)
  return db
}

func pgDSN(database string) string {
  dsn := fmt.Sprintf(
    "host=%s port=%s user=%s dbname=%s sslmode=disable",
    envOr("PG_HOST", "localhost"),
    envOr("PG_PORT", "5432"),
    envOr("PG_USER", "postgres"),
    database,
  )

  if password := os.Getenv("PG_PASSWORD"); password != "" {
    escaper := strings.NewReplacer(`\`, `\\`, `'`, `\'`)
    dsn += " password='" + escaper.Replace(password) + "'"
  }

  return dsn
}

func querySQL(db *sql.DB, query string) string {
  rows, err := db.Query(query)
  if err != nil {
    panic(err)
  }
  defer rows.Close()

  var builder strings.Builder
  first := true
  for rows.Next() {
    var line string
    if err := rows.Scan(&line); err != nil {
      panic(err)
    }
    if !first {
      builder.WriteString("\n")
    }
    builder.WriteString(line)
    first = false
  }
  if err := rows.Err(); err != nil {
    panic(err)
  }

  return builder.String()
}

func connect(driver string, dsn string) *sql.DB {
  db, err := sql.Open(driver, dsn)
  if err != nil {
    panic(err)
  }
  return db
}

func execSQL(db *sql.DB, query string) {
  if _, err := db.Exec(query); err != nil {
    panic(err)
  }
}
