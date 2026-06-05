// import std.algorithm : filter;
// import std.array;
import std.typecons : Nullable;

class Cell {
  public:
    const uint x;
    const uint y;
    bool alive;
    Nullable!bool nextState;
    Cell[] neighbours;

    this(uint x, uint y, bool alive = false) {
      this.x = x;
      this.y = y;
      this.alive = alive;
    }

    auto toChar() {
      return alive ? 'o' : ' ';
    }

    auto aliveNeighbours() {
      // The following is slower
      // return neighbours.filter!(
      //   neighbour => neighbour.alive
      // ).array.length;

      // The following is the fastest
      auto aliveNeighbours = 0;
      foreach (ref neighbour; neighbours) {
        if (neighbour.alive) {
          aliveNeighbours++;
        }
      }
      return aliveNeighbours;

      // The following is about the same speed
      // auto aliveNeighbours = 0;
      // auto count = neighbours.length;
      // for (auto i = 0; i < count; i++) {
      //   auto neighbour = neighbours[i];
      //   if (neighbour.alive) {
      //     aliveNeighbours++;
      //   }
      // }
      // return aliveNeighbours;
    }
}
