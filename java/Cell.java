import java.util.ArrayList;
import java.util.stream.Collectors;

public class Cell {
  public int x;
  public int y;
  public boolean alive;
  public Boolean next_state;
  public ArrayList<Cell> neighbours;

  public Cell(int x, int y, boolean... args) {
    this.x = x;
    this.y = y;
    this.alive = args[0];
    this.next_state = null;
    this.neighbours = new ArrayList<>();
  }

  public char to_char() {
    return this.alive ? 'o' : ' ';
  }

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Use whatever implementation runs the fastest
  public int alive_neighbours() {
    // The following works but is slower
    // return this.neighbours.stream().
    //   filter(neighbour -> neighbour.alive).
    //   collect(Collectors.toList()).
    //   size();

    // The following works but is slower
    // var alive_neighbours = 0;
    // for (var neighbour : this.neighbours) {
    //   if (neighbour.alive) {
    //     alive_neighbours++;
    //   }
    // }
    // return alive_neighbours;

    // The following was the fastest method
    var alive_neighbours = 0;
    for (var i = 0; i < this.neighbours.size(); i++) {
      var neighbour = this.neighbours.get(i);
      if (neighbour.alive) {
        alive_neighbours++;
      }
    }
    return alive_neighbours;
  }
}
