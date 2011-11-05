class World

  class LocationOccupied < Exception; end

  attr_accessor :tick, :cells

  def initialize
    reset!
  end

  def add_cell(options)
    raise LocationOccupied if self.cell_at(options)
    cell = Cell.new(options)
    @cells << cell
    cell
  end

  def cell_at(options)
    @cells.find do |cell|
      cell.x == options[:x] &&
      cell.y == options[:y]
    end
  end

  def alive_neighbours_at(options)
    [ [-1, 1], [0, 1], [1, 1],   # above
      [-1, 0], [1, 0],           # sides
      [-1, -1], [0, -1], [1, -1] # below
    ].collect { |rel_x, rel_y|
      self.cell_at(
        x: (options[:x] + rel_x),
        y: (options[:y] + rel_y)
      )
    }.compact.reject(&:dead)
  end

  def tick!
    # First determine the action for all cells
    @cells.each do |cell|
      alive_neighbours = self.alive_neighbours_at(x: cell.x, y: cell.y).size
      if cell.dead && alive_neighbours == 3
        cell.next_action = :revive
      elsif !(2..3).include?(alive_neighbours)
        cell.next_action = :kill
      end
    end

    # Then execute the determined action for all cells
    @cells.each do |cell|
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
    @cells = Array.new
  end

  def boundaries
    {
      :x => {
        :min => (@cells.collect(&:x).min - 3),
        :max => (@cells.collect(&:x).max + 3)
      },
      :y => {
        :min => (@cells.collect(&:y).min - 3),
        :max => (@cells.collect(&:y).max + 3)
      }
    }
  end

end

class Cell

  attr_accessor :x, :y, :dead, :next_action

  def initialize(options)
    @x = options[:x]
    @y = options[:y]
    @dead = options[:dead] || false
  end

  def to_char
    @dead ? ' ' : 'o'
  end

end
