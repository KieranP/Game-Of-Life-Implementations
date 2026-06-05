import scala.collection.mutable.ArrayBuffer

class Cell(
  val x: Int,
  val y: Int,
  var alive: Boolean = false,
):
  var nextState: Option[Boolean] = None
  val neighbours = ArrayBuffer[Cell]()

  def toChar =
    if alive then "o" else " "

  def aliveNeighbours =
    // The following is slower
    // neighbours.filter(_.alive).length

    // The following is slower
    // var aliveNeighbours = 0
    // for neighbour <- neighbours do
    //   if neighbour.alive then
    //     aliveNeighbours += 1
    // aliveNeighbours

    // The following is the fastest
    var aliveNeighbours = 0
    val count = neighbours.length
    for i <- 0 until count do
      val neighbour = neighbours(i)
      if neighbour.alive then
        aliveNeighbours += 1
    aliveNeighbours
