$:.push(File.dirname(__FILE__))

require 'game'

World_Width  = 150
World_Height = 40

def render(world)
  World_Height.times.collect { |y|
    World_Width.times.collect { |x|
      world.cell_at(x, y).to_char
    }.join
  }.join("\n")
end

world = World.new

# Prepopulate the cells
World_Height.times do |y|
  World_Width.times do |x|
    alive = (rand <= 0.2)
    world.add_cell(x, y, alive)
  end
end

# Prepopulate the neighbours
World_Height.times do |y|
  World_Width.times do |x|
    cell = world.cell_at(x, y)
    world.neighbours_around(cell)
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
