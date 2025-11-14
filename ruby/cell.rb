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

  def alive_neighbours()
    # The following is the fastest
    neighbours.count(&:alive)

    # The following is slower
    # alive_neighbours = 0
    # neighbours.each do |neighbour|
    #   alive_neighbours += 1 if neighbour.alive
    # end
    # alive_neighbours

    # The following is slower
    # alive_neighbours = 0
    # count = neighbours.size
    # for i in 0...count do
    #   neighbour = neighbours[i]
    #   alive_neighbours += 1 if neighbour.alive
    # end
    # alive_neighbours
  end
end
