class Cell {
  public:
    uint x, y;
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

    // Implement first using filter/lambda if available. Then implement
    // foreach and for. Use whatever implementation runs the fastest
    auto alive_neighbours() {
      // The following works but it slower
      // return neighbours.filter!(
      //   neighbour => neighbour.alive
      // ).array.length;

      // The following was the fastest method
      auto alive_neighbours = 0;
      foreach (ref neighbour; neighbours) {
        if (neighbour.alive) {
          alive_neighbours++;
        }
      }
      return alive_neighbours;

      // The following works but it slower
      // auto alive_neighbours = 0;
      // for (auto i = 0; i < neighbours.length; i++) {
      //   auto neighbour = neighbours[i];
      //   if (neighbour.alive) {
      //     alive_neighbours++;
      //   }
      // }
      // return alive_neighbours;
    }
}
