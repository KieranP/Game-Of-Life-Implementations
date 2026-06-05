using System.Collections.Generic;
// using System.Linq;

public class Cell(uint x, uint y, bool alive = false) {
  public readonly uint X = x;
  public readonly uint Y = y;
  public bool Alive = alive;
  public bool? NextState = null;
  public readonly List<Cell> Neighbours = [];

  public char ToChar() {
    return this.Alive ? 'o' : ' ';
  }

  public uint AliveNeighbours() {
    // The following is slower
    // return (uint)this.Neighbours.Where(
    //   (neighbour) => neighbour.Alive
    // ).ToList().Count;

    // The following is slower
    // var aliveNeighbours = 0u;
    // foreach (var neighbour in this.Neighbours) {
    //   if (neighbour.Alive) {
    //     aliveNeighbours++;
    //   }
    // }
    // return aliveNeighbours;

    // The following is the fastest
    var aliveNeighbours = 0u;
    var count = this.Neighbours.Count;
    for (var i = 0; i < count; i++) {
      var neighbour = this.Neighbours[i];
      if (neighbour.Alive) {
        aliveNeighbours++;
      }
    }
    return aliveNeighbours;
  }
}
