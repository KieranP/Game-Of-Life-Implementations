class Cell:
  def __init__(self, x, y, alive = False):
    self.x = x
    self.y = y
    self.alive = alive
    self.next_state = None
    self.neighbours = []

  def to_char(self):
    return 'o' if self.alive else ' '

  def alive_neighbours(self):
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
