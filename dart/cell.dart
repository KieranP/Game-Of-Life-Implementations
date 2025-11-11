class Cell {
  int x;
  int y;
  bool alive;
  bool? next_state = null;
  List<Cell> neighbours = [];

  Cell(this.x, this.y, [this.alive = false]) {}

  String to_char() {
    return this.alive ? 'o' : ' ';
  }

  int alive_neighbours() {
    // The following is slower
    // return this.neighbours.where(
    //   (neighbour) => neighbour.alive
    // ).length;

    // The following is slower
    // var alive_neighbours = 0;
    // this.neighbours.forEach((neighbour) {
    //   if (neighbour.alive) {
    //     alive_neighbours += 1;
    //   }
    // });
    // return alive_neighbours;

    // The following is the fastest
    var alive_neighbours = 0;
    var count = this.neighbours.length;
    for (var i = 0; i < count; i++) {
      final neighbour = this.neighbours[i];
      if (neighbour.alive) {
        alive_neighbours += 1;
      }
    }
    return alive_neighbours;
  }
}
