$:.push(File.dirname(__FILE__))

require 'game-v3'

def setup_world
  @world = World.new
  150.times do |x|
    40.times do |y|
      @world.add_cell(x: x, y: y, dead: (rand > 0.2))
    end
  end
end

def render_world
  ((@world.boundaries[:y][:min])..(@world.boundaries[:y][:max])).collect { |y|
    ((@world.boundaries[:x][:min])..(@world.boundaries[:x][:max])).collect { |x|
      cell = @world.cell_at(x: x, y: y)
      (cell ? cell.to_char : ' ')
    }.join
  }.join("\n")
end

setup_world
render_world

while true
  start = Time.now
  @world.tick!
  finish = Time.now

  output = render_world
  system('clear')
  puts "##{@world.tick} - World tick took #{finish - start}"
  puts output
end
