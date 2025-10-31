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

-- Implement first using filter/lambda if available. Then implement
-- foreach and for. Use whatever implementation runs the fastest
function Cell:alive_neighbours()
  -- The following works but is slower
  -- local alive_neighbours = 0
  -- for index,neighbour in pairs(self.neighbours) do
  --   if neighbour.alive then
  --     alive_neighbours = (alive_neighbours + 1)
  --   end
  -- end
  -- return alive_neighbours

  -- The following was the fastest method
  local alive_neighbours = 0
  for i = 1, #self.neighbours do
    local neighbour = self.neighbours[i]
    if neighbour.alive then
      alive_neighbours = (alive_neighbours + 1)
    end
  end
  return alive_neighbours
end
