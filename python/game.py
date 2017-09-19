from random import randint

class World:

    class LocationOccupied(RuntimeError): pass

    # Python doesn't have a concept of public/private variables

    def __init__(self, width, height):
        self.width = width
        self.height = height
        self.tick = 0
        self.cells = {}
        self.cached_directions = [
            [-1, 1],  [0, 1],  [1, 1], # above
            [-1, 0],           [1, 0], # sides
            [-1, -1], [0, -1], [1, -1] # below
        ]

        self.populate_cells()
        self.prepopulate_neighbours()

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

    def render(self):
        rendering = ''
        for y in list(range(self.height)):
            for x in list(range(self.width)):
                cell = self.cell_at(x, y)
                rendering += cell.to_char()
            rendering += "\n"
        return rendering

    # Python doesn't have a concept of public/private methods

    def populate_cells(self):
        for y in list(range(self.height)):
            for x in list(range(self.width)):
                alive = (randint(0, 100) <= 20)
                self.add_cell(x, y, alive)

    def prepopulate_neighbours(self):
        for key,cell in self.cells.items():
            self.neighbours_around(cell)

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
        filter_alive = lambda neighbour: neighbour.alive
        return len(list(filter(filter_alive, neighbours)))

class Cell:

    def __init__(self, x, y, alive = False):
        self.x = x
        self.y = y
        self.alive = alive
        self.next_state = None
        self.neighbours = None

    def to_char(self):
        return 'o' if self.alive else ' '
