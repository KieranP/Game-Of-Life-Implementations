public class World {
  public int tick

  private int width
  private int height
  private HashMap<String, Cell> cells

  private class LocationOccupied extends Exception {
    public LocationOccupied(int x, int y) {
      super("LocationOccupied(${x}-${y})")
    }
  }

  private static final int[][] DIRECTIONS = [
    [-1, 1],  [0, 1],  [1, 1],  // above
    [-1, 0],           [1, 0],  // sides
    [-1, -1], [0, -1], [1, -1], // below
  ]

  public World(int width, int height) {
    this.tick = 0
    this.width = width
    this.height = height
    this.cells = [:]

    populate_cells()
    prepopulate_neighbours()
  }

  public void _tick() {
    def cell_values = cells.values()

    // First determine the action for all cells
    for (cell in cell_values) {
      def alive_neighbours = cell.alive_neighbours()
      if (!cell.alive && alive_neighbours == 3) {
        cell.next_state = true
      } else if (alive_neighbours < 2 || alive_neighbours > 3) {
        cell.next_state = false
      } else {
        cell.next_state = cell.alive
      }
    }

    // Then execute the determined action for all cells
    for (cell in cell_values) {
      cell.alive = cell.next_state
    }

    tick++
  }

  public String render() {
    // The following is slower
    // def rendering = ""
    // for (y in 0..<height) {
    //   for (x in 0..<width) {
    //     def cell = cell_at(x, y)
    //     if (cell) {
    //       rendering += cell.to_char()
    //     }
    //   }
    //   rendering += "\n"
    // }
    // rendering

    // The following is slower
    // def rendering = []
    // for (y in 0..<height) {
    //   for (x in 0..<width) {
    //     def cell = cell_at(x, y)
    //     if (cell) {
    //       rendering.add(cell.to_char())
    //     }
    //   }
    //   rendering.add("\n")
    // }
    // rendering.join("")

    // The following is the fastest
    def render_size = width * height + height
    def rendering = new StringBuilder(render_size)
    for (y in 0..<height) {
      for (x in 0..<width) {
        def cell = cell_at(x, y)
        if (cell) {
          rendering.append(cell.to_char())
        }
      }
      rendering.append("\n")
    }
    rendering.toString()
  }

  private Cell cell_at(int x, int y) {
    cells["${x}-${y}".toString()]
  }

  private void populate_cells() {
    for (y in 0..<height) {
      for (x in 0..<width) {
        def alive = (Math.random() <= 0.2)
        add_cell(x, y, alive)
      }
    }
  }

  private boolean add_cell(int x, int y, boolean alive = false) {
    def existing = cell_at(x, y)
    if (existing) {
      throw new LocationOccupied(x, y)
    }

    def cell = new Cell(x, y, alive)
    cells["${x}-${y}".toString()] = cell
    true
  }

  private void prepopulate_neighbours() {
    for (cell in cells.values()) {
      def x = cell.x
      def y = cell.y

      for (set in DIRECTIONS) {
        def nx = x + set[0]
        def ny = y + set[1]
        if (nx < 0 || ny < 0) {
          continue // Out of bounds
        }

        if (nx >= width || ny >= height) {
          continue // Out of bounds
        }

        def neighbour = cell_at(nx, ny)
        if (neighbour) {
          cell.neighbours.add(neighbour)
        }
      }
    }
  }
}
