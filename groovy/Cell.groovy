class Cell {
  public Integer x
  public Integer y
  public Boolean alive
  public Boolean next_state
  public ArrayList<Cell> neighbours

  public Cell(int x, int y, boolean alive = false) {
    this.x = x
    this.y = y
    this.alive = alive
    this.next_state = null
    this.neighbours = []
  }

  public String to_char() {
    alive ? 'o' : ' '
  }

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Use whatever implementation runs the fastest
  public Integer alive_neighbours() {
    // The following works but is slower
    // neighbours.count { it.alive }

    // The following was the fastest method
    def alive_neighbours = 0
    for (neighbour in neighbours) {
      if (neighbour.alive) {
        alive_neighbours++
      }
    }
    alive_neighbours

    // The following works but is slower
    // def alive_neighbours = 0
    // for (i in 0..neighbours.size()-1) {
    //   def neighbour = neighbours.get(i)
    //   if (neighbour.alive) {
    //     alive_neighbours++
    //   }
    // }
    // alive_neighbours
  }
}
