$:.push(File.dirname(__FILE__))

require 'game'

class Play

  World_Width  = 150
  World_Height = 40

  def self.run
    world = World.new(
      width: World_Width,
      height: World_Height,
    )

    puts world.render

    total_tick = 0
    total_render = 0

    while true
      tick_start = Time.now
      world._tick
      tick_finish = Time.now
      tick_time = (tick_finish - tick_start).round(5)
      total_tick += tick_time
      avg_tick = (total_tick / world.tick).round(5)

      render_start = Time.now
      rendered = world.render
      render_finish = Time.now
      render_time = (render_finish - render_start).round(5)
      total_render += render_time
      avg_render = (total_render / world.tick).round(5)

      output = "##{world.tick}"
      output += " - World tick took #{tick_time} (#{avg_tick})"
      output += " - Rendering took #{render_time} (#{avg_render})";
      output += "\n#{rendered}"
      system('clear')
      puts output
    end
  end

end

Play.run
