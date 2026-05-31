import java.util.ArrayList;
// import java.util.stream.Collectors;

public class Cell {
  public final int x;
  public final int y;
  public boolean alive;
  public Boolean next_state;
  public final ArrayList<Cell> neighbours;

  public Cell(int x, int y, boolean alive) {
    this.x = x;
    this.y = y;
    this.alive = alive;
    this.next_state = null;
    this.neighbours = new ArrayList<>();
  }

  public char to_char() {
    return this.alive ? 'o' : ' ';
  }

  public int alive_neighbours() {
    // The following is slower
    // return this.neighbours.stream().
    //   filter(neighbour -> neighbour.alive).
    //   collect(Collectors.toList()).
    //   size();

    // The following is slower
    // var alive_neighbours = 0;
    // for (var neighbour : this.neighbours) {
    //   if (neighbour.alive) {
    //     alive_neighbours++;
    //   }
    // }
    // return alive_neighbours;

    // The following is the fastest
    var alive_neighbours = 0;
    var count = this.neighbours.size();
    for (var i = 0; i < count; i++) {
      var neighbour = this.neighbours.get(i);
      if (neighbour.alive) {
        alive_neighbours++;
      }
    }
    return alive_neighbours;
  }
}
