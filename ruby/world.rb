require_relative 'cell'
require 'stringio'

class World
  attr_reader :tick

  class LocationOccupied < Exception
    def initialize(x, y)
      super("LocationOccupied(#{x}-#{y})")
    end
  end

  DIRECTIONS = [
    [-1, 1],  [0, 1],  [1, 1], # above
    [-1, 0],           [1, 0], # sides
    [-1, -1], [0, -1], [1, -1] # below
  ]

  def initialize(width:, height:)
    @tick = 0
    @width = width
    @height = height
    @cells = {}

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
      cell.alive = cell.next_state
    end

    @tick += 1
  end

  def render
    # The following is slower
    # rendering = ""
    # @height.times.each { |y|
    #   @width.times.each { |x|
    #     rendering << cell_at(x, y).to_char
    #   }
    #   rendering << "\n"
    # }
    # rendering

    # The following is the fastest
    rendering = []
    @height.times.each { |y|
      @width.times.each { |x|
        rendering << cell_at(x, y).to_char
      }
      rendering << "\n"
    }
    rendering.join

    # The following is slower
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

  def cell_at(x, y)
    @cells["#{x}-#{y}"]
  end

  def populate_cells
    @height.times do |y|
      @width.times do |x|
        alive = (rand <= 0.2)
        add_cell(x, y, alive)
      end
    end
  end

  def add_cell(x, y, alive = false)
    if cell_at(x, y)
      raise LocationOccupied.new(x, y)
    end

    cell = Cell.new(x, y, alive)
    @cells["#{x}-#{y}"] = cell
    true
  end

  def prepopulate_neighbours
    @cells.each_value do |cell|
      x = cell.x
      y = cell.y

      cell.neighbours =
        DIRECTIONS.filter_map { |rel_x, rel_y|
          nx = x + rel_x
          ny = y + rel_y
          if nx < 0 || ny < 0
            next # Out of bounds
          end

          if nx >= @width || ny >= @height
            next # Out of bounds
          end

          cell_at(nx, ny)
        }
    end
  end
end
