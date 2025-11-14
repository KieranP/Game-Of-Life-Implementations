import options

from sequtils import filter

type
  Cell = ref object
    x: uint32
    y: uint32
    alive: bool
    next_state: Option[bool]
    neighbours: seq[Cell]

proc to_char(self: Cell): string =
  if self.alive:
    "o"
  else:
    " "

proc alive_neighbours(self: Cell): uint32 =
  # The following is slower
  # uint32(
  #   filter(
  #     self.neighbours,
  #     proc(cell: Cell): bool = cell.alive
  #   ).len
  # )

  # The following is slower
  # var alive_neighbours: uint32 = 0
  # for neighbour in self.neighbours:
  #   if neighbour.alive:
  #     alive_neighbours += 1
  # alive_neighbours

  # The following is the fastest
  var alive_neighbours: uint32 = 0
  let count = self.neighbours.len
  for i in 0..<count:
    let neighbour = self.neighbours[i]
    if neighbour.alive:
      alive_neighbours += 1
  alive_neighbours
