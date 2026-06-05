import std/options
# from std/sequtils import filter

type
  Cell = ref object
    x: uint32
    y: uint32
    alive: bool
    nextState: Option[bool]
    neighbours: seq[Cell]

func toChar(self: Cell): string =
  if self.alive:
    "o"
  else:
    " "

func aliveNeighbours(self: Cell): uint32 =
  # The following is slower
  # uint32(
  #   filter(
  #     self.neighbours,
  #     proc(cell: Cell): bool = cell.alive
  #   ).len
  # )

  # The following is slower
  # var aliveNeighbours = 0'u32
  # for neighbour in self.neighbours:
  #   if neighbour.alive:
  #     aliveNeighbours += 1
  # aliveNeighbours

  # The following is the fastest
  var aliveNeighbours = 0'u32
  let count = self.neighbours.len
  for i in 0..<count:
    let neighbour = self.neighbours[i]
    if neighbour.alive:
      aliveNeighbours += 1
  aliveNeighbours
