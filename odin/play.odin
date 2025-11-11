package main

import "core:os"
import "core:fmt"
import "core:time"
import "core:math"

WORLD_WIDTH := u32(150)
WORLD_HEIGHT := u32(40)

run :: proc() {
  world := new_world(
    width=WORLD_WIDTH,
    height=WORLD_HEIGHT,
  )

  minimal := os.get_env("MINIMAL") != ""

  if !minimal {
    rendered := world_render(world)
    defer delete(rendered)
    fmt.println(rendered)
  }

  total_tick: f64
  lowest_tick := max(f64)
  total_render: f64
  lowest_render := max(f64)

  for true {
    tick_start := time.tick_now()
    world_tick(world)
    tick_finish := time.tick_now()
    tick_time := f64(time.duration_nanoseconds(time.tick_diff(tick_start, tick_finish)))
    total_tick += tick_time
    lowest_tick = min(lowest_tick, tick_time)
    avg_tick := total_tick / f64(world.tick)

    render_start := time.tick_now()
    rendered := world_render(world)
    defer delete(rendered)
    render_finish := time.tick_now()
    render_time := f64(time.duration_nanoseconds(time.tick_diff(render_start, render_finish)))
    total_render += render_time
    lowest_render = min(lowest_render, render_time)
    avg_render := total_render / f64(world.tick)

    if !minimal {
      fmt.print("\u001b[H\u001b[2J")
    }

    fmt.printf(
      "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)\n",
      world.tick,
      _f(lowest_tick),
      _f(avg_tick),
      _f(lowest_render),
      _f(avg_render),
    )

    if !minimal {
      fmt.print(rendered)
    }
  }
}

_f :: proc(value: f64) -> f64 {
  // nanoseconds -> milliseconds
  return value / 1_000_000;
}

main :: proc() {
  run()
}
