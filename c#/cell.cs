using System.Collections.Generic;
using System.Linq;

public class Cell {
  public uint x;
  public uint y;
  public bool alive;
  public bool? next_state = null;
  public List<Cell> neighbours = [];

  public Cell(uint x, uint y, bool alive = false) {
    this.x = x;
    this.y = y;
    this.alive = alive;
  }

  public char to_char() {
    return this.alive ? 'o' : ' ';
  }

  public uint alive_neighbours() {
    // The following is slower
    // return (uint)this.neighbours.Where(
    //   (neighbour) => neighbour.alive
    // ).ToList().Count;

    // The following is slower
    // var alive_neighbours = 0u;
    // foreach (var neighbour in this.neighbours) {
    //   if (neighbour.alive) {
    //     alive_neighbours++;
    //   }
    // }
    // return alive_neighbours;

    // The following is the fastest
    var alive_neighbours = 0u;
    var count = this.neighbours.Count;
    for (var i = 0; i < count; i++) {
      var neighbour = this.neighbours[i];
      if (neighbour.alive) {
        alive_neighbours++;
      }
    }
    return alive_neighbours;
  }
}
