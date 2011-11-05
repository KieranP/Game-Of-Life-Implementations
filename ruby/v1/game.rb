class World

  attr_accessor :tick, :cells

  def initialize
    reset!
  end

  def cell_at(options)
    @cells.find do |cell|
      cell.x == options[:x] &&
      cell.y == options[:y]
    end
  end

  def tick!
    # First determine the action for all cells
    @cells.each do |cell|
      if cell.dead && cell.alive_neighbours.size == 3
        cell.next_action = :revive
      elsif !(2..3).include?(cell.alive_neighbours.size)
        cell.next_action = :kill
      end
    end

    # Then execute the determined action for all cells
    @cells.each do |cell|
      case cell.next_action
      when :revive then
        cell.dead = false
      when :kill then
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

  class LocationOccupied < Exception; end

  attr_accessor :world, :x, :y, :dead, :next_action

  def initialize(options)
    @world = options[:world]
    @x = options[:x]
    @y = options[:y]
    @dead = options[:dead] || false

    raise LocationOccupied if @world.cell_at(x: @x, y: @y)
    @world.cells << self
  end

  def alive_neighbours
    [ [-1, 1], [0, 1], [1, 1],   # above
      [-1, 0], [1, 0],           # sides
      [-1, -1], [0, -1], [1, -1] # below
    ].collect { |rel_x, rel_y|
      @world.cell_at(
        x: (@x + rel_x),
        y: (@y + rel_y)
      )
    }.compact.reject(&:dead)
  end

  def to_char
    @dead ? ' ' : 'o'
  end

end
