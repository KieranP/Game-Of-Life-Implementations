class World

  class LocationOccupied < Exception; end

  attr_accessor :tick, :cells

  def initialize
    reset!
  end

  def add_cell(x, y, alive = false)
    raise LocationOccupied if self.cell_at(x, y)
    @boundaries = nil # so it recomputes
    @cells["#{x}-#{y}"] = Cell.new(x, y, alive)
  end

  def cell_at(x, y)
    @cells["#{x}-#{y}"]
  end

  def neighbours_around(cell)
    cell.neighbours ||= begin
      @directions.collect { |rel_x, rel_y|
        self.cell_at((cell.x + rel_x), (cell.y + rel_y))
      }.compact
    end
  end

  def alive_neighbours_around(cell)
    cell.neighbours.count(&:alive)
  end

  def tick!
    cells = @cells.values

    # First determine the action for all cells
    cells.each do |cell|
      alive_neighbours = self.alive_neighbours_around(cell)
      if !cell.alive && alive_neighbours == 3
        cell.next_state = 1
      elsif alive_neighbours < 2 || alive_neighbours > 3
        cell.next_state = 0
      end
    end

    # Then execute the determined action for all cells
    cells.each do |cell|
      case cell.next_state
      when 1
        cell.alive = true
      when 0
        cell.alive = false
      end
    end

    @tick += 1
  end

  def reset!
    @tick = 0
    @cells = Hash.new
    @boundaries = nil
    @directions = [
      [-1, 1], [0, 1], [1, 1],   # above
      [-1, 0], [1, 0],           # sides
      [-1, -1], [0, -1], [1, -1] # below
    ]
  end

  def boundaries
    @boundaries ||= {
      :x => {
        :min => @cells.values.collect(&:x).min,
        :max => @cells.values.collect(&:x).max
      },
      :y => {
        :min => @cells.values.collect(&:y).min,
        :max => @cells.values.collect(&:y).max
      }
    }
  end

end

class Cell

  attr_accessor :x, :y, :key, :alive, :next_state, :neighbours

  def initialize(x, y, alive = false)
    @x = x
    @y = y
    @key = "#{x}-#{y}"
    @alive = alive
    @neighbours = nil
  end

  def to_char
    @alive ? 'o' : ' '
  end

end
