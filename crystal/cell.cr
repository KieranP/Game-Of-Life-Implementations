class Cell
  getter x : UInt32,
         y : UInt32

  property alive : Bool,
           next_state : Bool? = nil,
           neighbours : Array(Cell) = [] of Cell

  def initialize(@x : UInt32, @y : UInt32, @alive : Bool = false)
  end

  def to_char
    @alive ? "o" : " "
  end

  def alive_neighbours : UInt32
    # The following is the fastest
    neighbours.count(&.alive).to_u32

    # The following is slower
    # alive_neighbours = 0_u32
    # neighbours.each do |neighbour|
    #   alive_neighbours += 1 if neighbour.alive
    # end
    # alive_neighbours

    # The following is slower
    # alive_neighbours = 0_u32
    # count = neighbours.size
    # (0...count).each do |i|
    #   neighbour = neighbours[i]
    #   alive_neighbours += 1 if neighbour.alive
    # end
    # alive_neighbours
  end
end
