public class World {

  private class LocationOccupied extends Exception { }

  public Integer tick
  private Integer width
  private Integer height
  private HashMap<String, Cell> cells
  private Integer[][] cached_directions

  public World(int width, int height) {
    this.width = width
    this.height = height
    this.tick = 0
    this.cells = [:]
    this.cached_directions = [
      [-1, 1],  [0, 1],  [1, 1],  // above
      [-1, 0],           [1, 0],  // sides
      [-1, -1], [0, -1], [1, -1], // below
    ]

    populate_cells()
    prepopulate_neighbours()
  }

  public void _tick() {
    // First determine the action for all cells
    for (cell in cells.values()) {
      def alive_neighbours = alive_neighbours_around(cell)
      if (!cell.alive && alive_neighbours == 3) {
        cell.next_state = true
      } else if (alive_neighbours < 2 || alive_neighbours > 3) {
        cell.next_state = false
      } else {
        cell.next_state = cell.alive
      }
    }

    // Then execute the determined action for all cells
    for (cell in cells.values()) {
      cell.alive = cell.next_state
    }

    tick++
  }

  // Implement first using string concatenation. Then implement any
  // special string builders, and use whatever runs the fastest
  public String render() {
    // The following works but is slower
    // def rendering = ""
    // for (y in 0..<height) {
    //   for (x in 0..<width) {
    //     def cell = cell_at(x, y)
    //     rendering += cell.to_char()
    //   }
    //   rendering += "\n"
    // }
    // rendering

    // The following works but is slower
    // def rendering = []
    // for (y in 0..<height) {
    //   for (x in 0..<width) {
    //     def cell = cell_at(x, y)
    //     rendering.add(cell.to_char())
    //   }
    //   rendering.add("\n")
    // }
    // rendering.join("")

    // The following was the fastest method
    def rendering = new StringBuilder()
    for (y in 0..<height) {
      for (x in 0..<width) {
        def cell = cell_at(x, y)
        rendering.append(cell.to_char())
      }
      rendering.append("\n")
    }
    rendering.toString()
  }

  private void populate_cells() {
    for (y in 0..<height) {
      for (x in 0..<width) {
        def alive = (Math.random() <= 0.2)
        add_cell(x, y, alive)
      }
    }
  }

  private void prepopulate_neighbours() {
    for (cell in cells.values()) {
      neighbours_around(cell)
    }
  }

  private Cell add_cell(int x, int y, boolean alive = false) {
    if (cell_at(x, y)) {
      throw new LocationOccupied()
    }

    def cell = new Cell(x, y, alive)
    cells["${x}-${y}".toString()] = cell
    cell_at(x, y)
  }

  private Cell cell_at(int x, int y) {
    cells["${x}-${y}".toString()]
  }

  private ArrayList<Cell> neighbours_around(Cell cell) {
    if (cell.neighbours == null) { // Must return a boolean
      cell.neighbours = []
      for (set in cached_directions) {
        def neighbour = cell_at(
          (cell.x + set[0]),
          (cell.y + set[1])
        )

        if (neighbour != null) {
          cell.neighbours.add(neighbour)
        }
      }
    }

    cell.neighbours
  }

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Use whatever implementation runs the fastest
  private Integer alive_neighbours_around(Cell cell) {
    def neighbours = neighbours_around(cell)

    // The following works but is slower
    // neighbours.count { it.alive }

    // The following was the fastest method
    def alive_neighbours = 0
    for (neighbour in neighbours) {
      if (neighbour.alive) {
        alive_neighbours++
      }
    }
    alive_neighbours

    // The following works but is slower
    // def alive_neighbours = 0
    // for (i in 0..neighbours.size()-1) {
    //   def neighbour = neighbours.get(i)
    //   if (neighbour.alive) {
    //     alive_neighbours++
    //   }
    // }
    // alive_neighbours
  }

}

class Cell {

  public Integer x
  public Integer y
  public Boolean alive
  public Boolean next_state
  public ArrayList<Cell> neighbours

  public Cell(int x, int y, boolean alive = false) {
    this.x = x
    this.y = y
    this.alive = alive
    this.next_state = null
    this.neighbours = null
  }

  public String to_char() {
    alive ? 'o' : ' '
  }

}
