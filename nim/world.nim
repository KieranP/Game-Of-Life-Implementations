include cell

# from strutils import join
# import std/ropes
import std/strformat
from std/random import rand
import std/tables

type
  LocationOccupied = object of ValueError

const DIRECTIONS: array[8, (int, int)] = [
  (-1, 1),  (0, 1),  (1, 1), # above
  (-1, 0),           (1, 0), # sides
  (-1, -1), (0, -1), (1, -1), # below
]

type
  World = ref object
    tick: uint32
    width: uint32
    height: uint32
    cells: Table[string, Cell]

# By default, Nim requires methods be declared before they are used elsewhere
# and will error out if I dont. To to order the methods as I like, I need to
# declare them ahead of time, known as "forward declaration".
proc initialize(self: World): World
proc dotick(self: World)
proc render(self: World): string
func make_key(self: World, x: uint32, y: uint32): string
func cell_at(self: World, x: uint32, y: uint32): Cell
proc populate_cells(self: World)
proc add_cell(self: World, x: uint32, y: uint32, alive: bool = false): bool
proc prepopulate_neighbours(self: World)

proc initialize(self: World): World =
  self.populate_cells()
  self.prepopulate_neighbours()
  self

proc dotick(self: World) =
  # First determine the action for all cells
  for cell in self.cells.values:
    let alive_neighbours = cell.alive_neighbours()
    if not cell.alive and alive_neighbours == 3:
      cell.next_state = some(true)
    elif alive_neighbours < 2 or alive_neighbours > 3:
      cell.next_state = some(false)
    else:
      cell.next_state = some(cell.alive)

  # Then execute the determined action for all cells
  for cell in self.cells.values:
    cell.alive = cell.next_state.get(false)

  self.tick += 1

proc render(self: World): string =
  # The following is the fastest
  var rendering = ""
  for y in 0..<self.height:
    for x in 0..<self.width:
      let cell = self.cell_at(x, y)
      if cell != nil:
        rendering &= cell.to_char()
    rendering &= "\n"
  rendering

  # The following is slower
  # var rendering: seq[string] = @[]
  # for y in 0..<self.height:
  #   for x in 0..<self.width:
  #     let cell = self.cell_at(x, y)
  #     if cell != nil:
  #       rendering.add(cell.to_char())
  #   rendering.add("\n")
  # join(rendering, "")

  # The following is slower
  # var rendering = rope("")
  # for y in 0..<self.height:
  #   for x in 0..<self.width:
  #     let cell = self.cell_at(x, y)
  #     if cell != nil:
  #       rendering.add(cell.to_char())
  #   rendering.add("\n")
  # $rendering

func make_key(self: World, x: uint32, y: uint32): string =
  # The following is slower
  # fmt"{x}-{y}"

  # The following is the fastest
  $x & "-" & $y

  # The following is slower
  # join([$x, $y], "-")

func cell_at(self: World, x: uint32, y: uint32): Cell =
  let key = self.make_key(x, y)
  self.cells.getOrDefault(key)

proc populate_cells(self: World) =
  for y in 0..<self.height:
    for x in 0..<self.width:
      let alive = rand(1.0) <= 0.2
      discard self.add_cell(x, y, alive)

proc add_cell(self: World, x: uint32, y: uint32, alive: bool = false): bool =
  let existing = self.cell_at(x, y)
  if existing != nil:
    raise newException(LocationOccupied, fmt"LocationOccupied({x}-{y})")

  let key = self.make_key(x, y)
  let cell = Cell(x: x, y: y, alive: alive)
  self.cells[key] = cell
  true

proc prepopulate_neighbours(self: World) =
  for cell in self.cells.values:
    let x = int(cell.x)
    let y = int(cell.y)

    for (rel_x, rel_y) in DIRECTIONS:
      let nx = x + rel_x
      let ny = y + rel_y
      if nx < 0 or ny < 0:
        continue # Out of bounds

      let ux = uint32(nx)
      let uy = uint32(ny)
      if ux >= self.width or uy >= self.height:
        continue # Out of bounds

      let neighbour = self.cell_at(ux, uy)
      if neighbour != nil:
        cell.neighbours.add(neighbour)
