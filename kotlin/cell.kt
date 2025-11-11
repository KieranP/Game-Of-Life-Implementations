public class Cell(
  public val x: Int,
  public val y: Int,
  public var alive: Boolean = false
) {
  public var next_state: Boolean? = null
  public var neighbours = ArrayList<Cell>()

  fun to_char(): Char {
    return if (this.alive) 'o' else ' '
  }

  fun alive_neighbours(): Int {
    // The following is slower
    // return this.neighbours.filter { it.alive }.size

    // The following is slower
    // var alive_neighbours = 0
    // for (neighbour in this.neighbours) {
    //   if (neighbour.alive) {
    //     alive_neighbours += 1
    //   }
    // }
    // return alive_neighbours

    // The following is the fastest
    var alive_neighbours = 0
    var count = this.neighbours.size
    for (i in 0 until count) {
      val neighbour = this.neighbours[i]
      if (neighbour.alive) {
        alive_neighbours++
      }
    }
    return alive_neighbours
  }
}
