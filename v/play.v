import os
import time
import math

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
  mut lowest_tick := math.inf(1)
  mut total_render := f64(0)
  mut lowest_render := math.inf(1)

  for {
    tick_start := time.sys_mono_now()
    world.tick()
    tick_finish := time.sys_mono_now()
    tick_time := (tick_finish - tick_start)
    total_tick += tick_time
    lowest_tick = math.min(lowest_tick, tick_time)
    avg_tick := (total_tick / world.tick)

    render_start := time.sys_mono_now()
    rendered := world.render()
    render_finish := time.sys_mono_now()
    render_time := (render_finish - render_start)
    total_render += render_time
    lowest_render = math.min(lowest_render, render_time)
    avg_render := (total_render / world.tick)

    if !minimal {
      print('\u001b[H\u001b[2J')
    }

    println(
      "#${world.tick}" +
      " - World Tick (L: ${f(lowest_tick):.3f}; A: ${f(avg_tick):.3f})" +
      " - Rendering (L: ${f(lowest_render):.3f}; A: ${f(avg_render):.3f})"
    )

    if !minimal {
      print(rendered)
    }
  }
}

fn f(value f64) f64 {
  // nanoseconds -> milliseconds
  return value / 1_000_000
}

fn main() {
  run()
}
