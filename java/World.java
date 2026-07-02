import java.util.HashMap;
import java.util.Map;
// import java.util.ArrayList;

public class World {
  public int tick;

  private final int width;
  private final int height;
  private final Map<String, Cell> cells;

  private static class LocationOccupied extends Exception {
    public LocationOccupied(int x, int y) {
      super("LocationOccupied(%d-%d)".formatted(x, y));
    }
  }

  private static final int[][] DIRECTIONS = {
    {-1, 1},  {0, 1},  {1, 1},  // above
    {-1, 0},           {1, 0},  // sides
    {-1, -1}, {0, -1}, {1, -1}, // below
  };

  public World(int width, int height) throws LocationOccupied {
    this.tick = 0;
    this.width = width;
    this.height = height;
    this.cells = new HashMap<>();

    populateCells();
    prepopulateNeighbours();
  }

  public void doTick() {
    var cellValues = cells.values();

    // First determine the action for all cells
    for (var cell : cellValues) {
      var aliveNeighbours = cell.aliveNeighbours();
      if (!cell.alive && aliveNeighbours == 3) {
        cell.nextState = true;
      } else if (aliveNeighbours < 2 || aliveNeighbours > 3) {
        cell.nextState = false;
      } else {
        cell.nextState = cell.alive;
      }
    }

    // Then execute the determined action for all cells
    for (var cell : cellValues) {
      cell.alive = cell.nextState;
    }

    tick++;
  }

  public String render() {
    // The following is slower
    // var rendering = "";
    // for (var y = 0; y < height; y++) {
    //   for (var x = 0; x < width; x++) {
    //     var cell = cellAt(x, y);
    //     if (cell != null) {
    //       rendering += cell.toChar();
    //     }
    //   }
    //   rendering += "\n";
    // }
    // return rendering;

    // The following is slower
    // var rendering = new ArrayList<String>();
    // for (var y = 0; y < height; y++) {
    //   for (var x = 0; x < width; x++) {
    //     var cell = cellAt(x, y);
    //     if (cell != null) {
    //       rendering.add(String.valueOf(cell.toChar()));
    //     }
    //   }
    //   rendering.add("\n");
    // }
    // return String.join("", rendering);

    // The following is the fastest
    var renderSize = width * height + height;
    var rendering = new StringBuilder(renderSize);
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        var cell = cellAt(x, y);
        if (cell != null) {
          rendering.append(cell.toChar());
        }
      }
      rendering.append('\n');
    }
    return rendering.toString();
  }

  private String makeKey(int x, int y) {
    // The following is slower
    // return String.format("%d-%d", x, y);

    // The following is the fastest
    return x + "-" + y;

    // The following is slower
    // return String.join("-", String.valueOf(x), String.valueOf(y));
  }

  private Cell cellAt(int x, int y) {
    var key = makeKey(x, y);
    return cells.get(key);
  }

  private void populateCells() throws LocationOccupied {
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        var alive = Math.random() <= 0.2;
        addCell(x, y, alive);
      }
    }
  }

  private boolean addCell(int x, int y, boolean alive) throws LocationOccupied {
    var existing = cellAt(x, y);
    if (existing != null) {
      throw new LocationOccupied(x, y);
    }

    var key = makeKey(x, y);
    var cell = new Cell(x, y, alive);
    cells.put(key, cell);
    return true;
  }

  private void prepopulateNeighbours() {
    for (var cell : cells.values()) {
      var x = cell.x;
      var y = cell.y;

      for (var set : DIRECTIONS) {
        var nx = x + set[0];
        var ny = y + set[1];
        if (nx < 0 || ny < 0) {
          continue; // Out of bounds
        }

        if (nx >= width || ny >= height) {
          continue; // Out of bounds
        }

        var neighbour = cellAt(nx, ny);
        if (neighbour != null) {
          cell.neighbours.add(neighbour);
        }
      }
    }
  }
}
