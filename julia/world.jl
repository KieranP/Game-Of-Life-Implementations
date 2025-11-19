include("cell.jl")
using Random

mutable struct World
  tick::UInt64
  width::UInt64
  height::UInt64
  cells::Dict{String, Cell}

  function World(; width::UInt64, height::UInt64)
    world = new(0, width, height, Dict{String, Cell}())
    world_populate_cells(world)
    world_prepopulate_neighbours(world)
    world
  end
end

struct LocationOccupied <: Exception
  x::UInt64
  y::UInt64
end

function Base.showerror(io::IO, e::LocationOccupied)
  print(io, "LocationOccupied($(e.x)-$(e.y))")
end

const DIRECTIONS = [
  [-1, 1],  [0, 1],  [1, 1],  # above
  [-1, 0],           [1, 0],  # sides
  [-1, -1], [0, -1], [1, -1], # below
]

function world_tick(world::World)
  # First determine the action for all cells
  for (_, cell) in world.cells
    alive_neighbours_count = cell_alive_neighbours(cell)
    if !cell.alive && alive_neighbours_count == 3
      cell.next_state = true
    elseif alive_neighbours_count < 2 || alive_neighbours_count > 3
      cell.next_state = false
    else
      cell.next_state = cell.alive
    end
  end

  # Then execute the determined action for all cells
  for (_, cell) in world.cells
    cell.alive = cell.next_state
  end

  world.tick += 1
end

function world_render(world::World)
  # The following is slower
  # rendering = ""
  # for y in 0:(world.height - 1)
  #   for x in 0:(world.width - 1)
  #     cell = world_cell_at(world, x, y)
  #     rendering *= cell_to_char(cell)
  #   end
  #   rendering *= '\n'
  # end
  # rendering

  # The following is about the same
  # rendering = Char[]
  # render_size = world.width * world.height + world.height
  # sizehint!(rendering, render_size)
  # for y in 0:(world.height - 1)
  #   for x in 0:(world.width - 1)
  #     cell = world_cell_at(world, x, y)
  #     push!(rendering, cell_to_char(cell))
  #   end
  #   push!(rendering, '\n')
  # end
  # String(rendering)

  # The following is the fastest
  rendering = IOBuffer()
  for y in 0:(world.height - 1)
    for x in 0:(world.width - 1)
      cell = world_cell_at(world, x, y)
      print(rendering, cell_to_char(cell))
    end
    print(rendering, "\n")
  end
  String(take!(rendering))

  # The following is about the same
  # render_size = world.width * world.height + world.height
  # rendering = Vector{UInt8}(undef, render_size)
  # index = 1
  # for y in 0:(world.height - 1)
  #   for x in 0:(world.width - 1)
  #     cell = world_cell_at(world, x, y)
  #     rendering[index] = UInt8(cell_to_char(cell))
  #     index += 1
  #   end
  #   rendering[index] = 0x0A
  #   index += 1
  # end
  # String(rendering)
end

function world_cell_at(world::World, x::UInt64, y::UInt64)
  get(world.cells, "$(x)-$(y)", nothing)
end

function world_populate_cells(world::World)
  for y in 0:(world.height - 1)
    for x in 0:(world.width - 1)
      alive = (rand(0:100) <= 20)
      world_add_cell(world, x, y, alive)
    end
  end
end

function world_add_cell(world::World, x::UInt64, y::UInt64, alive::Bool = false)
  if world_cell_at(world, x, y) !== nothing
    throw(LocationOccupied(x, y))
  end

  cell = Cell(x, y, alive)
  world.cells["$(x)-$(y)"] = cell
  true
end

function world_prepopulate_neighbours(world::World)
  for (_, cell) in world.cells
    x = cell.x
    y = cell.y

    for direction in DIRECTIONS
      rel_x, rel_y = direction
      nx = x + rel_x
      ny = y + rel_y

      if nx < 0 || ny < 0
        continue # Out of bounds
      end

      if nx >= world.width || ny >= world.height
        continue # Out of bounds
      end

      neighbour = world_cell_at(world, nx, ny)
      if neighbour !== nothing
        push!(cell.neighbours, neighbour)
      end
    end
  end
end
