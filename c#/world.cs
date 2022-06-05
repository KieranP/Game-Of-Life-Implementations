using System;
using System.Text;
using System.Linq;
using System.Collections.Generic;

public class World {

  private class LocationOccupied : Exception {}

  public int tick;
  private int width;
  private int height;
  private Dictionary<string, Cell> cells;
  private int[][] cached_directions;

  public World(int width, int height) {
    this.width = width;
    this.height = height;
    this.tick = 0;
    this.cells = new Dictionary<string, Cell>();
    this.cached_directions = new int[][]{
      new int[] {-1, 1},  new int[] {0, 1},  new int[] {1, 1},  // above
      new int[] {-1, 0},                     new int[] {1, 0},  // sides
      new int[] {-1, -1}, new int[] {0, -1}, new int[] {1, -1}, // below
    };

    populate_cells();
    prepopulate_neighbours();
  }

  public void _tick() {
    // First determine the action for all cells
    foreach (Cell cell in cells.Values) {
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
    foreach (Cell cell in cells.Values) {
      cell.alive = cell.next_state ?? false;
    }

    tick++;
  }

  // Implement first using string concatenation. Then implement any
  // special string builders, and use whatever runs the fastest
  public string render() {
    // The following works but is slower
    // String rendering = "";
    // for (int y = 0; y <= height; y++) {
    //   for (int x = 0; x <= width; x++) {
    //     Cell cell = cell_at(x, y);
    //     rendering += cell.to_char();
    //   }
    //   rendering += "\n";
    // }
    // return rendering;

    // The following works but is slower
    // List<String> rendering = new List<String>();
    // for (int y = 0; y <= height; y++) {
    //   for (int x = 0; x <= width; x++) {
    //     Cell cell = cell_at(x, y);
    //     rendering.Add(cell.to_char().ToString());
    //   }
    //   rendering.Add("\n");
    // }
    // return String.Join("", rendering.ToArray());

    // The following was the fastest method
    StringBuilder rendering = new StringBuilder();
    for (int y = 0; y <= height; y++) {
      for (int x = 0; x <= width; x++) {
        Cell cell = cell_at(x, y);
        rendering.Append(cell.to_char());
      }
      rendering.Append("\n");
    }
    return rendering.ToString();
  }

  private void populate_cells() {
    Random random = new Random();
    for (int y = 0; y <= height; y++) {
      for (int x = 0; x <= width; x++) {
        bool alive = (random.NextDouble() <= 0.2);
        add_cell(x, y, alive);
      }
    }
  }

  private void prepopulate_neighbours() {
    foreach (Cell cell in cells.Values) {
      neighbours_around(cell);
    }
  }

  private Cell add_cell(int x, int y, bool alive = false) {
    if (cell_at(x, y) != null) { // Must return a boolean
      throw new LocationOccupied();
    }

    Cell cell = new Cell(x, y, alive);
    cells.Add($"{x}-{y}", cell);
    return cell_at(x, y);
  }

  private Cell cell_at(int x, int y) {
    string key = $"{x}-{y}";
    if (cells.ContainsKey(key)) {
      return cells[key];
    } else {
      return null;
    }
  }

  private List<Cell> neighbours_around(Cell cell) {
    if (cell.neighbours == null) {
      cell.neighbours = new List<Cell>();
      foreach (int[] set in cached_directions) {
        Cell neighbour = cell_at(
          (cell.x + set[0]),
          (cell.y + set[1])
        );
        if (neighbour != null) {
          cell.neighbours.Add(neighbour);
        }
      }
    }

    return cell.neighbours;
  }

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Use whatever implementation runs the fastest
  private int alive_neighbours_around(Cell cell) {
    // The following works but is slower
    // List<Cell> neighbours = neighbours_around(cell);
    // return neighbours.Where(
    //   (neighbour) => neighbour.alive
    // ).ToList().Count;

    // The following works but is slower
    // int alive_neighbours = 0;
    // List<Cell> neighbours = neighbours_around(cell);
    // foreach (Cell neighbour in neighbours) {
    //   if (neighbour.alive) {
    //     alive_neighbours++;
    //   }
    // }
    // return alive_neighbours;

    // The following was the fastest method
    int alive_neighbours = 0;
    List<Cell> neighbours = neighbours_around(cell);
    for (int i = 0; i < neighbours.Count; i++) {
      Cell neighbour = neighbours[i];
      if (neighbour.alive) {
        alive_neighbours++;
      }
    }
    return alive_neighbours;
  }

}

public class Cell {

  public int x;
  public int y;
  public bool alive;
  public bool? next_state;
  public List<Cell> neighbours;

  public Cell(int x, int y, bool alive = false) {
    this.x = x;
    this.y = y;
    this.alive = alive;
    this.next_state = null;
    this.neighbours = null;
  }

  public char to_char() {
    return this.alive ? 'o' : ' ';
  }

}
