class World:

    class LocationOccupied(RuntimeError): pass

    def __init__(self):
        self.tick = 0
        self.cells = {}
        self.cached_directions = [
            [-1, 1],  [0, 1],  [1, 1], # above
            [-1, 0],           [1, 0], # sides
            [-1, -1], [0, -1], [1, -1] # below
        ]

    def add_cell(self, x, y, alive = False):
        if self.cell_at(x, y):
            raise World.LocationOccupied

        self.cells[str(x)+'-'+str(y)] = Cell(x, y, alive);
        return self.cells[str(x)+'-'+str(y)]

    def cell_at(self, x, y):
        return self.cells.get(str(x)+'-'+str(y))

    def neighbours_around(self, cell):
        if cell.neighbours is None:
            cell.neighbours = []
            for rel_x,rel_y in self.cached_directions:
                neighbour = self.cell_at((cell.x + rel_x), (cell.y + rel_y))
                if neighbour is not None:
                    cell.neighbours.append(neighbour)

        return cell.neighbours

    def alive_neighbours_around(self, cell):
        neighbours = self.neighbours_around(cell)
        filter_alive = lambda cell: cell.alive
        return len(list(filter(filter_alive, neighbours)))

    def _tick(self):
        # First determine the action for all cells
        for key,cell in self.cells.items():
            alive_neighbours = self.alive_neighbours_around(cell)
            if cell.alive is False and alive_neighbours == 3:
                cell.next_state = 1
            elif alive_neighbours < 2 or alive_neighbours > 3:
                cell.next_state = 0

        # Then execute the determined action for all cells
        for key,cell in self.cells.items():
            if cell.next_state == 1:
                cell.alive = True
            elif cell.next_state == 0:
                cell.alive = False

        self.tick += 1

class Cell:

    def __init__(self, x, y, alive = False):
        self.x = x
        self.y = y
        self.key = (str(x)+'-'+str(y))
        self.alive = alive
        self.next_state = None
        self.neighbours = None

    def to_char(self):
        return 'o' if self.alive else ' '
