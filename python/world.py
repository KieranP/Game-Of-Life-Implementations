from cell import Cell
from random import randint

class World:
  class LocationOccupied(RuntimeError):
    def __init__(self, x, y):
      super().__init__(f"LocationOccupied({x}-{y})")

  DIRECTIONS = [
    [-1, 1],  [0, 1],  [1, 1], # above
    [-1, 0],           [1, 0], # sides
    [-1, -1], [0, -1], [1, -1] # below
  ]

  def __init__(self, width, height):
    self.tick = 0
    self.width = width
    self.height = height
    self.cells = {}

    self.populate_cells()
    self.prepopulate_neighbours()

  def _tick(self):
    # First determine the action for all cells
    for key,cell in self.cells.items():
      alive_neighbours = cell.alive_neighbours()
      if not cell.alive and alive_neighbours == 3:
        cell.next_state = True
      elif alive_neighbours < 2 or alive_neighbours > 3:
        cell.next_state = False
      else:
        cell.next_state = cell.alive

    # Then execute the determined action for all cells
    for key,cell in self.cells.items():
      cell.alive = cell.next_state

    self.tick += 1

  # Implement first using string concatenation. Then implement any
  # special string builders, and use whatever runs the fastest
  def render(self):
    # The following works but is slower
    # rendering = ''
    # for y in list(range(self.height)):
    #   for x in list(range(self.width)):
    #     cell = self.cell_at(x, y)
    #     rendering += cell.to_char()
    #   rendering += "\n"
    # return rendering

    # The following was the fastest method
    rendering = []
    for y in list(range(self.height)):
      for x in list(range(self.width)):
        cell = self.cell_at(x, y)
        rendering.append(cell.to_char())
      rendering.append("\n")
    return ''.join(rendering)

  def cell_at(self, x, y):
    return self.cells.get(str(x)+'-'+str(y))

  def populate_cells(self):
    for y in list(range(self.height)):
      for x in list(range(self.width)):
        alive = (randint(0, 100) <= 20)
        self.add_cell(x, y, alive)

  def add_cell(self, x, y, alive = False):
    if self.cell_at(x, y) is not None:
      raise World.LocationOccupied(x, y)

    cell = Cell(x, y, alive)
    self.cells[str(x)+'-'+str(y)] = cell
    return True

  def prepopulate_neighbours(self):
    for key,cell in self.cells.items():
      for rel_x,rel_y in self.DIRECTIONS:
        neighbour = self.cell_at(
          (cell.x + rel_x),
          (cell.y + rel_y)
        )

        if neighbour is not None:
          cell.neighbours.append(neighbour)
