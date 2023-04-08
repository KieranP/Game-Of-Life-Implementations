// Files must be named the same as the class they contain
// Files can have multiple classes, but only one public class

import java.util.HashMap;
import java.lang.Math;
import java.util.ArrayList;
import java.util.stream.Collectors;

public class World {

  private class LocationOccupied extends Exception { }

  public int tick;
  private int width;
  private int height;
  private HashMap<String, Cell> cells;
  private int[][] cached_directions;

  public World(int width, int height) {
    this.width = width;
    this.height = height;
    this.tick = 0;
    this.cells = new HashMap<String, Cell>();
    this.cached_directions = new int[][]{
      {-1, 1},  {0, 1},  {1, 1},  // above
      {-1, 0},           {1, 0},  // sides
      {-1, -1}, {0, -1}, {1, -1}, // below
    };

    populate_cells();
    prepopulate_neighbours();
  }

  public void _tick() {
    // First determine the action for all cells
    for (Cell cell : cells.values()) {
      int alive_neighbours = alive_neighbours_around(cell);
      if (!cell.alive && alive_neighbours == 3) {
        cell.next_state = true;
      } else if (alive_neighbours < 2 || alive_neighbours > 3) {
        cell.next_state = false;
      } else {
        cell.next_state = cell.alive;
      }
    }

    // Then execute the determined action for all cells
    for (Cell cell : cells.values()) {
      cell.alive = cell.next_state;
    }

    tick++;
  }

  // Implement first using string concatenation. Then implement any
  // special string builders, and use whatever runs the fastest
  public String render() {
    // The following works but is slower
    // String rendering = "";
    // for (int y = 0; y < height; y++) {
    //   for (int x = 0; x < width; x++) {
    //     Cell cell = cell_at(x, y);
    //     rendering += cell.to_char();
    //   }
    //   rendering += "\n";
    // }
    // return rendering;

    // The following works but is slower
    // ArrayList<String> rendering = new ArrayList<String>();
    // for (int y = 0; y < height; y++) {
    //   for (int x = 0; x < width; x++) {
    //     Cell cell = cell_at(x, y);
    //     rendering.add(String.valueOf(cell.to_char()));
    //   }
    //   rendering.add("\n");
    // }
    // return String.join("", rendering);

    // The following was the fastest method
    StringBuilder rendering = new StringBuilder();
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        Cell cell = cell_at(x, y);
        rendering.append(cell.to_char());
      }
      rendering.append("\n");
    }
    return rendering.toString();
  }

  private void populate_cells() {
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        boolean alive = (Math.random() <= 0.2);
        add_cell(x, y, alive);
      }
    }
  }

  private void prepopulate_neighbours() {
    for (Cell cell : cells.values()) {
      neighbours_around(cell);
    }
  }

  // Java doesn't have the concept of optional or default values
  // The workaround is catch all args as an array and disect it
  private Cell add_cell(int x, int y, boolean... args) {
    if (cell_at(x, y) != null) { // Must return a boolean
      // Java won't let us throw an error without catching it
      // so emulate a runtime abort by catching and exiting
      try {
        throw new LocationOccupied();
      } catch(LocationOccupied m) {
        System.out.println("Error: World.LocationOccupied "+x+"-"+y+"");
        System.exit(0);
      }
    }

    Cell cell = new Cell(x, y, args[0]);
    cells.put(x+"-"+y, cell);
    return cell_at(x, y);
  }

  private Cell cell_at(int x, int y) {
    return cells.get(x+"-"+y);
  }

  private ArrayList<Cell> neighbours_around(Cell cell) {
    if (cell.neighbours == null) { // Must return a boolean
      cell.neighbours = new ArrayList<Cell>();
      for (int[] set : cached_directions) {
        Cell neighbour = cell_at(
          (cell.x + set[0]),
          (cell.y + set[1])
        );
        if (neighbour != null) {
          cell.neighbours.add(neighbour);
        }
      }
    }

    return cell.neighbours;
  }

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Use whatever implementation runs the fastest
  private int alive_neighbours_around(Cell cell) {
    ArrayList<Cell> neighbours = neighbours_around(cell);

    // The following works but is slower
    // return neighbours.stream().
    //   filter(neighbour -> neighbour.alive).
    //   collect(Collectors.toList()).
    //   size();

    // The following works but is slower
    // int alive_neighbours = 0;
    // for (Cell neighbour : neighbours) {
    //   if (neighbour.alive) {
    //     alive_neighbours++;
    //   }
    // }
    // return alive_neighbours;

    // The following was the fastest method
    int alive_neighbours = 0;
    for (int i = 0; i < neighbours.size(); i++) {
      Cell neighbour = neighbours.get(i);
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

  // Java doesn't have the concept of optional or default values
  // The workaround is catch all args as an array and disect it
  public Cell(int x, int y, boolean... args) {
    this.x = x;
    this.y = y;
    this.alive = args[0];
    this.next_state = null;
    this.neighbours = null;
  }

  public char to_char() {
    return this.alive ? 'o' : ' ';
  }

}
