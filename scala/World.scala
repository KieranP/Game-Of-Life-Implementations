import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable.HashMap
import scala.util.Random

class World(
  private val width: Int,
  private val height: Int,
):
  var tick = 0

  private val cells = HashMap[String, Cell]()

  private class LocationOccupied(x: Int, y: Int) extends
    Exception(s"LocationOccupied($x-$y)")

  private val Directions = Array(
    (-1, 1),  (0, 1),  (1, 1),  // above
    (-1, 0),           (1, 0),  // sides
    (-1, -1), (0, -1), (1, -1), // below
  )

  populateCells
  prepopulateNeighbours

  def doTick =
    val cellValues = cells.values

    // First determine the action for all cells
    for cell <- cellValues do
      val aliveNeighbours = cell.aliveNeighbours
      if !cell.alive && aliveNeighbours == 3 then
        cell.nextState = Some(true)
      else if aliveNeighbours < 2 || aliveNeighbours > 3 then
        cell.nextState = Some(false)
      else
        cell.nextState = Some(cell.alive)

    // Then execute the determined action for all cells
    for cell <- cellValues do
      cell.alive = cell.nextState.contains(true)

    tick += 1

  def render =
    // The following is slower
    // var rendering = ""
    // var (x, y) = (0, 0)
    // for y <- 0 until height do
    //   for x <- 0 until width do
    //     val cell = cellAt(x, y)
    //     if cell != None then
    //       rendering += cell.get.toChar
    //   rendering += "\n"
    // rendering

    // The following is slower
    // var rendering = ArrayBuffer[String]()
    // var (x, y) = (0, 0)
    // for y <- 0 until height do
    //   for x <- 0 until width do
    //     val cell = cellAt(x, y)
    //     if cell != None then
    //       rendering += cell.get.toChar
    //   rendering += "\n"
    // rendering.mkString("")

    // The following is the fastest
    val renderSize = width * height + height
    val rendering = StringBuilder(renderSize)
    for y <- 0 until height do
      for x <- 0 until width do
        val cell = cellAt(x, y)
        if cell.isDefined then
          rendering.append(cell.get.toChar)
      rendering.append("\n")
    rendering.toString

  private def makeKey(x: Int, y: Int): String =
    // The following is the fastest
    s"$x-$y"

    // The following is slower
    // x.toString + "-" + y.toString

    // The following is slower
    // Seq(x, y).mkString("-")

  private def cellAt(x: Int, y: Int) =
    val key = makeKey(x, y)
    cells.get(key)

  private def populateCells =
    for y <- 0 until height do
      for x <- 0 until width do
        val alive = Random.nextFloat() <= 0.2
        addCell(x, y, alive)

  private def addCell(x: Int, y: Int, alive: Boolean = false) =
    val existing = cellAt(x, y)
    if existing.isDefined then
      throw LocationOccupied(x, y)

    val key = makeKey(x, y)
    val cell = Cell(x, y, alive)
    cells.put(key, cell)
    true

  private def prepopulateNeighbours =
    for cell <- cells.values do
      val x = cell.x
      val y = cell.y

      for (relX, relY) <- Directions do
        val nx = x + relX
        val ny = y + relY

        if nx >= 0 && ny >= 0 then
          if nx < width && ny < height then
            val neighbour = cellAt(nx, ny)
            if neighbour.isDefined then
              cell.neighbours.append(neighbour.get)
