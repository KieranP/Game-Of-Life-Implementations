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
      cell.alive = cell.next_state
    end

    @tick += 1
  end

  def render
    # The following is slower
    # rendering = ""
    # @height.times.each { |y|
    #   @width.times.each { |x|
    #     cell = cell_at(x, y)
    #     if cell
    #       rendering << cell.to_char
    #     end
    #   }
    #   rendering << "\n"
    # }
    # rendering

    # The following is the fastest
    rendering = []
    @height.times.each { |y|
      @width.times.each { |x|
        cell = cell_at(x, y)
        if cell
          rendering << cell.to_char
        end
      }
      rendering << "\n"
    }
    rendering.join

    # The following is slower
    # rendering = StringIO.new
    # @height.times.each { |y|
    #   @width.times.each { |x|
    #     cell = cell_at(x, y)
    #     if cell
    #       rendering << cell.to_char
    #     end
    #   }
    #   rendering << "\n"
    # }
    # rendering.string
  end

  private

  def make_key(x, y)
    # The following is the fastest
    "#{x}-#{y}"

    # The following is slower
    # x.to_s + '-' + y.to_s

    # The following is slower
    # [x, y].join('-')
  end

  def cell_at(x, y)
    key = make_key(x, y)
    @cells[key]
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
    existing = cell_at(x, y)
    if existing
      raise LocationOccupied.new(x, y)
    end

    key = make_key(x, y)
    cell = Cell.new(x, y, alive)
    @cells[key] = cell
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
