import scala.collection.mutable.ArrayBuffer

class Cell(
  val x: Int,
  val y: Int,
  var alive: Boolean = false,
) {
  var next_state: Option[Boolean] = None
  var neighbours = ArrayBuffer[Cell]()

  def to_char = {
    if (alive) "o" else " "
  }

  def alive_neighbours = {
    // The following is slower
    // neighbours.filter(_.alive).length

    // The following is slower
    // var alive_neighbours = 0
    // for (neighbour <- neighbours) {
    //   if (neighbour.alive) {
    //     alive_neighbours += 1
    //   }
    // }
    // alive_neighbours

    // The following is the fastest
    var alive_neighbours = 0
    var count = neighbours.length
    for (i <- 0 until count) {
      val neighbour = neighbours(i)
      if (neighbour.alive) {
        alive_neighbours += 1
      }
    }
    alive_neighbours
  }
}
