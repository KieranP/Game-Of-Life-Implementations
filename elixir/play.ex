defmodule Play do
  @world_width 150
  @world_height 40

  def run do
    world =
      World.new(
        width: @world_width,
        height: @world_height
      )

    minimal = System.get_env("MINIMAL") != nil

    if !minimal do
      IO.puts(World.render(world))
    end

    # Elixir doesn't have continuous loops (i.e. while(true) {}),
    # so we need to use recursive function calls instead
    loop(world, minimal)
  end

  def loop(world, minimal \\ false, total_tick \\ 0, lowest_tick \\ 9**9**9, total_render \\ 0, lowest_render \\ 9**9**9) do
    tick_start = System.monotonic_time()
    world = World.tick(world)
    tick_finish = System.monotonic_time()
    tick_time = tick_finish - tick_start
    total_tick = total_tick + tick_time
    lowest_tick = Kernel.min(lowest_tick, tick_time)
    avg_tick = total_tick / world.tick

    render_start = System.monotonic_time()
    rendered = World.render(world)
    render_finish = System.monotonic_time()
    render_time = render_finish - render_start
    total_render = total_render + render_time
    lowest_render = Kernel.min(lowest_render, render_time)
    avg_render = total_render / world.tick

    if !minimal do
      IO.puts("\u001b[H\u001b[2J")
    end
    IO.puts(
      :io_lib.format(
        "#~.B - World Tick (L: ~.3f; A: ~.3f) - Rendering (L: ~.3f; A: ~.3f)",
        [
          world.tick,
          _f(lowest_tick),
          _f(avg_tick),
          _f(lowest_render),
          _f(avg_render)
        ]
      )
    )
    if !minimal do
      IO.puts(rendered)
    end

    loop(world, minimal, total_tick, lowest_tick, total_render, lowest_render)
  end

  def _f(value) do
    # value is in nanoseconds, convert to milliseconds
    value / 1_000_000
  end
end

Play.run()
