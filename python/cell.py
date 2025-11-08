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
        return sum(neighbour.alive for neighbour in self.neighbours)
