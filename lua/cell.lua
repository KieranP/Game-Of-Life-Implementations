Cell = {}

function Cell:new(x, y, alive)
  self.__index = self
  local cell = setmetatable({
    x = x,
    y = y,
    alive = (alive or false),
    next_state = nil,
    neighbours = {},
  }, self)

  return cell
end

function Cell:to_char()
  return self.alive and 'o' or ' '
end

function Cell:alive_neighbours()
  -- The following is slower
  -- local alive_neighbours = 0
  -- for index,neighbour in pairs(self.neighbours) do
  --   if neighbour.alive then
  --     alive_neighbours = (alive_neighbours + 1)
  --   end
  -- end
  -- return alive_neighbours

  -- The following is the fastest
  local alive_neighbours = 0
  for i = 1, #self.neighbours do
    local neighbour = self.neighbours[i]
    if neighbour.alive then
      alive_neighbours = (alive_neighbours + 1)
    end
  end
  return alive_neighbours
end
