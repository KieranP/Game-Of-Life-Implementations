from cell import Cell
from random import random

class World:
  class LocationOccupied(RuntimeError):
    def __init__(self, x: int, y: int) -> None:
      super().__init__(f"LocationOccupied({x}-{y})")

  DIRECTIONS = [
    (-1, 1),  (0, 1),  (1, 1), # above
    (-1, 0),           (1, 0), # sides
    (-1, -1), (0, -1), (1, -1) # below
  ]

  def __init__(self, width: int, height: int) -> None:
    self.tick = 0
    self.width = width
    self.height = height
    self.cells: dict[str, Cell] = {}

    self.populate_cells()
    self.prepopulate_neighbours()

  def dotick(self) -> None:
    # First determine the action for all cells
    for cell in self.cells.values():
      alive_neighbours = cell.alive_neighbours()
      if not cell.alive and alive_neighbours == 3:
        cell.next_state = True
      elif alive_neighbours < 2 or alive_neighbours > 3:
        cell.next_state = False
      else:
        cell.next_state = cell.alive

    # Then execute the determined action for all cells
    for cell in self.cells.values():
      cell.alive = cell.next_state

    self.tick += 1

  def render(self) -> str:
    # The following is slower
    # rendering = ''
    # for y in range(self.height):
    #   for x in range(self.width):
    #     cell = self.cell_at(x, y)
    #     if cell is not None:
    #       rendering += cell.to_char()
    #   rendering += "\n"
    # return rendering

    # The following is the fastest
    rendering = []
    for y in range(self.height):
      for x in range(self.width):
        cell = self.cell_at(x, y)
        if cell is not None:
          rendering.append(cell.to_char())
      rendering.append("\n")
    return ''.join(rendering)

  def make_key(self, x: int, y: int) -> str:
    # The following is slower
    # return f"{x}-{y}"

    # The following is the fastest
    return str(x) + '-' + str(y)

    # The following is slower
    # return '-'.join([str(x), str(y)])

  def cell_at(self, x: int, y: int) -> Cell | None:
    key = self.make_key(x, y)
    return self.cells.get(key)

  def populate_cells(self) -> None:
    for y in range(self.height):
      for x in range(self.width):
        alive = random() <= 0.2
        self.add_cell(x, y, alive)

  def add_cell(self, x: int, y: int, alive: bool = False) -> bool:
    existing = self.cell_at(x, y)
    if existing is not None:
      raise World.LocationOccupied(x, y)

    key = self.make_key(x, y)
    cell = Cell(x, y, alive)
    self.cells[key] = cell
    return True

  def prepopulate_neighbours(self) -> None:
    for cell in self.cells.values():
      x = cell.x
      y = cell.y

      for rel_x, rel_y in self.DIRECTIONS:
        nx = x + rel_x
        ny = y + rel_y
        if nx < 0 or ny < 0:
          continue # Out of bounds

        if nx >= self.width or ny >= self.height:
          continue # Out of bounds

        neighbour = self.cell_at(nx, ny)
        if neighbour is not None:
          cell.neighbours.append(neighbour)
