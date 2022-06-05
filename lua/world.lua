World = {}

function World:new(width, height)
  self.__index = self
  world = setmetatable({
    width = width,
    height = height,
    tick = 0,
    cells = {},
    cached_directions = {
      {-1, 1},  {0, 1},  {1, 1}, -- above
      {-1, 0},           {1, 0}, -- sides
      {-1, -1}, {0, -1}, {1, -1} -- below
    },
  }, self)

  world:populate_cells()
  world:prepopulate_neighbours()

  return world
end

function World:_tick()
  -- First determine the action for all cells
  for key,cell in pairs(self.cells) do
    alive_neighbours = self:alive_neighbours_around(cell)
    if not cell.alive and alive_neighbours == 3 then
      cell.next_state = true
    elseif alive_neighbours < 2 or alive_neighbours > 3 then
      cell.next_state = false
    else
      cell.next_state = cell.alive
    end
  end

  -- Then execute the determined action for all cells
  for key,cell in pairs(self.cells) do
    cell.alive = cell.next_state
  end

  self.tick = (self.tick + 1)
end

-- Implement first using string concatenation. Then implement any
-- special string builders, and use whatever runs the fastest
function World:render()
  -- The following works but is slower
  -- rendering = ""
  -- for y = 0, self.height do
  --   for x = 0, self.width do
  --     cell = self:cell_at(x, y)
  --     rendering = rendering..cell:to_char()
  --   end
  --   rendering = rendering.."\n"
  -- end
  -- return rendering

  -- The following was the fastest method
  rendering = {}
  for y = 0, self.height do
    for x = 0, self.width do
      cell = self:cell_at(x, y)
      table.insert(rendering, cell:to_char())
    end
    table.insert(rendering, "\n")
  end
  return table.concat(rendering)
end

function World:populate_cells()
  math.randomseed(os.time())

  for y = 0, self.height do
    for x = 0, self.width do
      alive = (math.random() <= 0.2)
      self:add_cell(x, y, alive)
    end
  end
end

function World:prepopulate_neighbours()
  for key,cell in pairs(self.cells) do
    self:neighbours_around(cell)
  end
end

function World:add_cell(x, y, alive)
  alive = (alive or false)
  assert(not self:cell_at(x, y), "World:LocationOccupied")
  cell = Cell:new(x, y, alive)
  self.cells[x..'-'..y] = cell
  return self:cell_at(x, y)
end

function World:cell_at(x, y)
  return self.cells[x..'-'..y]
end

function World:neighbours_around(cell)
  if not cell.neighbours then
    cell.neighbours = {}
    for index,set in ipairs(self.cached_directions) do
      neighbour = self:cell_at(
        (cell.x + set[1]),
        (cell.y + set[2])
      )
      if neighbour then
        table.insert(cell.neighbours, neighbour)
      end
    end
  end

  return cell.neighbours
end

-- Implement first using filter/lambda if available. Then implement
-- foreach and for. Use whatever implementation runs the fastest
function World:alive_neighbours_around(cell)
  -- The following works but is slower
  -- alive_neighbours = 0
  -- neighbours = self:neighbours_around(cell)
  -- for index,neighbour in pairs(neighbours) do
  --   if neighbour.alive then
  --     alive_neighbours = (alive_neighbours + 1)
  --   end
  -- end
  -- return alive_neighbours

  -- The following was the fastest method
  alive_neighbours = 0
  neighbours = self:neighbours_around(cell)
  for i = 1, #neighbours do
    neighbour = neighbours[i]
    if neighbour.alive then
      alive_neighbours = (alive_neighbours + 1)
    end
  end
  return alive_neighbours
end

Cell = {}

function Cell:new(x, y, alive)
  self.__index = self
  cell = setmetatable({
    x = x,
    y = y,
    alive = (alive or false),
    next_state = nil,
    neighbours = nil,
  }, self)

  return cell
end

function Cell:to_char()
  return self.alive and 'o' or ' '
end
