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
    // The following works but is slower
    // return this.neighbours.filter { it.alive }.size

    // The following works but is slower
    // var alive_neighbours = 0
    // for (neighbour in this.neighbours) {
    //   if (neighbour.alive) {
    //     alive_neighbours += 1
    //   }
    // }
    // return alive_neighbours

    // The following was the fastest method
    var alive_neighbours = 0
    for (i in 0 until this.neighbours.size) {
      val neighbour = this.neighbours.get(i)
      if (neighbour.alive) {
        alive_neighbours++
      }
    }
    return alive_neighbours
  }
}
