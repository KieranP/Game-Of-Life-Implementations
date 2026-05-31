class Cell {
  final int x;
  final int y;
  bool alive;
  bool? next_state;
  final List<Cell> neighbours = [];

  Cell(this.x, this.y, [this.alive = false]);

  String to_char() {
    return alive ? 'o' : ' ';
  }

  int alive_neighbours() {
    // The following is slower
    // return neighbours.where(
    //   (neighbour) => neighbour.alive
    // ).length;

    // The following is slower
    // var alive_neighbours = 0;
    // neighbours.forEach((neighbour) {
    //   if (neighbour.alive) {
    //     alive_neighbours += 1;
    //   }
    // });
    // return alive_neighbours;

    // The following is the fastest
    var alive_neighbours = 0;
    final count = neighbours.length;
    for (var i = 0; i < count; i++) {
      final neighbour = neighbours[i];
      if (neighbour.alive) {
        alive_neighbours += 1;
      }
    }
    return alive_neighbours;
  }
}
