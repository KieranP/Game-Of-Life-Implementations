package main

import "core:fmt"
import "core:time"
import "core:math"

World_Width := 150
World_Height := 40

run :: proc() {
  world := new_world(
    width=World_Width,
    height=World_Height
  )

  fmt.println(world_render(world))

  total_tick: i64
  lowest_tick := math.INF_F64
  total_render: i64
  lowest_render := math.INF_F64

  for true {
    tick_start := time.tick_now()
    world_tick(world)
    tick_finish := time.tick_now()
    tick_time := time.duration_nanoseconds(time.tick_diff(tick_start, tick_finish))
    total_tick += tick_time
    lowest_tick = min(lowest_tick, f64(tick_time))
    avg_tick := total_tick / world.tick

    render_start := time.tick_now()
    rendered := world_render(world)
    render_finish := time.tick_now()
    render_time := time.duration_nanoseconds(time.tick_diff(render_start, render_finish))
    total_render += render_time
    lowest_render = min(lowest_render, f64(render_time))
    avg_render := total_render / world.tick

    fmt.print("\u001b[H\u001b[2J")
    fmt.printf(
      "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)\n",
      world.tick,
      _f(lowest_tick),
      _f(f64(avg_tick)),
      _f(lowest_render),
      _f(f64(avg_render)),
    )
    fmt.print(rendered)
  }
}

_f :: proc(value: f64) -> f64 {
  // value is in nanoseconds, convert to milliseconds
  return value / 1_000_000;
}

main :: proc() {
  run()
}
