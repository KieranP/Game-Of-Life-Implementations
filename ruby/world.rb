require 'stringio'

class World
  class LocationOccupied < Exception; end

  attr_accessor :tick

  def initialize(width:, height:)
    @width = width
    @height = height
    @tick = 0
    @cells = {}
    @cached_directions = [
      [-1, 1],  [0, 1],  [1, 1], # above
      [-1, 0],           [1, 0], # sides
      [-1, -1], [0, -1], [1, -1] # below
    ]

    populate_cells
    prepopulate_neighbours
  end

  def _tick
    # First determine the action for all cells
    @cells.each do |key, cell|
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
    @cells.each do |key, cell|
      cell.alive = cell.next_state
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
    #     rendering << cell_at(x, y).to_char
    #   }
    #   rendering << "\n"
    # }
    # rendering

    # The following was the fastest method
    rendering = []
    @height.times.each { |y|
      @width.times.each { |x|
        rendering << cell_at(x, y).to_char
      }
      rendering << "\n"
    }
    rendering.join

    # The following works but it slower
    # rendering = StringIO.new
    # @height.times.each { |y|
    #   @width.times.each { |x|
    #     rendering << cell_at(x, y).to_char
    #   }
    #   rendering << "\n"
    # }
    # rendering.string
  end

  private

  def populate_cells
    @height.times do |y|
      @width.times do |x|
        alive = (rand <= 0.2)
        add_cell(x, y, alive)
      end
    end
  end

  def prepopulate_neighbours
    @cells.each do |key, cell|
      neighbours_around(cell)
    end
  end

  def add_cell(x, y, alive = false)
    raise LocationOccupied if cell_at(x, y)
    cell = Cell.new(x, y, alive)
    @cells["#{x}-#{y}"] = cell
    cell_at(x, y)
  end

  def cell_at(x, y)
    @cells["#{x}-#{y}"]
  end

  def neighbours_around(cell)
    cell.neighbours ||= begin
      @cached_directions.filter_map { |rel_x, rel_y|
        cell_at(
          (cell.x + rel_x),
          (cell.y + rel_y)
        )
      }
    end
  end

  # Implement first using filter/lambda if available. Then implement
  # foreach and for. Use whatever implementation runs the fastest
  def alive_neighbours_around(cell)
    neighbours = neighbours_around(cell)

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

class Cell
  attr_accessor :x, :y, :alive, :next_state, :neighbours

  def initialize(x, y, alive = false)
    @x = x
    @y = y
    @alive = alive
    @next_state = nil
    @neighbours = nil
  end

  def to_char
    @alive ? 'o' : ' '
  end
end
