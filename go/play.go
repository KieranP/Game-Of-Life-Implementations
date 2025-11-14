package main

import (
  "fmt"
  "math"
  "os"
  "time"
)

const WORLD_WIDTH = uint32(150)
const WORLD_HEIGHT = uint32(40)

func run() {
  world := new_world(
    WORLD_WIDTH,
    WORLD_HEIGHT,
  )

  minimal := os.Getenv("MINIMAL") != ""

  if !minimal {
    fmt.Print(world.render())
  }

  var total_tick float64
  var lowest_tick float64 = math.MaxFloat64
  var total_render float64
  var lowest_render float64 = math.MaxFloat64

  for true {
    tick_start := time.Now()
    world._tick()
    tick_finish := time.Now()
    tick_time := float64(tick_finish.Sub(tick_start).Nanoseconds())
    total_tick += tick_time
    lowest_tick = min(lowest_tick, tick_time)
    avg_tick := total_tick / float64(world.tick)

    render_start := time.Now()
    rendered := world.render()
    render_finish := time.Now()
    render_time := float64(render_finish.Sub(render_start).Nanoseconds())
    total_render += render_time
    lowest_render = min(lowest_render, render_time)
    avg_render := total_render / float64(world.tick)

    if !minimal {
      fmt.Print("\u001b[H\u001b[2J")
    }

    fmt.Printf(
      "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)\n",
      world.tick,
      _f(lowest_tick),
      _f(avg_tick),
      _f(lowest_render),
      _f(avg_render),
    )

    if !minimal {
      fmt.Print(rendered)
    }
  }
}

func _f(value float64) float64 {
  // nanoseconds -> milliseconds
  return float64(value) / 1_000_000
}

func main() {
  run()
}
