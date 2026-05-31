from dataclasses import dataclass, field

@dataclass
class Cell:
  x: int
  y: int
  alive: bool = False
  next_state: bool | None = None
  neighbours: list["Cell"] = field(default_factory=list)

  def to_char(self) -> str:
    return 'o' if self.alive else ' '

  def alive_neighbours(self) -> int:
    # The following is slower
    # filter_alive = lambda neighbour: neighbour.alive
    # return len(list(filter(filter_alive, self.neighbours)))

    # The following is the fastest
    alive_neighbours = 0
    for neighbour in self.neighbours:
      if neighbour.alive:
        alive_neighbours += 1
    return alive_neighbours

    # The following is slower
    # alive_neighbours = 0
    # count = len(self.neighbours)
    # for i in range(count):
    #   neighbour = self.neighbours[i]
    #   if neighbour.alive:
    #     alive_neighbours += 1
    # return alive_neighbours
