mutable struct Cell
  x::UInt64
  y::UInt64
  alive::Bool
  next_state::Bool
  neighbours::Vector{Cell}

  function Cell(x::UInt64, y::UInt64, alive = false)
    new(x, y, alive, false, [])
  end
end

function cell_to_char(cell::Cell)
  cell.alive ? 'o' : ' '
end

function cell_alive_neighbours(cell::Cell)
  # The following is the fastest
  count(n -> n.alive, cell.neighbours)

  # The following is about the same
  # alive_neighbours = 0
  # for neighbour in cell.neighbours
  #   if neighbour.alive
  #     alive_neighbours += 1
  #   end
  # end
  # alive_neighbours

  # The following is slower
  # alive_neighbours = 0
  # count = length(cell.neighbours)
  # for i in 1:count
  #   neighbour = cell.neighbours[i]
  #   if neighbour.alive
  #     alive_neighbours += 1
  #   end
  # end
  # alive_neighbours
end
