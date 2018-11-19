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
      tick_start = Time.now.to_unix_f
      world._tick
      tick_finish = Time.now.to_unix_f
      tick_time = (tick_finish - tick_start)
      total_tick += tick_time
      avg_tick = (total_tick / world.tick)

      render_start = Time.now.to_unix_f
      rendered = world.render
      render_finish = Time.now.to_unix_f
      render_time = (render_finish - render_start)
      total_render += render_time
      avg_render = (total_render / world.tick)

      output = "##{world.tick}"
      output += " - World tick took #{_f(tick_time)} (#{_f(avg_tick)})"
      output += " - Rendering took #{_f(render_time)} (#{_f(avg_render)})";
      output += "\n#{rendered}"
      system("clear")
      puts output
    end
  end

  private def self._f(value)
    "%.5f" % value.round(5)
  end

end

Play.run
