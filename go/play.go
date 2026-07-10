package main

import (
  "fmt"
  "math"
  "os"
  "time"
)

const worldWidth = uint32(150)
const worldHeight = uint32(40)
const clearScreen = "\x1b[?2026h\x1b[H\x1b[2J"
const showScreen = "\x1b[?2026l"

func run() {
  world := newWorld(
    worldWidth,
    worldHeight,
  )

  minimal := os.Getenv("MINIMAL") != ""

  if !minimal {
    fmt.Print(world.render())
  }

  var totalTick float64
  var lowestTick float64 = math.MaxFloat64
  var totalRender float64
  var lowestRender float64 = math.MaxFloat64

  for {
    tickStart := time.Now()
    world.doTick()
    tickFinish := time.Now()
    tickTime := float64(tickFinish.Sub(tickStart).Nanoseconds())
    totalTick += tickTime
    lowestTick = min(lowestTick, tickTime)
    avgTick := totalTick / float64(world.tick)

    renderStart := time.Now()
    rendered := world.render()
    renderFinish := time.Now()
    renderTime := float64(renderFinish.Sub(renderStart).Nanoseconds())
    totalRender += renderTime
    lowestRender = min(lowestRender, renderTime)
    avgRender := totalRender / float64(world.tick)

    if !minimal {
      fmt.Print(clearScreen)
    }

    fmt.Printf(
      "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)\n",
      world.tick,
      _f(lowestTick),
      _f(avgTick),
      _f(lowestRender),
      _f(avgRender),
    )

    if !minimal {
      fmt.Print(rendered + showScreen)
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
