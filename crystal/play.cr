require "./world"

class Play
  WORLD_WIDTH = 150_u32
  WORLD_HEIGHT = 40_u32
  CLEAR_SCREEN = "\x1b[?2026h\x1b[H\x1b[2J"
  SHOW_SCREEN = "\x1b[?2026l"

  def self.run
    world = World.new(
      width: WORLD_WIDTH,
      height: WORLD_HEIGHT,
    )

    minimal = ENV["MINIMAL"]?

    unless minimal
      puts world.render
    end

    total_tick = 0.0
    lowest_tick = Float64::INFINITY
    total_render = 0.0
    lowest_render = Float64::INFINITY

    loop do
      tick_start = Time.instant
      world.dotick
      tick_finish = Time.instant
      tick_time = (tick_finish - tick_start).total_nanoseconds
      total_tick += tick_time
      lowest_tick = Math.min(lowest_tick, tick_time)
      avg_tick = (total_tick / world.tick)

      render_start = Time.instant
      rendered = world.render
      render_finish = Time.instant
      render_time = (render_finish - render_start).total_nanoseconds
      total_render += render_time
      lowest_render = Math.min(lowest_render, render_time)
      avg_render = (total_render / world.tick)

      unless minimal
        print CLEAR_SCREEN
      end

      puts "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)" % {
        world.tick,
        _f(lowest_tick),
        _f(avg_tick),
        _f(lowest_render),
        _f(avg_render),
      }

      unless minimal
        puts rendered + SHOW_SCREEN
      end
    end
  end

  private def self._f(value)
    # nanoseconds -> milliseconds
    value / 1_000_000
  end
end

Play.run
