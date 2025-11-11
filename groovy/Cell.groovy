class Cell {
  public int x
  public int y
  public boolean alive
  public Boolean next_state
  public ArrayList<Cell> neighbours

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
    // def alive_neighbours = 0
    // for (neighbour in neighbours) {
    //   if (neighbour.alive) {
    //     alive_neighbours++
    //   }
    // }
    // alive_neighbours

    // The following is slower
    def alive_neighbours = 0
    def count = neighbours.size()
    for (i in 0..<count) {
      def neighbour = neighbours[i]
      if (neighbour.alive) {
        alive_neighbours++
      }
    }
    alive_neighbours
  }
}
