class World

  class LocationOccupied < Exception; end

  attr_accessor :tick, :cells, :neighbours

  def initialize
    reset!
  end

  def add_cell(x, y, dead = false)
    raise LocationOccupied if self.cell_at(x, y)
    @neighbours = Hash.new # so it recomputes
    @cells["#{x}-#{y}"] = Cell.new(x, y, dead)
  end

  def cell_at(x, y)
    @cells["#{x}-#{y}"]
  end

  def neighbours_at(x, y)
    @neighbours["#{x}-#{y}"] ||= begin
      [ [-1, 1], [0, 1], [1, 1],   # above
        [-1, 0], [1, 0],           # sides
        [-1, -1], [0, -1], [1, -1] # below
      ].collect { |rel_x, rel_y|
        self.cell_at((x + rel_x), (y + rel_y))
      }.compact
    end
  end

  def alive_neighbours_at(x, y)
    neighbours_at(x, y).reject(&:dead)
  end

  def tick!
    cells = @cells.values

    # First determine the action for all cells
    cells.each do |cell|
      alive_neighbours = self.alive_neighbours_at(cell.x, cell.y).size
      if cell.dead && alive_neighbours == 3
        cell.next_action = :revive
      elsif !(2..3).include?(alive_neighbours)
        cell.next_action = :kill
      end
    end

    # Then execute the determined action for all cells
    cells.each do |cell|
      case cell.next_action
      when :revive
        cell.dead = false
      when :kill
        cell.dead = true
      end
    end

    @tick += 1
  end

  def reset!
    @tick = 0
    @cells = Hash.new
    @neighbours = Hash.new
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

  attr_accessor :x, :y, :dead, :next_action

  def initialize(x, y, dead = false)
    @x = x
    @y = y
    @dead = dead
  end

  def to_char
    @dead ? ' ' : 'o'
  end

end
