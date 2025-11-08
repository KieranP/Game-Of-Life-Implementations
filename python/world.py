from cell import Cell
from random import randint


class World:
    class LocationOccupied(RuntimeError):
        def __init__(self, x, y):
            super().__init__(f"LocationOccupied({x}-{y})")

    DIRECTIONS = [
        [-1, 1],
        [0, 1],
        [1, 1],
        [-1, 0],
        [1, 0],
        [-1, -1],
        [0, -1],
        [1, -1],
    ]

    def __init__(self, width, height):
        self.tick = 0
        self.width = width
        self.height = height
        self.cells = {}

        self.populate_cells()
        self.prepopulate_neighbours()
        self.initialize_neighbor_counts()

    def _tick(self):
        cells = self.cells.values()

        for cell in cells:
            if not cell.alive and cell.alive_neighbors == 3:
                cell.next_state = True
            elif cell.alive_neighbors < 2 or cell.alive_neighbors > 3:
                cell.next_state = False
            else:
                cell.next_state = cell.alive

        for cell in cells:
            # if state changed, update neighbors alive count
            if cell.alive != cell.next_state:
                delta = 1 if cell.next_state else -1
                for neighbour in cell.neighbours:
                    neighbour.alive_neighbors += delta
            cell.alive = cell.next_state

        self.tick += 1

    def render(self):
        rendering = []
        cells = self.cells
        for y in range(self.height):
            for x in range(self.width):
                cell = cells[(x, y)]
                rendering.append("o" if cell.alive else " ")
            rendering.append("\n")
        return "".join(rendering)

    def populate_cells(self):
        for y in range(self.height):
            for x in range(self.width):
                alive = randint(0, 100) <= 20
                self.add_cell(x, y, alive=alive)

    def add_cell(self, x, y, alive=False):
        if (x, y) in self.cells:
            raise World.LocationOccupied(x, y)

        cell = Cell(x, y, alive=alive)
        self.cells[(x, y)] = cell
        return True

    def prepopulate_neighbours(self):
        cells = self.cells
        for cell in cells.values():
            for rel_x, rel_y in self.DIRECTIONS:
                neighbour = cells.get((cell.x + rel_x, cell.y + rel_y))
                if neighbour is not None:
                    cell.neighbours.append(neighbour)

    def initialize_neighbor_counts(self):
        for cell in self.cells.values():
            for neighbour in cell.neighbours:
                if neighbour.alive:
                    cell.alive_neighbors += 1
