using System.Collections.Generic;
using System.Linq;

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

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Use whatever implementation runs the fastest
  public int alive_neighbours() {
    // The following works but is slower
    // return this.neighbours.Where(
    //   (neighbour) => neighbour.alive
    // ).ToList().Count;

    // The following works but is slower
    // var alive_neighbours = 0;
    // foreach (var neighbour in this.neighbours) {
    //   if (neighbour.alive) {
    //     alive_neighbours++;
    //   }
    // }
    // return alive_neighbours;

    // The following was the fastest method
    var alive_neighbours = 0;
    for (var i = 0; i < this.neighbours.Count; i++) {
      var neighbour = this.neighbours[i];
      if (neighbour.alive) {
        alive_neighbours++;
      }
    }
    return alive_neighbours;
  }
}
