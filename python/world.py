from cell import Cell
# from io import StringIO
from random import random

class World:
  class _LocationOccupied(RuntimeError):
    def __init__(self, x: int, y: int) -> None:
      super().__init__(f"LocationOccupied({x}-{y})")

  _DIRECTIONS = [
    (-1, 1),  (0, 1),  (1, 1), # above
    (-1, 0),           (1, 0), # sides
    (-1, -1), (0, -1), (1, -1) # below
  ]

  def __init__(self, width: int, height: int) -> None:
    self.tick = 0
    self._width = width
    self._height = height
    self._cells: dict[str, Cell] = {}

    self._populate_cells()
    self._prepopulate_neighbours()

  def dotick(self) -> None:
    # First determine the action for all cells
    for cell in self._cells.values():
      alive_neighbours = cell.alive_neighbours()
      if not cell.alive and alive_neighbours == 3:
        cell.next_state = True
      elif alive_neighbours < 2 or alive_neighbours > 3:
        cell.next_state = False
      else:
        cell.next_state = cell.alive

    # Then execute the determined action for all cells
    for cell in self._cells.values():
      cell.alive = cell.next_state

    self.tick += 1

  def render(self) -> str:
    # The following is slower
    # rendering = ''
    # for y in range(self._height):
    #   for x in range(self._width):
    #     cell = self._cell_at(x, y)
    #     if cell is not None:
    #       rendering += cell.to_char()
    #   rendering += "\n"
    # return rendering

    # The following is the fastest
    rendering = []
    for y in range(self._height):
      for x in range(self._width):
        cell = self._cell_at(x, y)
        if cell is not None:
          rendering.append(cell.to_char())
      rendering.append("\n")
    return ''.join(rendering)

    # The following is slower
    # rendering = StringIO()
    # for y in range(self._height):
    #   for x in range(self._width):
    #     cell = self._cell_at(x, y)
    #     if cell is not None:
    #       rendering.write(cell.to_char())
    #   rendering.write("\n")
    # return rendering.getvalue()

    # The following is slower
    # render_size = self._width * self._height + self._height
    # rendering = bytearray(render_size)
    # idx = 0
    # for y in range(self._height):
    #   for x in range(self._width):
    #     cell = self._cell_at(x, y)
    #     if cell is not None:
    #       rendering[idx] = ord(cell.to_char())
    #       idx += 1
    #   rendering[idx] = ord("\n")
    #   idx += 1
    # return rendering[:idx].decode()

  def _make_key(self, x: int, y: int) -> str:
    # The following is slower
    # return f"{x}-{y}"

    # The following is the fastest
    return str(x) + '-' + str(y)

    # The following is slower
    # return '-'.join([str(x), str(y)])

  def _cell_at(self, x: int, y: int) -> Cell | None:
    key = self._make_key(x, y)
    return self._cells.get(key)

  def _populate_cells(self) -> None:
    for y in range(self._height):
      for x in range(self._width):
        alive = random() <= 0.2
        self._add_cell(x, y, alive)

  def _add_cell(self, x: int, y: int, alive: bool = False) -> bool:
    existing = self._cell_at(x, y)
    if existing is not None:
      raise World._LocationOccupied(x, y)

    cell = Cell(x, y, alive)
    key = self._make_key(x, y)
    self._cells[key] = cell
    return True

  def _prepopulate_neighbours(self) -> None:
    for cell in self._cells.values():
      x = cell.x
      y = cell.y

      for rel_x, rel_y in self._DIRECTIONS:
        nx = x + rel_x
        ny = y + rel_y
        if nx < 0 or ny < 0:
          continue # Out of bounds

        if nx >= self._width or ny >= self._height:
          continue # Out of bounds

        neighbour = self._cell_at(nx, ny)
        if neighbour is not None:
          cell.neighbours.append(neighbour)
