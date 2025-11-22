dofile('cell.lua')

DIRECTIONS = {
  {-1, 1},  {0, 1},  {1, 1}, -- above
  {-1, 0},           {1, 0}, -- sides
  {-1, -1}, {0, -1}, {1, -1} -- below
}

World = {}

function World:new(width, height)
  self.__index = self
  local world = setmetatable({
    tick = 0,
    width = width,
    height = height,
    cells = {},
  }, self)

  world:populate_cells()
  world:prepopulate_neighbours()

  return world
end

function World:_tick()
  -- First determine the action for all cells
  for key,cell in pairs(self.cells) do
    local alive_neighbours = cell:alive_neighbours()
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

function World:render()
  -- The following is slower
  -- local rendering = ""
  -- for y = 0, self.height-1 do
  --   for x = 0, self.width-1 do
  --     local cell = self:cell_at(x, y)
  --     if cell then
  --       rendering = rendering..cell:to_char()
  --     end
  --   end
  --   rendering = rendering.."\n"
  -- end
  -- return rendering

  -- The following is the fastest
  local rendering = {}
  for y = 0, self.height-1 do
    for x = 0, self.width-1 do
      local cell = self:cell_at(x, y)
      if cell then
        table.insert(rendering, cell:to_char())
      end
    end
    table.insert(rendering, "\n")
  end
  return table.concat(rendering)
end

function World:cell_at(x, y)
  return self.cells[x..'-'..y]
end

function World:populate_cells()
  math.randomseed(os.time())

  for y = 0, self.height-1 do
    for x = 0, self.width-1 do
      local alive = (math.random() <= 0.2)
      self:add_cell(x, y, alive)
    end
  end
end

function World:add_cell(x, y, alive)
  alive = (alive or false)

  local existing = self:cell_at(x, y)
  assert(not existing, "LocationOccupied("..x.."-"..y..")")

  local cell = Cell:new(x, y, alive)
  self.cells[x..'-'..y] = cell
  return true
end

function World:prepopulate_neighbours()
  for key,cell in pairs(self.cells) do
    local x = cell.x
    local y = cell.y

    for index,set in ipairs(DIRECTIONS) do
      local nx = x + set[1]
      local ny = y + set[2]

      if (nx >= 0) and (ny >= 0) then
        if (nx < self.width) and (ny < self.height) then
          local neighbour = self:cell_at(nx, ny)
          if neighbour then
            table.insert(cell.neighbours, neighbour)
          end
        end
      end
    end
  end
end
