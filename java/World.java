import java.util.HashMap;
import java.lang.Math;
import java.util.ArrayList;
import java.util.stream.Collectors;

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

  public World(int width, int height) {
    this.tick = 0;
    this.width = width;
    this.height = height;
    this.cells = new HashMap<>();

    populate_cells();
    prepopulate_neighbours();
  }

  public void _tick() {
    // First determine the action for all cells
    for (var cell : cells.values()) {
      var alive_neighbours = alive_neighbours_around(cell);
      if (!cell.alive && alive_neighbours == 3) {
        cell.next_state = true;
      } else if (alive_neighbours < 2 || alive_neighbours > 3) {
        cell.next_state = false;
      } else {
        cell.next_state = cell.alive;
      }
    }

    // Then execute the determined action for all cells
    for (var cell : cells.values()) {
      cell.alive = cell.next_state;
    }

    tick++;
  }

  // Implement first using string concatenation. Then implement any
  // special string builders, and use whatever runs the fastest
  public String render() {
    // The following works but is slower
    // var rendering = "";
    // for (var y = 0; y < height; y++) {
    //   for (var x = 0; x < width; x++) {
    //     var cell = cell_at(x, y);
    //     rendering += cell.to_char();
    //   }
    //   rendering += "\n";
    // }
    // return rendering;

    // The following works but is slower
    // var rendering = new ArrayList<String>();
    // for (var y = 0; y < height; y++) {
    //   for (var x = 0; x < width; x++) {
    //     var cell = cell_at(x, y);
    //     rendering.add(String.valueOf(cell.to_char()));
    //   }
    //   rendering.add("\n");
    // }
    // return String.join("", rendering);

    // The following was the fastest method
    var rendering = new StringBuilder();
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        var cell = cell_at(x, y);
        rendering.append(cell.to_char());
      }
      rendering.append("\n");
    }
    return rendering.toString();
  }

  private Cell cell_at(int x, int y) {
    return cells.get(x+"-"+y);
  }

  private void populate_cells() {
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        var alive = (Math.random() <= 0.2);
        add_cell(x, y, alive);
      }
    }
  }

  private Cell add_cell(int x, int y, boolean... args) {
    if (cell_at(x, y) != null) {
      try {
        throw new LocationOccupied(x, y);
      } catch(LocationOccupied m) {
        System.out.println(m.getMessage());
        System.exit(1);
      }
    }

    var cell = new Cell(x, y, args[0]);
    cells.put(x+"-"+y, cell);
    return cell;
  }

  private void prepopulate_neighbours() {
    for (var cell : cells.values()) {
      for (var set : DIRECTIONS) {
        var neighbour = cell_at(
          (cell.x + set[0]),
          (cell.y + set[1])
        );

        if (neighbour != null) {
          cell.neighbours.add(neighbour);
        }
      }
    }
  }

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Use whatever implementation runs the fastest
  private int alive_neighbours_around(Cell cell) {
    // The following works but is slower
    // return cell.neighbours.stream().
    //   filter(neighbour -> neighbour.alive).
    //   collect(Collectors.toList()).
    //   size();

    // The following works but is slower
    // var alive_neighbours = 0;
    // for (var neighbour : cell.neighbours) {
    //   if (neighbour.alive) {
    //     alive_neighbours++;
    //   }
    // }
    // return alive_neighbours;

    // The following was the fastest method
    var alive_neighbours = 0;
    for (var i = 0; i < cell.neighbours.size(); i++) {
      var neighbour = cell.neighbours.get(i);
      if (neighbour.alive) {
        alive_neighbours++;
      }
    }
    return alive_neighbours;
  }
}

class Cell {
  public int x;
  public int y;
  public boolean alive;
  public Boolean next_state;
  public ArrayList<Cell> neighbours;

  public Cell(int x, int y, boolean... args) {
    this.x = x;
    this.y = y;
    this.alive = args[0];
    this.next_state = null;
    this.neighbours = new ArrayList<>();
  }

  public char to_char() {
    return this.alive ? 'o' : ' ';
  }
}
