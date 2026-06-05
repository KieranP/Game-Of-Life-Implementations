public class Cell(
  public val x: Int,
  public val y: Int,
  public var alive: Boolean = false
) {
  public var nextState: Boolean? = null
  public val neighbours = mutableListOf<Cell>()

  public fun toChar(): Char {
    return if (alive) 'o' else ' '
  }

  public fun aliveNeighbours(): Int {
    // The following is slower
    // return this.neighbours.filter { it.alive }.size

    // The following is slower
    // var aliveNeighbours = 0
    // for (neighbour in this.neighbours) {
    //   if (neighbour.alive) {
    //     aliveNeighbours += 1
    //   }
    // }
    // return aliveNeighbours

    // The following is the fastest
    var aliveNeighbours = 0
    val count = this.neighbours.size
    for (i in 0..<count) {
      val neighbour = this.neighbours[i]
      if (neighbour.alive) {
        aliveNeighbours++
      }
    }
    return aliveNeighbours
  }
}
