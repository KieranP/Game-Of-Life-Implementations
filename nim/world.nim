include cell

# from strutils import join
# import std/ropes
import std/strformat
from std/random import rand, randomize
import std/tables

type
  LocationOccupied = object of ValueError

const Directions: array[8, (int, int)] = [
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
proc doTick(self: World)
proc render(self: World): string
func makeKey(self: World, x: uint32, y: uint32): string
func cellAt(self: World, x: uint32, y: uint32): Cell
proc populateCells(self: World)
proc addCell(self: World, x: uint32, y: uint32, alive: bool = false): bool
proc prepopulateNeighbours(self: World)

proc initialize(self: World): World =
  self.populateCells()
  self.prepopulateNeighbours()
  self

proc doTick(self: World) =
  # First determine the action for all cells
  for cell in self.cells.values:
    let aliveNeighbours = cell.aliveNeighbours()
    if not cell.alive and aliveNeighbours == 3:
      cell.nextState = some(true)
    elif aliveNeighbours < 2 or aliveNeighbours > 3:
      cell.nextState = some(false)
    else:
      cell.nextState = some(cell.alive)

  # Then execute the determined action for all cells
  for cell in self.cells.values:
    cell.alive = cell.nextState.get(false)

  self.tick += 1

proc render(self: World): string =
  # The following is the fastest
  var rendering = ""
  for y in 0..<self.height:
    for x in 0..<self.width:
      let cell = self.cellAt(x, y)
      if cell != nil:
        rendering &= cell.toChar()
    rendering &= "\n"
  rendering

  # The following is slower
  # var rendering: seq[string] = @[]
  # for y in 0..<self.height:
  #   for x in 0..<self.width:
  #     let cell = self.cellAt(x, y)
  #     if cell != nil:
  #       rendering.add(cell.toChar())
  #   rendering.add("\n")
  # join(rendering, "")

  # The following is slower
  # var rendering = rope("")
  # for y in 0..<self.height:
  #   for x in 0..<self.width:
  #     let cell = self.cellAt(x, y)
  #     if cell != nil:
  #       rendering.add(cell.toChar())
  #   rendering.add("\n")
  # $rendering

func makeKey(self: World, x: uint32, y: uint32): string =
  # The following is slower
  # fmt"{x}-{y}"

  # The following is the fastest
  $x & "-" & $y

  # The following is slower
  # join([$x, $y], "-")

func cellAt(self: World, x: uint32, y: uint32): Cell =
  let key = self.makeKey(x, y)
  self.cells.getOrDefault(key)

proc populateCells(self: World) =
  randomize()

  for y in 0..<self.height:
    for x in 0..<self.width:
      let alive = rand(1.0) <= 0.2
      discard self.addCell(x, y, alive)

proc addCell(self: World, x: uint32, y: uint32, alive: bool = false): bool =
  let existing = self.cellAt(x, y)
  if existing != nil:
    raise newException(LocationOccupied, fmt"LocationOccupied({x}-{y})")

  let key = self.makeKey(x, y)
  let cell = Cell(x: x, y: y, alive: alive)
  self.cells[key] = cell
  true

proc prepopulateNeighbours(self: World) =
  for cell in self.cells.values:
    let x = int(cell.x)
    let y = int(cell.y)

    for (relX, relY) in Directions:
      let nx = x + relX
      let ny = y + relY
      if nx < 0 or ny < 0:
        continue # Out of bounds

      let ux = uint32(nx)
      let uy = uint32(ny)
      if ux >= self.width or uy >= self.height:
        continue # Out of bounds

      let neighbour = self.cellAt(ux, uy)
      if neighbour != nil:
        cell.neighbours.add(neighbour)
