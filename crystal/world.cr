require "./cell"

class World
  getter tick : Int32 = 0

  @width : Int32
  @height : Int32
  @cells = {} of String => Cell

  private class LocationOccupied < Exception
    def initialize(@x : Int32, @y : Int32)
      super("LocationOccupied(#{@x}-#{@y})")
    end
  end

  private DIRECTIONS = [
    [-1, 1],  [0, 1],  [1, 1], # above
    [-1, 0],           [1, 0], # sides
    [-1, -1], [0, -1], [1, -1] # below
  ]

  def initialize(@width : Int32, @height : Int32)
    populate_cells
    prepopulate_neighbours
  end

  def _tick
    # First determine the action for all cells
    @cells.each_value do |cell|
      alive_neighbours = cell.alive_neighbours
      if !cell.alive && alive_neighbours == 3
        cell.next_state = true
      elsif alive_neighbours < 2 || alive_neighbours > 3
        cell.next_state = false
      else
        cell.next_state = cell.alive
      end
    end

    # Then execute the determined action for all cells
    @cells.each_value do |cell|
      cell.alive = !!cell.next_state
    end

    @tick += 1
  end

  # Implement first using string concatenation. Then implement any
  # special string builders, and use whatever runs the fastest
  def render
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

    # The following works but it slower
    # rendering = [] of String
    # @height.times.each { |y|
    #   @width.times.each { |x|
    #     cell = cell_at(x, y).not_nil!
    #     rendering << cell.to_char
    #   }
    #   rendering << "\n"
    # }
    # rendering.join("")

    # The following was the fastest method
    String.build(@height * @width) do |io|
      @height.times.each { |y|
        @width.times.each { |x|
          cell = cell_at(x, y).not_nil!
          io << cell.to_char
        }
        io << "\n"
      }
    end
  end

  private def cell_at(x : Int32, y : Int32)
    @cells["#{x}-#{y}"]?
  end

  private def populate_cells
    @height.times do |y|
      @width.times do |x|
        alive = (rand <= 0.2)
        add_cell(x, y, alive)
      end
    end
  end

  private def add_cell(x : Int32, y : Int32, alive : Bool = false)
    if cell_at(x, y)
      raise LocationOccupied.new(x, y)
    end

    cell = Cell.new(x, y, alive)
    @cells["#{x}-#{y}"] = cell
    true
  end

  private def prepopulate_neighbours
    @cells.each_value do |cell|
      cell.neighbours =
        DIRECTIONS.compact_map { |(rel_x, rel_y)|
          cell_at(
            (cell.x + rel_x),
            (cell.y + rel_y)
          )
        }
    end
  end
end
