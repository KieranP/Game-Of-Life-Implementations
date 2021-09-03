import std/[options, tables, random]

# Nim typically declares all Types near the top of the file, after imports.
type
  Cell* = ref object
    x*, y*: int
    alive*: bool
    next_state*: Option[bool]
    neighbours*: Option[seq[Cell]]

  World* = object
    width*, height*, tick_num*: int
    cells*: Table[array[2, int], Cell]
    cached_directions*: array[8, array[2, int]]

  LocationOccupied* = object of ValueError

# By default, Nim requires functions be declared before they are used elsewhere
# and will error out if I dont. To to order the functions as I like, I need to
# declare them ahead of time, known as "forward declaration",
# or alternatively use the "code reordering" feature,
# by default it is this way to speed up compilation time.
proc add_cell*(self: var World, x: int, y: int, alive: bool = false)
proc cell_at*(self: World, x: int, y: int): Cell
proc neighbours_around*(self: World, cell: Cell): seq[Cell]
proc alive_neighbours_around*(self: World, cell: Cell): int

func to_char*(self: Cell): char {.inline.} =
  if self.alive: 'o' else: ' '

proc initWorld*(width, height: static[int]): World =
  ## World Constructor.
  result.width = width
  result.height = height
  result.cached_directions = [
    [-1, 1],  [0, 1],  [1, 1],  # above
    [-1, 0],           [1, 0],  # sides
    [-1, -1], [0, -1], [1, -1], # below
  ]
  result.populate_cells()
  result.prepopulate_neighbours()

proc tick*(self: var World) =
  # First determine the action for all cells
  for cell in self.cells.values:
    let alive_neighbours = self.alive_neighbours_around(cell)
    if not cell.alive and alive_neighbours == 3:
      cell.next_state = some true
    elif alive_neighbours < 2 or alive_neighbours > 3:
      cell.next_state = some false

  # Then execute the determined action for all cells
  for cell in self.cells.values:
    if cell.next_state == some true:
      cell.alive = true
    elif cell.next_state == some false:
      cell.alive = false

  self.tick_num.inc

# Implement first using string concatenation. Then implement any
# special string builders, and use whatever runs the fastest
proc render*(self: World): string =
  # The following was the fastest method
  for y in 0..self.height:
    for x in 0..self.width:
      result.add self.cell_at(x, y).to_char
    result.add '\n'

  # The following works but it slower
  # var rendering: seq[string] = @[]
  # for y in 0..self.height:
  #   for x in 0..self.width:
  #     let cell = self.cell_at(x, y)
  #     rendering.add(cell.to_char())
  #   rendering.add("\n")
  # join(rendering, "")

proc populate_cells*(self: var World) =
  for y in 0..self.height:
    for x in 0..self.width:
      self.add_cell(x, y, rand(100) <= 20)

proc prepopulate_neighbours*(self: World) =
  for cell in self.cells.values:
    discard self.neighbours_around(cell)

proc add_cell*(self: var World; x, y: int; alive = false) =
  if self.cell_at(x, y) != nil:
    raise newException(LocationOccupied, "Location occupied")
  self.cells[[x, y]] = Cell(x: x, y: y, alive: alive)

proc cell_at*(self: World; x, y: int): Cell =
  if self.cells.hasKey([x, y]):
    result = self.cells[[x, y]]

proc neighbours_around*(self: World, cell: Cell): seq[Cell] =
  if cell.neighbours.isNone:
    var neighbours: seq[Cell]

    for coords in self.cached_directions:
      let neighbour = self.cell_at(
        (cell.x + coords[0]),
        (cell.y + coords[1]),
      )

      if neighbour != nil:
        neighbours.add(neighbour)

    cell.neighbours = some(neighbours)

  result = cell.neighbours.get

# Implement first using filter/lambda if available. Then implement
# foreach and for. Retain whatever implementation runs the fastest
proc alive_neighbours_around*(self: World, cell: Cell): int =
  # The following works but is slower
  # filter(
  #   self.neighbours_around(cell),
  #   proc(cell: Cell): bool = cell.alive
  # ).len

  # The following was the fastest method
  for neighbour in self.neighbours_around(cell):
    if neighbour.alive: inc result

  # The following works but is slower
  # let neighbours = self.neighbours_around(cell)
  # for i in 0..<neighbours.len:
  #   let neighbour = neighbours[i]
  #   if neighbour.alive:
  #     inc result
