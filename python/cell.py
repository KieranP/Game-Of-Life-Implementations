class Cell:
  def __init__(self, x, y, alive = False):
    self.x = x
    self.y = y
    self.alive = alive
    self.next_state = None
    self.neighbours = []

  def to_char(self):
    return 'o' if self.alive else ' '

  # Implement first using filter/lambda if available. Then implement
  # foreach and for. Use whatever implementation runs the fastest
  def alive_neighbours(self):
    # The following works but is slower
    # filter_alive = lambda neighbour: neighbour.alive
    # return len(list(filter(filter_alive, self.neighbours)))

    # The following was the fastest method
    alive_neighbours = 0
    for neighbour in self.neighbours:
      if neighbour.alive:
        alive_neighbours += 1
    return alive_neighbours

    # The following works but is slower
    # alive_neighbours = 0
    # for i in range(len(self.neighbours)):
    #   neighbour = self.neighbours[i]
    #   if neighbour.alive:
    #     alive_neighbours += 1
    # return alive_neighbours
