class Cell:
    def __init__(self, x, y, alive=False):
        self.x = x
        self.y = y
        self.alive = alive
        self.next_state = None
        self.neighbours = []
        self.alive_neighbors = 0
