class Cell
  getter x : UInt32,
         y : UInt32

  property alive : Bool,
           next_state : (Bool | Nil) = nil,
           neighbours : Array(Cell) = [] of Cell

  def initialize(@x : UInt32, @y : UInt32, @alive : Bool = false)
  end

  def to_char
    @alive ? "o" : " "
  end

  def alive_neighbours
    # The following is the fastest
    neighbours.count(&.alive)

    # The following is about the same speed
    # alive_neighbours = 0
    # neighbours.each do |neighbour|
    #   alive_neighbours += 1 if neighbour.alive
    # end
    # alive_neighbours

    # The following is slower
    # alive_neighbours = 0
    # count = neighbours.size-1
    # 0.upto(count) do |i|
    #   neighbour = neighbours[i]
    #   alive_neighbours += 1 if neighbour.alive
    # end
    # alive_neighbours
  end
end
