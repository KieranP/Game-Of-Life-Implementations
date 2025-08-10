from strutils import intToStr,join
from random import rand
from sequtils import filter
import options
import tables
import ropes

type
  Cell = ref object
    x: int
    y: int
    alive: bool
    next_state: Option[bool]
    neighbours: seq[Cell]

proc to_char(self: Cell): string =
  if self.alive:
    "o"
  else:
    " "

type
  LocationOccupied = object of ValueError
    x: int
    y: int

proc newLocationOccupied(x, y: int): ref LocationOccupied =
  new(result)
  result.x = x
  result.y = y
  result.msg = "LocationOccupied(" & intToStr(x) & "-" & intToStr(y) & ")"

const DIRECTIONS: array[8, array[2, int]] = [
  [-1, 1],  [0, 1],  [1, 1], # above
  [-1, 0],           [1, 0], # sides
  [-1, -1], [0, -1], [1, -1], # below
]

type
  World = ref object of RootObj
    tick_num: int
    width: int
    height: int
    cells: Table[string, Cell]

# By default, Nim requires methods be declared before they are used elsewhere
# and will error out if I dont. To to order the methods as I like, I need to
# declare them ahead of time, known as "forward declaration".
proc initialize(self: World): World
proc tick(self: World)
proc render(self: World): string
proc cell_at(self: World, x: int, y: int): Cell
proc populate_cells(self: World)
proc add_cell(self: World, x: int, y: int, alive: bool = false): Cell
proc prepopulate_neighbours(self: World)
proc alive_neighbours_around(self: World, cell: Cell): int

proc initialize(self: World): World =
  self.cells = initTable[string, Cell]()

  self.populate_cells()
  self.prepopulate_neighbours()
  self

proc tick(self: World) =
  # First determine the action for all cells
  for key,cell in self.cells:
    let alive_neighbours = self.alive_neighbours_around(cell)
    if not cell.alive and alive_neighbours == 3:
      cell.next_state = some(true)
    elif alive_neighbours < 2 or alive_neighbours > 3:
      cell.next_state = some(false)
    else:
      cell.next_state = some(cell.alive)

  # Then execute the determined action for all cells
  for key,cell in self.cells:
    cell.alive = cell.next_state == some(true)

  self.tick_num += 1

# Implement first using string concatenation. Then implement any
# special string builders, and use whatever runs the fastest
proc render(self: World): string =
  # The following was the fastest method
  var rendering = ""
  for y in 0..<self.height:
    for x in 0..<self.width:
      let cell = self.cell_at(x, y)
      rendering &= cell.to_char()
    rendering &= "\n"
  rendering

  # The following works but it slower
  # var rendering: seq[string] = @[]
  # for y in 0..<self.height:
  #   for x in 0..<self.width:
  #     let cell = self.cell_at(x, y)
  #     rendering.add(cell.to_char())
  #   rendering.add("\n")
  # join(rendering, "")

proc cell_at(self: World, x: int, y: int): Cell =
  let key = intToStr(x) & "-" & intToStr(y)
  if self.cells.hasKey(key):
    return self.cells[key]
  else:
    discard

proc populate_cells(self: World) =
  for y in 0..<self.height:
    for x in 0..<self.width:
      let alive = (rand(100) <= 20)
      discard self.add_cell(x, y, alive)

proc add_cell(self: World, x: int, y: int, alive: bool = false): Cell =
  if self.cell_at(x, y) != nil:
    raise newLocationOccupied(x, y)

  let cell = Cell(x: x, y: y, alive: alive)
  let key = intToStr(x) & "-" & intToStr(y)
  self.cells[key] = cell
  cell

proc prepopulate_neighbours(self: World) =
  for key,cell in self.cells:
    for coords in DIRECTIONS:
      let neighbour = self.cell_at(
        (cell.x + coords[0]),
        (cell.y + coords[1]),
      )

      if neighbour != nil:
        cell.neighbours.add(neighbour)

# Implement first using filter/lambda if available. Then implement
# foreach and for. Use whatever implementation runs the fastest
proc alive_neighbours_around(self: World, cell: Cell): int =
  # The following works but is slower
  # filter(
  #   cell.neighbours,
  #   proc(cell: Cell): bool = cell.alive
  # ).len

  # The following was the fastest method
  var alive_neighbours = 0
  for neighbour in cell.neighbours:
    if neighbour.alive:
      alive_neighbours += 1
  alive_neighbours

  # The following works but is slower
  # var alive_neighbours = 0
  # for i in 0..<cell.neighbours.len:
  #   let neighbour = cell.neighbours[i]
  #   if neighbour.alive:
  #     alive_neighbours += 1
  # alive_neighbours
