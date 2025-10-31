import options

from sequtils import filter

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

# Implement first using filter/lambda if available. Then implement
# foreach and for. Use whatever implementation runs the fastest
proc alive_neighbours(self: Cell): int =
  # The following works but is slower
  # filter(
  #   self.neighbours,
  #   proc(cell: Cell): bool = cell.alive
  # ).len

  # The following was the fastest method
  var alive_neighbours = 0
  for neighbour in self.neighbours:
    if neighbour.alive:
      alive_neighbours += 1
  alive_neighbours

  # The following works but is slower
  # var alive_neighbours = 0
  # for i in 0..<self.neighbours.len:
  #   let neighbour = self.neighbours[i]
  #   if neighbour.alive:
  #     alive_neighbours += 1
  # alive_neighbours
