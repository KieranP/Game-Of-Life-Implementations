class Cell {
  public final int x
  public final int y
  public boolean alive
  public Boolean next_state
  public final List<Cell> neighbours

  public Cell(int x, int y, boolean alive = false) {
    this.x = x
    this.y = y
    this.alive = alive
    this.next_state = null
    this.neighbours = []
  }

  public char to_char() {
    (alive ? 'o' : ' ') as char
  }

  public int alive_neighbours() {
    // The following is slower
    // neighbours.count { it.alive } as int

    // The following is the fastest
    // var alive_neighbours = 0
    // for (neighbour in neighbours) {
    //   if (neighbour.alive) {
    //     alive_neighbours++
    //   }
    // }
    // alive_neighbours

    // The following is slower
    var alive_neighbours = 0
    var count = neighbours.size()
    for (i in 0..<count) {
      var neighbour = neighbours[i]
      if (neighbour.alive) {
        alive_neighbours++
      }
    }
    alive_neighbours
  }
}
