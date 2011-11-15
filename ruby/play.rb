$:.push(File.dirname(__FILE__))

require 'game'

def render(world)
  ((world.boundaries[:y][:min])..(world.boundaries[:y][:max])).collect { |y|
    ((world.boundaries[:x][:min])..(world.boundaries[:x][:max])).collect { |x|
      cell = world.cell_at(x, y)
      (cell ? cell.to_char : ' ')
    }.join
  }.join("\n")
end

world = World.new
150.times do |x|
  40.times do |y|
    world.add_cell(x, y, (rand > 0.2))
  end
end

puts render(world)

while true
  tick_start = Time.now
  world.tick!
  tick_finish = Time.now
  tick_time = (tick_finish - tick_start).round(3);

  render_start = Time.now
  rendered = render(world)
  render_finish = Time.now
  render_time = (render_finish - render_start).round(3);

  output = "##{world.tick}"
  output += " - World tick took #{tick_time}"
  output += " - Rendering took #{render_time}";
  output += "\n#{rendered}"
  system('clear')
  puts output
end
