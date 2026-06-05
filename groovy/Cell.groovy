class Cell {
  public final int x
  public final int y
  public boolean alive
  public Boolean nextState
  public final List<Cell> neighbours

  public Cell(int x, int y, boolean alive = false) {
    this.x = x
    this.y = y
    this.alive = alive
    this.nextState = null
    this.neighbours = []
  }

  public char toChar() {
    (alive ? 'o' : ' ') as char
  }

  public int aliveNeighbours() {
    // The following is slower
    // neighbours.count { it.alive } as int

    // The following is the fastest
    // var aliveNeighbours = 0
    // for (neighbour in neighbours) {
    //   if (neighbour.alive) {
    //     aliveNeighbours++
    //   }
    // }
    // aliveNeighbours

    // The following is slower
    var aliveNeighbours = 0
    var count = neighbours.size()
    for (i in 0..<count) {
      var neighbour = neighbours[i]
      if (neighbour.alive) {
        aliveNeighbours++
      }
    }
    aliveNeighbours
  }
}
