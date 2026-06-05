using System;
using System.Text;
using System.Collections.Generic;

public class World {
  public uint Tick = 0;

  private readonly uint width;
  private readonly uint height;
  private readonly Dictionary<string, Cell> cells = [];

  private class LocationOccupied(uint x, uint y) : Exception($"LocationOccupied({x}-{y})");

  private static readonly (int, int)[] Directions = [
    (-1, 1),  (0, 1),  (1, 1), // above
    (-1, 0),           (1, 0), // sides
    (-1, -1), (0, -1), (1, -1) // below
  ];

  public World(uint width, uint height) {
    this.width = width;
    this.height = height;

    PopulateCells();
    PrepopulateNeighbours();
  }

  public void DoTick() {
    var cellValues = cells.Values;

    // First determine the action for all cells
    foreach (var cell in cellValues) {
      var aliveNeighbours = cell.AliveNeighbours();
      if (!cell.Alive && aliveNeighbours == 3) {
        cell.NextState = true;
      } else if (aliveNeighbours < 2 || aliveNeighbours > 3) {
        cell.NextState = false;
      } else {
        cell.NextState = cell.Alive;
      }
    }

    // Then execute the determined action for all cells
    foreach (var cell in cellValues) {
      cell.Alive = cell.NextState ?? false;
    }

    Tick++;
  }

  public string Render() {
    // The following is slower
    // var rendering = "";
    // for (var y = 0u; y < height; y++) {
    //   for (var x = 0u; x < width; x++) {
    //     var cell = CellAt(x, y);
    //     if (cell is not null) {
    //       rendering += cell.ToChar();
    //     }
    //   }
    //   rendering += "\n";
    // }
    // return rendering;

    // The following is slower
    // var rendering = new List<String>();
    // for (var y = 0u; y < height; y++) {
    //   for (var x = 0u; x < width; x++) {
    //     var cell = CellAt(x, y);
    //     if (cell is not null) {
    //       rendering.Add(cell.ToChar().ToString());
    //     }
    //   }
    //   rendering.Add("\n");
    // }
    // return String.Join("", rendering.ToArray());

    // The following is the fastest
    var renderSize = (int)(width * height + height);
    var rendering = new StringBuilder(renderSize);
    for (var y = 0u; y < height; y++) {
      for (var x = 0u; x < width; x++) {
        var cell = CellAt(x, y);
        if (cell is not null) {
          rendering.Append(cell.ToChar());
        }
      }
      rendering.Append('\n');
    }
    return rendering.ToString();
  }

  private string MakeKey(uint x, uint y) {
    // The following is slower
    // return $"{x}-{y}";

    // The following is the fastest
    return x.ToString() + "-" + y.ToString();

    // The following is slower
    // return string.Join("-", x.ToString(), y.ToString());
  }

  private Cell? CellAt(uint x, uint y) {
    var key = MakeKey(x, y);
    cells.TryGetValue(key, out var value);
    return value;
  }

  private void PopulateCells() {
    var random = new Random();
    for (var y = 0u; y < height; y++) {
      for (var x = 0u; x < width; x++) {
        var alive = random.NextDouble() <= 0.2;
        AddCell(x, y, alive);
      }
    }
  }

  private bool AddCell(uint x, uint y, bool alive = false) {
    var existing = CellAt(x, y);
    if (existing is not null) {
      throw new LocationOccupied(x, y);
    }

    var key = MakeKey(x, y);
    var cell = new Cell(x, y, alive);
    cells.Add(key, cell);
    return true;
  }

  private void PrepopulateNeighbours() {
    foreach (var cell in cells.Values) {
      var x = cell.X;
      var y = cell.Y;

      foreach (var (relX, relY) in Directions) {
        var nx = x + relX;
        var ny = y + relY;
        if (nx < 0 || ny < 0) {
          continue; // Out of bounds
        }

        var ux = (uint)nx;
        var uy = (uint)ny;
        if (ux >= width || uy >= height) {
          continue; // Out of bounds
        }

        var neighbour = CellAt(ux, uy);
        if (neighbour is not null) {
          cell.Neighbours.Add(neighbour);
        }
      }
    }
  }
}
