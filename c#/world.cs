using System;
using System.Text;
using System.Collections.Generic;

public class World {
  public uint tick = 0;

  private uint width;
  private uint height;
  private Dictionary<string, Cell> cells = new Dictionary<string, Cell>();

  private class LocationOccupied : Exception {
    public LocationOccupied(uint x, uint y) :
      base($"LocationOccupied({x}-{y})") { }
  }

  private static readonly int[][] DIRECTIONS = [
    [-1, 1],  [0, 1],  [1, 1], // above
    [-1, 0],           [1, 0], // sides
    [-1, -1], [0, -1], [1, -1] // below
  ];

  public World(uint width, uint height) {
    this.width = width;
    this.height = height;

    populate_cells();
    prepopulate_neighbours();
  }

  public void _tick() {
    var cell_values = cells.Values;

    // First determine the action for all cells
    foreach (var cell in cell_values) {
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
    foreach (var cell in cell_values) {
      cell.alive = cell.next_state ?? false;
    }

    tick++;
  }

  public string render() {
    // The following is slower
    // var rendering = "";
    // for (var y = 0u; y < height; y++) {
    //   for (var x = 0u; x < width; x++) {
    //     var cell = cell_at(x, y);
    //     if (cell != null) {
    //       rendering += cell.to_char();
    //     }
    //   }
    //   rendering += "\n";
    // }
    // return rendering;

    // The following is slower
    // var rendering = new List<String>();
    // for (var y = 0u; y < height; y++) {
    //   for (var x = 0u; x < width; x++) {
    //     var cell = cell_at(x, y);
    //     if (cell != null) {
    //       rendering.Add(cell.to_char().ToString());
    //     }
    //   }
    //   rendering.Add("\n");
    // }
    // return String.Join("", rendering.ToArray());

    // The following is the fastest
    var render_size = (int)(width * height + height);
    var rendering = new StringBuilder(render_size);
    for (var y = 0u; y < height; y++) {
      for (var x = 0u; x < width; x++) {
        var cell = cell_at(x, y);
        if (cell != null) {
          rendering.Append(cell.to_char());
        }
      }
      rendering.Append('\n');
    }
    return rendering.ToString();
  }

  private Cell cell_at(uint x, uint y) {
    var key = $"{x}-{y}";
    if (cells.TryGetValue(key, out Cell value)) {
      return value;
    } else {
      return null;
    }
  }

  private void populate_cells() {
    var random = new Random();
    for (var y = 0u; y < height; y++) {
      for (var x = 0u; x < width; x++) {
        var alive = random.NextDouble() <= 0.2;
        add_cell(x, y, alive);
      }
    }
  }

  private bool add_cell(uint x, uint y, bool alive = false) {
    var existing = cell_at(x, y);
    if (existing != null) {
      throw new LocationOccupied(x, y);
    }

    var cell = new Cell(x, y, alive);
    cells.Add($"{x}-{y}", cell);
    return true;
  }

  private void prepopulate_neighbours() {
    foreach (var cell in cells.Values) {
      var x = cell.x;
      var y = cell.y;

      foreach (var set in DIRECTIONS) {
        var nx = x + set[0];
        var ny = y + set[1];
        if (nx < 0 || ny < 0) {
          continue; // Out of bounds
        }

        var ux = (uint)nx;
        var uy = (uint)ny;
        if (ux >= width || uy >= height) {
          continue; // Out of bounds
        }

        var neighbour = cell_at(ux, uy);
        if (neighbour != null) {
          cell.neighbours.Add(neighbour);
        }
      }
    }
  }
}
