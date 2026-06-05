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

    populateCells()
    prepopulateNeighbours()
  }

  public void doTick() {
    var cellValues = cells.values()

    // First determine the action for all cells
    for (cell in cellValues) {
      var aliveNeighbours = cell.aliveNeighbours()
      if (!cell.alive && aliveNeighbours == 3) {
        cell.nextState = true
      } else if (aliveNeighbours < 2 || aliveNeighbours > 3) {
        cell.nextState = false
      } else {
        cell.nextState = cell.alive
      }
    }

    // Then execute the determined action for all cells
    for (cell in cellValues) {
      cell.alive = cell.nextState
    }

    tick++
  }

  public String render() {
    // The following is slower
    // var rendering = ""
    // for (y in 0..<height) {
    //   for (x in 0..<width) {
    //     var cell = cellAt(x, y)
    //     if (cell) {
    //       rendering += cell.toChar()
    //     }
    //   }
    //   rendering += "\n"
    // }
    // rendering

    // The following is slower
    // var rendering = []
    // for (y in 0..<height) {
    //   for (x in 0..<width) {
    //     var cell = cellAt(x, y)
    //     if (cell) {
    //       rendering.add(cell.toChar())
    //     }
    //   }
    //   rendering.add("\n")
    // }
    // rendering.join("")

    // The following is the fastest
    var renderSize = width * height + height
    var rendering = new StringBuilder(renderSize)
    for (y in 0..<height) {
      for (x in 0..<width) {
        var cell = cellAt(x, y)
        if (cell) {
          rendering.append(cell.toChar())
        }
      }
      rendering.append("\n")
    }
    rendering.toString()
  }

  private String makeKey(int x, int y) {
    // The following is slower
    // "${x}-${y}"

    // The following is the fastest
    x + '-' + y

    // The following is slower
    // [x, y].join('-')
  }

  private Cell cellAt(int x, int y) {
    var key = makeKey(x, y)
    cells[key]
  }

  private void populateCells() {
    for (y in 0..<height) {
      for (x in 0..<width) {
        var alive = Math.random() <= 0.2
        addCell(x, y, alive)
      }
    }
  }

  private boolean addCell(int x, int y, boolean alive = false) {
    var existing = cellAt(x, y)
    if (existing) {
      throw new LocationOccupied(x, y)
    }

    var key = makeKey(x, y)
    var cell = new Cell(x, y, alive)
    cells[key] = cell
    true
  }

  private void prepopulateNeighbours() {
    for (cell in cells.values()) {
      var x = cell.x
      var y = cell.y

      for (set in DIRECTIONS) {
        def (relX, relY) = set
        var nx = x + relX
        var ny = y + relY
        if (nx < 0 || ny < 0) {
          continue // Out of bounds
        }

        if (nx >= width || ny >= height) {
          continue // Out of bounds
        }

        var neighbour = cellAt(nx, ny)
        if (neighbour) {
          cell.neighbours.add(neighbour)
        }
      }
    }
  }
}
