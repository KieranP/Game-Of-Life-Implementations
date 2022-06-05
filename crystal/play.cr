require "./world"

class Play

  # @@ makes this a private class variable
  @@World_Width  = 150
  @@World_Height = 40

  def self.run
    world = World.new(
      width: @@World_Width,
      height: @@World_Height,
    )

    puts world.render

    total_tick = 0
    total_render = 0

    while true
      tick_start = Time.utc.to_unix_f
      world._tick
      tick_finish = Time.utc.to_unix_f
      tick_time = (tick_finish - tick_start)
      total_tick += tick_time
      avg_tick = (total_tick / world.tick)

      render_start = Time.utc.to_unix_f
      rendered = world.render
      render_finish = Time.utc.to_unix_f
      render_time = (render_finish - render_start)
      total_render += render_time
      avg_render = (total_render / world.tick)

      output = "##{world.tick}"
      output += " - World tick took #{_f(tick_time * 1000)} (#{_f(avg_tick * 1000)})"
      output += " - Rendering took #{_f(render_time * 1000)} (#{_f(avg_render * 1000)})";
      output += "\n#{rendered}"
      puts "\u001b[H\u001b[2J"
      puts output
    end
  end

  private def self._f(value)
    "%.3f" % value
  end

end

Play.run
