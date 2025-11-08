class Cell:
    def __init__(self, x, y, alive=False):
        self.x = x
        self.y = y
        self.alive = alive
        self.next_state = None
        self.neighbours = []

    def to_char(self):
        return "o" if self.alive else " "

    def alive_neighbours(self):
        alive_neighbours = 0
        for neighbour in self.neighbours:
            if neighbour.alive:
                alive_neighbours += 1
        return alive_neighbours
