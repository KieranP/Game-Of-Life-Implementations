using System;
using System.Text;
using System.Linq;
using System.Collections.Generic;

public class World {
  public int tick = 0;

  private int width;
  private int height;
  private Dictionary<string, Cell> cells = new Dictionary<string, Cell>();

  private class LocationOccupied : Exception {
    public LocationOccupied(int x, int y) :
      base($"LocationOccupied({x}-{y})") { }
  }

  private static readonly int[][] DIRECTIONS = [
    [-1, 1],  [0, 1],  [1, 1], // above
    [-1, 0],           [1, 0], // sides
    [-1, -1], [0, -1], [1, -1] // below
  ];

  public World(int width, int height) {
    this.width = width;
    this.height = height;

    populate_cells();
    prepopulate_neighbours();
  }

  public void _tick() {
    // First determine the action for all cells
    foreach (var cell in cells.Values) {
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
    foreach (var cell in cells.Values) {
      cell.alive = cell.next_state ?? false;
    }

    tick++;
  }

  // Implement first using string concatenation. Then implement any
  // special string builders, and use whatever runs the fastest
  public string render() {
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
    // var rendering = new List<String>();
    // for (var y = 0; y < height; y++) {
    //   for (var x = 0; x < width; x++) {
    //     var cell = cell_at(x, y);
    //     rendering.Add(cell.to_char().ToString());
    //   }
    //   rendering.Add("\n");
    // }
    // return String.Join("", rendering.ToArray());

    // The following was the fastest method
    var rendering = new StringBuilder();
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        var cell = cell_at(x, y);
        rendering.Append(cell.to_char());
      }
      rendering.Append("\n");
    }
    return rendering.ToString();
  }

  private Cell cell_at(int x, int y) {
    var key = $"{x}-{y}";
    if (cells.TryGetValue(key, out Cell value)) {
      return value;
    } else {
      return null;
    }
  }

  private void populate_cells() {
    var random = new Random();
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        var alive = random.NextDouble() <= 0.2;
        add_cell(x, y, alive);
      }
    }
  }

  private Cell add_cell(int x, int y, bool alive = false) {
    if (cell_at(x, y) != null) {
      throw new LocationOccupied(x, y);
    }

    var cell = new Cell(x, y, alive);
    cells.Add($"{x}-{y}", cell);
    return cell;
  }

  private void prepopulate_neighbours() {
    foreach (var cell in cells.Values) {
      foreach (var set in DIRECTIONS) {
        var neighbour = cell_at(
          cell.x + set[0],
          cell.y + set[1]
        );

        if (neighbour != null) {
          cell.neighbours.Add(neighbour);
        }
      }
    }
  }

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Use whatever implementation runs the fastest
  private int alive_neighbours_around(Cell cell) {
    // The following works but is slower
    // return cell.neighbours.Where(
    //   (neighbour) => neighbour.alive
    // ).ToList().Count;

    // The following works but is slower
    // var alive_neighbours = 0;
    // foreach (var neighbour in cell.neighbours) {
    //   if (neighbour.alive) {
    //     alive_neighbours++;
    //   }
    // }
    // return alive_neighbours;

    // The following was the fastest method
    var alive_neighbours = 0;
    for (var i = 0; i < cell.neighbours.Count; i++) {
      var neighbour = cell.neighbours[i];
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
  public bool? next_state = null;
  public List<Cell> neighbours = [];

  public Cell(int x, int y, bool alive = false) {
    this.x = x;
    this.y = y;
    this.alive = alive;
  }

  public char to_char() {
    return this.alive ? 'o' : ' ';
  }
}
