import scala.collection.mutable.ArrayBuffer

class Cell(
  val x: Int,
  val y: Int,
  var alive: Boolean = false,
):
  var next_state: Option[Boolean] = None
  val neighbours = ArrayBuffer[Cell]()

  def to_char =
    if alive then "o" else " "

  def alive_neighbours =
    // The following is slower
    // neighbours.filter(_.alive).length

    // The following is slower
    // var alive_neighbours = 0
    // for neighbour <- neighbours do
    //   if neighbour.alive then
    //     alive_neighbours += 1
    // alive_neighbours

    // The following is the fastest
    var alive_neighbours = 0
    val count = neighbours.length
    for i <- 0 until count do
      val neighbour = neighbours(i)
      if neighbour.alive then
        alive_neighbours += 1
    alive_neighbours
