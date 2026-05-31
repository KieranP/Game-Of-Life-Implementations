import static groovy.lang.Tuple.tuple

public class World {
  public int tick

  private final int width
  private final int height
  private final Map<String, Cell> cells

  private static class LocationOccupied extends Exception {
    public LocationOccupied(int x, int y) {
      super("LocationOccupied(${x}-${y})")
    }
  }

  private static final List<Tuple2<Integer, Integer>> DIRECTIONS = [
    tuple(-1, 1),  tuple(0, 1),  tuple(1, 1),  // above
    tuple(-1, 0),                tuple(1, 0),  // sides
    tuple(-1, -1), tuple(0, -1), tuple(1, -1), // below
  ]

  public World(int width, int height) {
    this.tick = 0
    this.width = width
    this.height = height
    this.cells = new HashMap<>()

    populate_cells()
    prepopulate_neighbours()
  }

  public void dotick() {
    var cell_values = cells.values()

    // First determine the action for all cells
    for (cell in cell_values) {
      var alive_neighbours = cell.alive_neighbours()
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
    // var rendering = ""
    // for (y in 0..<height) {
    //   for (x in 0..<width) {
    //     var cell = cell_at(x, y)
    //     if (cell) {
    //       rendering += cell.to_char()
    //     }
    //   }
    //   rendering += "\n"
    // }
    // rendering

    // The following is slower
    // var rendering = []
    // for (y in 0..<height) {
    //   for (x in 0..<width) {
    //     var cell = cell_at(x, y)
    //     if (cell) {
    //       rendering.add(cell.to_char())
    //     }
    //   }
    //   rendering.add("\n")
    // }
    // rendering.join("")

    // The following is the fastest
    var render_size = width * height + height
    var rendering = new StringBuilder(render_size)
    for (y in 0..<height) {
      for (x in 0..<width) {
        var cell = cell_at(x, y)
        if (cell) {
          rendering.append(cell.to_char())
        }
      }
      rendering.append("\n")
    }
    rendering.toString()
  }

  private String make_key(int x, int y) {
    // The following is slower
    // "${x}-${y}"

    // The following is the fastest
    x + '-' + y

    // The following is slower
    // [x, y].join('-')
  }

  private Cell cell_at(int x, int y) {
    var key = make_key(x, y)
    cells[key]
  }

  private void populate_cells() {
    for (y in 0..<height) {
      for (x in 0..<width) {
        var alive = Math.random() <= 0.2
        add_cell(x, y, alive)
      }
    }
  }

  private boolean add_cell(int x, int y, boolean alive = false) {
    var existing = cell_at(x, y)
    if (existing) {
      throw new LocationOccupied(x, y)
    }

    var key = make_key(x, y)
    var cell = new Cell(x, y, alive)
    cells[key] = cell
    true
  }

  private void prepopulate_neighbours() {
    for (cell in cells.values()) {
      var x = cell.x
      var y = cell.y

      for (set in DIRECTIONS) {
        def (rel_x, rel_y) = set
        var nx = x + rel_x
        var ny = y + rel_y
        if (nx < 0 || ny < 0) {
          continue // Out of bounds
        }

        if (nx >= width || ny >= height) {
          continue // Out of bounds
        }

        var neighbour = cell_at(nx, ny)
        if (neighbour) {
          cell.neighbours.add(neighbour)
        }
      }
    }
  }
}
