class World

  class LocationOccupied < Exception; end

  property width : Int32,
           height : Int32,
           tick : Int32 = 0,
           cells = {} of String => Cell,
           cached_directions = [
             [-1, 1],  [0, 1],  [1, 1], # above
             [-1, 0],           [1, 0], # sides
             [-1, -1], [0, -1], [1, -1] # below
           ]

  def initialize(@width : Int32, @height : Int32) : Nil
    populate_cells
    prepopulate_neighbours
  end

  def _tick : Nil
    # First determine the action for all cells
    @cells.each do |(key, cell)|
      alive_neighbours = alive_neighbours_around(cell)
      if !cell.alive && alive_neighbours == 3
        cell.next_state = true
      elsif alive_neighbours < 2 || alive_neighbours > 3
        cell.next_state = false
      else
        cell.next_state = cell.alive
      end
    end

    # Then execute the determined action for all cells
    @cells.each do |(key, cell)|
      cell.alive = !!cell.next_state
    end

    @tick += 1
  end

  # Implement first using string concatenation. Then implement any
  # special string builders, and use whatever runs the fastest
  def render : String
    # The following works but it slower
    # rendering = ""
    # @height.times.each { |y|
    #   @width.times.each { |x|
    #     cell = cell_at(x, y).not_nil!
    #     rendering += cell.to_char
    #   }
    #   rendering += "\n"
    # }
    # rendering

    # The following was the fastest method
    rendering = [] of String
    @height.times.each { |y|
      @width.times.each { |x|
        cell = cell_at(x, y).not_nil!
        rendering << cell.to_char
      }
      rendering << "\n"
    }
    rendering.join("")

    # The following works but it slower
    # String.build do |io|
    #   @height.times.each { |y|
    #     @width.times.each { |x|
    #       cell = cell_at(x, y).not_nil!
    #       io << cell.to_char
    #     }
    #     io << "\n"
    #   }
    # end
  end

  private def populate_cells : Nil
    @height.times do |y|
      @width.times do |x|
        alive = (rand <= 0.2)
        add_cell(x, y, alive)
      end
    end
  end

  private def prepopulate_neighbours : Nil
    @cells.each do |key, cell|
      neighbours_around(cell)
    end
  end

  private def add_cell(x : Int32, y : Int32, alive : Bool = false) : Cell
    raise LocationOccupied.new if cell_at(x, y)
    cell = Cell.new(x, y, alive)
    @cells["#{x}-#{y}"] = cell
    cell_at(x, y).not_nil!
  end

  private def cell_at(x : Int32, y : Int32) : (Cell | Nil)
    @cells["#{x}-#{y}"]?
  end

  private def neighbours_around(cell : Cell) : Array(Cell)
    cell.neighbours ||= begin
      @cached_directions.compact_map { |(rel_x, rel_y)|
        cell_at(
          (cell.x + rel_x),
          (cell.y + rel_y)
        )
      }
    end
  end

  # Implement first using filter/lambda if available. Then implement
  # foreach and for. Use whatever implementation runs the fastest
  private def alive_neighbours_around(cell) : Int32
    # The following was the fastest method
    neighbours_around(cell).count { |cell| cell.alive }

    # The following works but is slower
    # alive_neighbours = 0
    # neighbours_around(cell).each do |neighbour|
    #   alive_neighbours += 1 if neighbour.alive
    # end
    # alive_neighbours
  end

end

class Cell

  property x : Int32,
           y : Int32,
           alive : Bool,
           next_state : (Bool | Nil) = nil,
           neighbours : (Array(Cell) | Nil) = nil

  def initialize(@x : Int32, @y : Int32, @alive : Bool = false) : Nil
  end

  def to_char : String
    @alive ? "o" : " "
  end

end
