import java.util.HashMap;
import java.util.ArrayList;

public class World {
  public int tick;

  private int width;
  private int height;
  private HashMap<String, Cell> cells;

  private class LocationOccupied extends Exception {
    public LocationOccupied(int x, int y) {
      super("LocationOccupied("+x+"-"+y+")");
    }
  }

  private static final int[][] DIRECTIONS = new int[][]{
    {-1, 1},  {0, 1},  {1, 1},  // above
    {-1, 0},           {1, 0},  // sides
    {-1, -1}, {0, -1}, {1, -1}, // below
  };

  public World(int width, int height) throws LocationOccupied {
    this.tick = 0;
    this.width = width;
    this.height = height;
    this.cells = new HashMap<>();

    populate_cells();
    prepopulate_neighbours();
  }

  public void _tick() {
    var cell_values = cells.values();

    // First determine the action for all cells
    for (var cell : cell_values) {
      var alive_neighbours = cell.alive_neighbours();
      if (!cell.alive && alive_neighbours == 3) {
        cell.next_state = true;
      } else if (alive_neighbours < 2 || alive_neighbours > 3) {
        cell.next_state = false;
      } else {
        cell.next_state = cell.alive;
      }
    }

    // Then execute the determined action for all cells
    for (var cell : cell_values) {
      cell.alive = cell.next_state;
    }

    tick++;
  }

  public String render() {
    // The following is slower
    // var rendering = "";
    // for (var y = 0; y < height; y++) {
    //   for (var x = 0; x < width; x++) {
    //     var cell = cell_at(x, y);
    //     if (cell != null) {
    //       rendering += cell.to_char();
    //     }
    //   }
    //   rendering += "\n";
    // }
    // return rendering;

    // The following is slower
    // var rendering = new ArrayList<String>();
    // for (var y = 0; y < height; y++) {
    //   for (var x = 0; x < width; x++) {
    //     var cell = cell_at(x, y);
    //     if (cell != null) {
    //       rendering.add(String.valueOf(cell.to_char()));
    //     }
    //   }
    //   rendering.add("\n");
    // }
    // return String.join("", rendering);

    // The following is the fastest
    var render_size = width * height + height;
    var rendering = new StringBuilder(render_size);
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        var cell = cell_at(x, y);
        if (cell != null) {
          rendering.append(cell.to_char());
        }
      }
      rendering.append("\n");
    }
    return rendering.toString();
  }

  private Cell cell_at(int x, int y) {
    return cells.get(x+"-"+y);
  }

  private void populate_cells() throws LocationOccupied {
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        var alive = (Math.random() <= 0.2);
        add_cell(x, y, alive);
      }
    }
  }

  private boolean add_cell(int x, int y, boolean... args) throws LocationOccupied {
    var existing = cell_at(x, y);
    if (existing != null) {
      throw new LocationOccupied(x, y);
    }

    var cell = new Cell(x, y, args[0]);
    cells.put(x+"-"+y, cell);
    return true;
  }

  private void prepopulate_neighbours() {
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

        var neighbour = cell_at(nx, ny);
        if (neighbour != null) {
          cell.neighbours.add(neighbour);
        }
      }
    }
  }
}
