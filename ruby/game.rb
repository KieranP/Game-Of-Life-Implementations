class World

  class LocationOccupied < Exception; end

  attr_accessor :tick

  def initialize(width:, height:)
    @width = width
    @height = height
    @tick = 0
    @cells = Hash.new
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
        cell.next_state = 1
      elsif alive_neighbours < 2 || alive_neighbours > 3
        cell.next_state = 0
      end
    end

    # Then execute the determined action for all cells
    @cells.each do |key, cell|
      if cell.next_state == 1
        cell.alive = true
      elsif cell.next_state == 0
        cell.alive = false
      end
    end

    @tick += 1
  end

  def render
    @height.times.collect { |y|
      @width.times.collect { |x|
        cell_at(x, y).to_char
      }.join
    }.join("\n")
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
      @cached_directions.collect { |rel_x, rel_y|
        cell_at(
          (cell.x + rel_x),
          (cell.y + rel_y)
        )
      }.compact
    end
  end

  # Implement first using filter/lambda if available. Then implement
  # foreach and for. Retain whatever implementation runs the fastest
  def alive_neighbours_around(cell)
    neighbours_around(cell).count(&:alive)
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
