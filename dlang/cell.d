import std.algorithm : filter;
import std.array;

class Cell {
  public:
    uint x;
    uint y;
    bool alive;
    bool next_state;
    Cell[] neighbours;

    this(uint x, uint y, bool alive = false) {
      this.x = x;
      this.y = y;
      this.alive = alive;
    }

    auto to_char() {
      return alive ? 'o' : ' ';
    }

    auto alive_neighbours() {
      // The following is slower
      // return neighbours.filter!(
      //   neighbour => neighbour.alive
      // ).array.length;

      // The following is the fastest
      auto alive_neighbours = 0;
      foreach (ref neighbour; neighbours) {
        if (neighbour.alive) {
          alive_neighbours++;
        }
      }
      return alive_neighbours;

      // The following is about the same speed
      // auto alive_neighbours = 0;
      // auto count = neighbours.length;
      // for (auto i = 0; i < count; i++) {
      //   auto neighbour = neighbours[i];
      //   if (neighbour.alive) {
      //     alive_neighbours++;
      //   }
      // }
      // return alive_neighbours;
    }
}
