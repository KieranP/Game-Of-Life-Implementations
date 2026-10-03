include("cell.jl")
using Random

mutable struct World
  tick::UInt32
  const width::UInt32
  const height::UInt32
  const cells::Dict{String, Cell}

  function World(; width::UInt32, height::UInt32)
    world = new(0, width, height, Dict{String, Cell}())
    world_populate_cells(world)
    world_prepopulate_neighbours(world)
    world
  end
end

struct LocationOccupied <: Exception
  x::UInt32
  y::UInt32
end

function Base.showerror(io::IO, e::LocationOccupied)
  print(io, "LocationOccupied($(e.x)-$(e.y))")
end

const DIRECTIONS = [
  (-1, 1),  (0, 1),  (1, 1),  # above
  (-1, 0),           (1, 0),  # sides
  (-1, -1), (0, -1), (1, -1), # below
]

function world_tick(world::World)
  # First determine the action for all cells
  for cell in values(world.cells)
    alive_neighbours = cell_alive_neighbours(cell)
    if !cell.alive && alive_neighbours == 3
      cell.next_state = true
    elseif alive_neighbours < 2 || alive_neighbours > 3
      cell.next_state = false
    else
      cell.next_state = cell.alive
    end
  end

  # Then execute the determined action for all cells
  for cell in values(world.cells)
    cell.alive = something(cell.next_state, false)
  end

  world.tick += 1
end

function world_render(world::World)
  # The following is slower
  # rendering = ""
  # for y in UInt32(0):(world.height - UInt32(1))
  #   for x in UInt32(0):(world.width - UInt32(1))
  #     cell = world_cell_at(world, x, y)
  #     if cell !== nothing
  #       rendering *= cell_to_char(cell)
  #     end
  #   end
  #   rendering *= '\n'
  # end
  # rendering

  # The following is slower
  # rendering = Char[]
  # render_size = world.width * world.height + world.height
  # sizehint!(rendering, render_size)
  # for y in UInt32(0):(world.height - UInt32(1))
  #   for x in UInt32(0):(world.width - UInt32(1))
  #     cell = world_cell_at(world, x, y)
  #     if cell !== nothing
  #       push!(rendering, cell_to_char(cell))
  #     end
  #   end
  #   push!(rendering, '\n')
  # end
  # String(rendering)

  # The following is the fastest
  rendering = IOBuffer()
  for y in UInt32(0):(world.height - UInt32(1))
    for x in UInt32(0):(world.width - UInt32(1))
      cell = world_cell_at(world, x, y)
      if cell !== nothing
        print(rendering, cell_to_char(cell))
      end
    end
    print(rendering, '\n')
  end
  String(take!(rendering))

  # The following is slower
  # render_size = world.width * world.height + world.height
  # rendering = Vector{UInt8}(undef, render_size)
  # index = 1
  # for y in UInt32(0):(world.height - UInt32(1))
  #   for x in UInt32(0):(world.width - UInt32(1))
  #     cell = world_cell_at(world, x, y)
  #     if cell !== nothing
  #       rendering[index] = UInt8(cell_to_char(cell))
  #       index += 1
  #     end
  #   end
  #   rendering[index] = 0x0A
  #   index += 1
  # end
  # String(resize!(rendering, index - 1))
end

function world_make_key(x::UInt32, y::UInt32)
  # The following is slower
  # "$(x)-$(y)"

  # The following is the fastest
  string(x) * "-" * string(y)

  # The following is slower
  # join([string(x), string(y)], "-")
end

function world_cell_at(world::World, x::UInt32, y::UInt32)
  key = world_make_key(x, y)
  get(world.cells, key, nothing)
end

function world_populate_cells(world::World)
  for y in UInt32(0):(world.height - UInt32(1))
    for x in UInt32(0):(world.width - UInt32(1))
      alive = rand() <= 0.2
      world_add_cell(world, x, y, alive)
    end
  end
end

function world_add_cell(world::World, x::UInt32, y::UInt32, alive::Bool = false)
  existing = world_cell_at(world, x, y)
  if existing !== nothing
    throw(LocationOccupied(x, y))
  end

  cell = Cell(x, y, alive)
  key = world_make_key(x, y)
  world.cells[key] = cell
  true
end

function world_prepopulate_neighbours(world::World)
  for cell in values(world.cells)
    x = Int(cell.x)
    y = Int(cell.y)

    for (rel_x, rel_y) in DIRECTIONS
      nx = x + rel_x
      ny = y + rel_y

      if nx < 0 || ny < 0
        continue # Out of bounds
      end

      ux = UInt32(nx)
      uy = UInt32(ny)
      if ux >= world.width || uy >= world.height
        continue # Out of bounds
      end

      neighbour = world_cell_at(world, ux, uy)
      if neighbour !== nothing
        push!(cell.neighbours, neighbour)
      end
    end
  end
end
