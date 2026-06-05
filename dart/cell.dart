class Cell {
  final int x;
  final int y;
  bool alive;
  bool? nextState;
  final List<Cell> neighbours = [];

  Cell(this.x, this.y, [this.alive = false]);

  String toChar() {
    return alive ? 'o' : ' ';
  }

  int aliveNeighbours() {
    // The following is slower
    // return neighbours.where(
    //   (neighbour) => neighbour.alive
    // ).length;

    // The following is slower
    // var aliveNeighbours = 0;
    // neighbours.forEach((neighbour) {
    //   if (neighbour.alive) {
    //     aliveNeighbours += 1;
    //   }
    // });
    // return aliveNeighbours;

    // The following is the fastest
    var aliveNeighbours = 0;
    final count = neighbours.length;
    for (var i = 0; i < count; i++) {
      final neighbour = neighbours[i];
      if (neighbour.alive) {
        aliveNeighbours += 1;
      }
    }
    return aliveNeighbours;
  }
}
