import java.util.ArrayList;
import java.util.List;
// import java.util.stream.Collectors;

public class Cell {
  public final int x;
  public final int y;
  public boolean alive;
  public Boolean nextState;
  public final List<Cell> neighbours;

  public Cell(int x, int y, boolean alive) {
    this.x = x;
    this.y = y;
    this.alive = alive;
    this.nextState = null;
    this.neighbours = new ArrayList<>();
  }

  public char toChar() {
    return this.alive ? 'o' : ' ';
  }

  public int aliveNeighbours() {
    // The following is slower
    // return this.neighbours.stream().
    //   filter(neighbour -> neighbour.alive).
    //   collect(Collectors.toList()).
    //   size();

    // The following is slower
    // var aliveNeighbours = 0;
    // for (var neighbour : this.neighbours) {
    //   if (neighbour.alive) {
    //     aliveNeighbours++;
    //   }
    // }
    // return aliveNeighbours;

    // The following is the fastest
    var aliveNeighbours = 0;
    var count = this.neighbours.size();
    for (var i = 0; i < count; i++) {
      var neighbour = this.neighbours.get(i);
      if (neighbour.alive) {
        aliveNeighbours++;
      }
    }
    return aliveNeighbours;
  }
}
