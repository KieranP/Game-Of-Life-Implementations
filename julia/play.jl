include("world.jl")
using Printf
using Dates

const WORLD_WIDTH = UInt64(150)
const WORLD_HEIGHT = UInt64(40)

function play()
  world = World(;
    width=WORLD_WIDTH,
    height=WORLD_HEIGHT,
  )

  minimal = haskey(ENV, "MINIMAL")

  if !minimal
    print(world_render(world))
  end

  total_tick = Float64(0)
  lowest_tick = typemax(Float64)
  total_render = Float64(0)
  lowest_render = typemax(Float64)

  while true
    tick_start = time_ns()
    world_tick(world)
    tick_finish = time_ns()
    tick_time = (tick_finish - tick_start)
    total_tick += tick_time
    lowest_tick = min(lowest_tick, tick_time)
    avg_tick = (total_tick / world.tick)

    render_start = time_ns()
    rendered = world_render(world)
    render_finish = time_ns()
    render_time = (render_finish - render_start)
    total_render += render_time
    lowest_render = min(lowest_render, render_time)
    avg_render = (total_render / world.tick)

    if !minimal
      print("\u001b[H\u001b[2J")
    end

    @printf(
      "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)\n",
      world.tick,
      _f(lowest_tick),
      _f(avg_tick),
      _f(lowest_render),
      _f(avg_render),
    )

    if !minimal
      print(rendered)
    end
  end
end

function _f(value::Float64)
  # nanoseconds -> milliseconds
  value / 1_000_000
end

play()
