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

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Use whatever implementation runs the fastest
  int alive_neighbours() {
    // The following works but is slower
    // return this.neighbours.where(
    //   (neighbour) => neighbour.alive
    // ).length;

    // The following was the fastest method
    var alive_neighbours = 0;
    this.neighbours.forEach((neighbour) {
      if (neighbour.alive) {
        alive_neighbours += 1;
      }
    });
    return alive_neighbours;

    // The following also works but is slower
    // var alive_neighbours = 0;
    // for (var i = 0; i < this.neighbours.length; i++) {
    //   final neighbour = this.neighbours[i];
    //   if (neighbour.alive) {
    //     alive_neighbours += 1;
    //   }
    // }
    // return alive_neighbours;
  }
}
