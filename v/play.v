import os
import time
import math
import arrays

const world_width = 150
const world_height = 40

fn run() {
  mut world := new_world(
    world_width,
    world_height,
  )

  minimal := os.getenv("MINIMAL") != ""

  if !minimal {
    println(world.render())
  }

  mut total_tick := f64(0)
  mut lowest_tick := math.max_f64
  mut total_render := f64(0)
  mut lowest_render := math.max_f64

  for {
    tick_start := time.sys_mono_now()
    world.tick()
    tick_finish := time.sys_mono_now()
    tick_time := (tick_finish - tick_start)
    total_tick += tick_time
    lowest_tick = arrays.min([lowest_tick, tick_time]) or { lowest_tick }
    avg_tick := (total_tick / world.tick)

    render_start := time.sys_mono_now()
    rendered := world.render()
    render_finish := time.sys_mono_now()
    render_time := (render_finish - render_start)
    total_render += render_time
    lowest_render = arrays.min([lowest_render, render_time]) or { lowest_render }
    avg_render := (total_render / world.tick)

    if !minimal {
      print('\u001b[H\u001b[2J')
    }
    println(
      "#${world.tick}" +
      " - World Tick (L: ${f(lowest_tick):.3}; A: ${f(avg_tick):.3})" +
      " - Rendering (L: ${f(lowest_render):.3}; A: ${f(avg_render):.3})"
    )
    if !minimal {
      print(rendered)
    }
  }
}

fn f(value f64) f64 {
  // value is in nanoseconds, convert to milliseconds
  return value / 1_000_000
}

fn main() {
  run()
}
