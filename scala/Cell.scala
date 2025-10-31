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

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Use whatever implementation runs the fastest
  def alive_neighbours = {
    // The following works but is slower
    // neighbours.filter(_.alive).length

    // The following works but is slower
    // var alive_neighbours = 0
    // for (neighbour <- neighbours) {
    //   if (neighbour.alive) {
    //     alive_neighbours += 1
    //   }
    // }
    // alive_neighbours

    // The following was the fastest method
    var alive_neighbours = 0
    for (i <- 0 until neighbours.length) {
      val neighbour = neighbours(i)
      if (neighbour.alive) {
        alive_neighbours += 1
      }
    }
    alive_neighbours
  }
}
