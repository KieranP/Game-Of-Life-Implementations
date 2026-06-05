public class Cell {
  public final int:Unsigned32 x;
  public final int:Unsigned32 y;
  public boolean alive;
  public boolean? nextState = null;
  public final Cell[] neighbours = [];

  public function init(int:Unsigned32 x, int:Unsigned32 y, boolean alive = false) {
    self.x = x;
    self.y = y;
    self.alive = alive;
  }

  public function toChar() returns string {
    return self.alive ? "o" : " ";
  }

  public function aliveNeighbours() returns int:Unsigned32 {
    // The following is the fastest
    int:Unsigned32 aliveNeighbours = 0;
    foreach Cell neighbour in self.neighbours {
      if neighbour.alive {
        aliveNeighbours = <int:Unsigned32>(aliveNeighbours + 1);
      }
    }
    return aliveNeighbours;

    // The following is slower
    // int:Unsigned32 aliveNeighbours = 0;
    // int count = self.neighbours.length();
    // int i = 0;
    // while i < count {
    //   Cell neighbour = self.neighbours[i];
    //   if neighbour.alive {
    //     aliveNeighbours = <int:Unsigned32>(aliveNeighbours + 1);
    //   }
    //   i += 1;
    // }
    // return aliveNeighbours;
  }
}
