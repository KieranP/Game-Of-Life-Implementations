public class Cell {
  public int:Unsigned32 x;
  public int:Unsigned32 y;
  public boolean alive;
  public boolean next_state = false;
  public Cell[] neighbours = [];

  public function init(int:Unsigned32 x, int:Unsigned32 y, boolean alive = false) {
    self.x = x;
    self.y = y;
    self.alive = alive;
  }

  public function to_char() returns string {
    if self.alive {
      return "o";
    } else {
      return " ";
    }
  }

  public function alive_neighbours() returns int:Unsigned32 {
    // The following is the fastest
    int:Unsigned32 alive_neighbours = 0;
    foreach Cell neighbour in self.neighbours {
      if neighbour.alive {
        alive_neighbours = <int:Unsigned32>(alive_neighbours + 1);
      }
    }
    return alive_neighbours;

    // The following is slower
    // int:Unsigned32 alive_neighbours = 0;
    // int count = self.neighbours.length();
    // int i = 0;
    // while i < count {
    //   Cell neighbour = self.neighbours[i];
    //   if neighbour.alive {
    //     alive_neighbours = <int:Unsigned32>(alive_neighbours + 1);
    //   }
    //   i += 1;
    // }
    // return alive_neighbours;
  }
}
