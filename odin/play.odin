package main

import "core:fmt"
import "core:time"

World_Width := 150
World_Height := 40

run :: proc() {
  world := new_world(
    width=World_Width,
    height=World_Height
  )

  fmt.println(world_render(world))

  total_tick: i64
  total_render: i64

  for true {
    tick_start := time.now()
    world_tick(world)
    tick_finish := time.now()
    tick_time := time.duration_nanoseconds(time.diff(tick_start, tick_finish))
    total_tick += tick_time
    avg_tick := total_tick / world.tick

    render_start := time.now()
    rendered := world_render(world)
    render_finish := time.now()
    render_time := time.duration_nanoseconds(time.diff(render_start, render_finish))
    total_render += render_time
    avg_render := total_render / world.tick

    fmt.println("\u001b[H\u001b[2J")
    fmt.printf("#%d - World tick took %.3f (%.3f) - Rendering took %.3f (%.3f)\n",
      world.tick,
      f64(tick_time) / 1000000,
      f64(avg_tick) / 1000000,
      f64(render_time) / 1000000,
      f64(avg_render) / 1000000,
    )
    fmt.println(rendered)
  }
}

main :: proc() {
  run()
}
