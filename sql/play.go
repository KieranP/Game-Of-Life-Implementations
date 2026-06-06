package main

import (
  "fmt"
  "math"
  "os"
  "time"
)

func run() {
  dbType := envOr("DB_TYPE", "sqlite")
  db := openDatabase(dbType)
  defer db.Close()

  initSQL := readFile(dbType + "/init.sql")
  tickSQL := readFile(dbType + "/tick.sql")
  renderSQL := readFile(dbType + "/render.sql")

  execSQL(db, initSQL)

  minimal := os.Getenv("MINIMAL") != ""

  if !minimal {
    fmt.Println(querySQL(db, renderSQL))
  }

  tickCount := 0
  var totalTick float64
  var lowestTick float64 = math.MaxFloat64
  var totalRender float64
  var lowestRender float64 = math.MaxFloat64

  for {
    tickCount++

    tickStart := time.Now()
    execSQL(db, tickSQL)
    tickFinish := time.Now()
    tickTime := float64(tickFinish.Sub(tickStart).Nanoseconds())
    totalTick += tickTime
    lowestTick = min(lowestTick, tickTime)
    avgTick := totalTick / float64(tickCount)

    renderStart := time.Now()
    rendered := querySQL(db, renderSQL)
    renderFinish := time.Now()
    renderTime := float64(renderFinish.Sub(renderStart).Nanoseconds())
    totalRender += renderTime
    lowestRender = min(lowestRender, renderTime)
    avgRender := totalRender / float64(tickCount)

    if !minimal {
      fmt.Print("\u001b[H\u001b[2J")
    }

    fmt.Printf(
      "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)\n",
      tickCount,
      _f(lowestTick),
      _f(avgTick),
      _f(lowestRender),
      _f(avgRender),
    )

    if !minimal {
      fmt.Println(rendered)
    }
  }
}

func _f(value float64) float64 {
  // nanoseconds -> milliseconds
  return value / 1_000_000
}

func main() {
  run()
}
