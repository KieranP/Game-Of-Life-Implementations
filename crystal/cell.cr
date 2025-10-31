class Cell
  getter x : Int32,
         y : Int32

  property alive : Bool,
           next_state : (Bool | Nil) = nil,
           neighbours : Array(Cell) = [] of Cell

  def initialize(@x : Int32, @y : Int32, @alive : Bool = false)
  end

  def to_char
    @alive ? "o" : " "
  end

  # Implement first using filter/lambda if available. Then implement
  # foreach and for. Use whatever implementation runs the fastest
  def alive_neighbours
    # The following was the fastest method
    neighbours.count(&.alive)

    # The following works but is slower
    # alive_neighbours = 0
    # neighbours.each do |neighbour|
    #   alive_neighbours += 1 if neighbour.alive
    # end
    # alive_neighbours

    # The following works but is slower
    # alive_neighbours = 0
    # 0.upto(neighbours.size-1) do |i|
    #   neighbour = neighbours[i]
    #   alive_neighbours += 1 if neighbour.alive
    # end
    # alive_neighbours
  end
end
