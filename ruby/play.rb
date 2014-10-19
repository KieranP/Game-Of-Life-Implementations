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

# Prepopulate the cells
150.times do |x|
  40.times do |y|
    world.add_cell(x, y, (rand <= 0.2))
  end
end

# Prepopulate the neighbours
150.times do |x|
  40.times do |y|
    world.neighbours_around(world.cell_at(x, y))
  end
end

puts render(world)

total_tick = 0
total_render = 0

while true
  tick_start = Time.now
  world.tick!
  tick_finish = Time.now
  tick_time = (tick_finish - tick_start).round(5)
  total_tick += tick_time
  avg_tick = (total_tick / world.tick).round(5)

  render_start = Time.now
  rendered = render(world)
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
