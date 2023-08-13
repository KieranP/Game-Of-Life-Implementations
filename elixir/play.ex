defmodule Play do
  @world_width 150
  @world_height 40

  def run do
    world =
      World.new(
        width: @world_width,
        height: @world_height
      )

    IO.puts(World.render(world))

    # Elixir doesn't have continuous loops (i.e. while(true) {}),
    # so we need to use recursive function calls instead
    loop(world)
  end

  def loop(world, total_tick \\ 0, total_render \\ 0) do
    tick_start = System.system_time(:nanosecond)
    world = World.tick(world)
    tick_finish = System.system_time(:nanosecond)
    tick_time = tick_finish - tick_start
    total_tick = total_tick + tick_time
    avg_tick = total_tick / world.tick

    render_start = System.system_time(:nanosecond)
    rendered = World.render(world)
    render_finish = System.system_time(:nanosecond)
    render_time = render_finish - render_start
    total_render = total_render + render_time
    avg_render = total_render / world.tick

    IO.puts("\u001b[H\u001b[2J")
    IO.puts(
      :io_lib.format(
        "#~.B - World tick took ~.3f (~.3f) - Rendering took ~.3f (~.3f)\n",
        [
          world.tick,
          tick_time / 1_000_000,
          avg_tick / 1_000_000,
          render_time / 1_000_000,
          avg_render / 1_000_000
        ]
      )
    )
    IO.puts(rendered)

    loop(world, total_tick, total_render)
  end
end

Play.run()
