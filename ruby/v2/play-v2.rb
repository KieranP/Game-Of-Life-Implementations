$:.push(File.dirname(__FILE__))

require 'game-v2'

world = World.new

# Randomized
150.times do |x|
  40.times do |y|
    world.add_cell(x: x, y: y, dead: (rand > 0.2))
  end
end

# Blinker - http://en.wikipedia.org/wiki/File:Game_of_life_blinker.gif
# Cell.new(world: world, x: 0, y: 1)
# Cell.new(world: world, x: 1, y: 1)
# Cell.new(world: world, x: 2, y: 1)
# Cell.new(world: world, x: 1, y: 0, dead: true)
# Cell.new(world: world, x: 1, y: 2, dead: true)

while true
  # system('clear')
  ((world.boundaries[:y][:min])..(world.boundaries[:y][:max])).each do |y|
    ((world.boundaries[:x][:min])..(world.boundaries[:x][:max])).each do |x|
      cell = world.cell_at(x: x, y: y)
      print (cell ? cell.to_char : ' ')
    end
    puts
  end
  b = Time.now
  world.tick!
  a = Time.now
  puts "##{world.tick} - World tick took #{a - b}"
end
