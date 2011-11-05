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
  start = Time.now
  world.tick!
  finish = Time.now

  output = "##{world.tick} - World tick took #{finish - start}\n"
  output += render(world)
  system('clear')
  puts output
end
