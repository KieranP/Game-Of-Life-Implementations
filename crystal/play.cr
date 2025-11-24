require "./world"

class Play
  @@WORLD_WIDTH : UInt32 = 150
  @@WORLD_HEIGHT : UInt32 = 40

  def self.run
    world = World.new(
      width: @@WORLD_WIDTH,
      height: @@WORLD_HEIGHT,
    )

    minimal = ENV["MINIMAL"]?

    unless minimal
      puts world.render
    end

    total_tick = 0.0
    lowest_tick = Float64::INFINITY
    total_render = 0.0
    lowest_render = Float64::INFINITY

    while true
      tick_start = Time.monotonic
      world.dotick
      tick_finish = Time.monotonic
      tick_time = (tick_finish - tick_start).total_nanoseconds
      total_tick += tick_time
      lowest_tick = [lowest_tick, tick_time].min
      avg_tick = (total_tick / world.tick)

      render_start = Time.monotonic
      rendered = world.render
      render_finish = Time.monotonic
      render_time = (render_finish - render_start).total_nanoseconds
      total_render += render_time
      lowest_render = [lowest_render, render_time].min
      avg_render = (total_render / world.tick)

      unless minimal
        puts "\u001b[H\u001b[2J"
      end

      puts sprintf(
        "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)",
        world.tick,
        _f(lowest_tick),
        _f(avg_tick),
        _f(lowest_render),
        _f(avg_render)
      )

      unless minimal
        puts rendered
      end
    end
  end

  private def self._f(value)
    # nanoseconds -> milliseconds
    value / 1_000_000
  end
end

Play.run
