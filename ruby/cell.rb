class Cell
  attr_reader :x, :y
  attr_accessor :alive, :next_state, :neighbours

  def initialize(x, y, alive = false)
    @x = x
    @y = y
    @alive = alive
    @next_state = nil
    @neighbours = []
  end

  def to_char
    @alive ? 'o' : ' '
  end

  # Implement first using filter/lambda if available. Then implement
  # foreach and for. Use whatever implementation runs the fastest
  def alive_neighbours()
    # The following was the fastest method
    neighbours.count(&:alive)

    # The following works but is slower
    # alive_neighbours = 0
    # neighbours.each do |neighbour|
    #   alive_neighbours += 1 if neighbour.alive
    # end
    # alive_neighbours

    # The following works but is slower
    # alive_neighbours = 0
    # for i in 0...neighbours.size do
    #   neighbour = neighbours[i]
    #   alive_neighbours += 1 if neighbour.alive
    # end
    # alive_neighbours
  end
end
