require_relative 'world'

class Play
  @@WORLD_WIDTH  = 150
  @@WORLD_HEIGHT = 40

  def self.run
    world = World.new(
      width: @@WORLD_WIDTH,
      height: @@WORLD_HEIGHT,
    )

    minimal = !!ENV['MINIMAL']

    unless minimal
      puts world.render
    end

    total_tick = 0
    lowest_tick = Float::INFINITY
    total_render = 0
    lowest_render = Float::INFINITY

    while true
      tick_start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      world.dotick
      tick_finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      tick_time = (tick_finish - tick_start)
      total_tick += tick_time
      lowest_tick = [lowest_tick, tick_time].min
      avg_tick = (total_tick / world.tick)

      render_start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      rendered = world.render
      render_finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      render_time = (render_finish - render_start)
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

  def self._f(value)
    # seconds -> milliseconds
    value * 1_000
  end
  private_class_method :_f
end

Play.run
