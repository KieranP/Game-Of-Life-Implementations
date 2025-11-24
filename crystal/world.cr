require "./cell"

class World
  getter tick : UInt32 = 0

  @width : UInt32
  @height : UInt32
  @cells = {} of String => Cell

  private class LocationOccupied < Exception
    def initialize(@x : UInt32, @y : UInt32)
      super("LocationOccupied(#{@x}-#{@y})")
    end
  end

  private DIRECTIONS = [
    [-1, 1],  [0, 1],  [1, 1], # above
    [-1, 0],           [1, 0], # sides
    [-1, -1], [0, -1], [1, -1] # below
  ]

  def initialize(@width : UInt32, @height : UInt32)
    populate_cells
    prepopulate_neighbours
  end

  def dotick
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

  def render
    # This following is slower
    # rendering = ""
    # @height.times.each { |y|
    #   @width.times.each { |x|
    #     cell = cell_at(x, y)
    #     if cell
    #       rendering += cell.to_char
    #     end
    #   }
    #   rendering += "\n"
    # }
    # rendering

    # The following is slower
    # rendering = [] of String
    # @height.times.each { |y|
    #   @width.times.each { |x|
    #     cell = cell_at(x, y)
    #     if cell
    #       rendering << cell.to_char
    #     end
    #   }
    #   rendering << "\n"
    # }
    # rendering.join("")

    # The following is the fastest
    render_size = @width * @height + @height
    String.build(render_size) do |io|
      @height.times.each { |y|
        @width.times.each { |x|
          cell = cell_at(x, y)
          if cell
            io << cell.to_char
          end
        }
        io << "\n"
      }
    end
  end

  private def cell_at(x : UInt32, y : UInt32)
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

  private def add_cell(x : UInt32, y : UInt32, alive : Bool = false)
    existing = cell_at(x, y)
    if existing
      raise LocationOccupied.new(x, y)
    end

    cell = Cell.new(x, y, alive)
    @cells["#{x}-#{y}"] = cell
    true
  end

  private def prepopulate_neighbours
    @cells.each_value do |cell|
      x = Int64.new(cell.x)
      y = Int64.new(cell.y)

      cell.neighbours =
        DIRECTIONS.compact_map do |(rel_x, rel_y)|
          nx = x + rel_x
          ny = y + rel_y
          if nx < 0 || ny < 0
            next # Out of bounds
          end

          ux = UInt32.new(nx)
          uy = UInt32.new(ny)
          if ux >= @width || uy >= @height
            next # Out of bounds
          end

          cell_at(ux, uy)
        end
    end
  end
end
