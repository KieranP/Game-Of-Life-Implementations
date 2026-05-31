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

  private val DIRECTIONS = Array(
    (-1, 1),  (0, 1),  (1, 1),  // above
    (-1, 0),           (1, 0),  // sides
    (-1, -1), (0, -1), (1, -1), // below
  )

  populate_cells
  prepopulate_neighbours

  def dotick =
    val cell_values = cells.values

    // First determine the action for all cells
    for cell <- cell_values do
      val alive_neighbours = cell.alive_neighbours
      if !cell.alive && alive_neighbours == 3 then
        cell.next_state = Some(true)
      else if alive_neighbours < 2 || alive_neighbours > 3 then
        cell.next_state = Some(false)
      else
        cell.next_state = Some(cell.alive)

    // Then execute the determined action for all cells
    for cell <- cell_values do
      cell.alive = cell.next_state.contains(true)

    tick += 1

  def render =
    // The following is slower
    // var rendering = ""
    // var (x, y) = (0, 0)
    // for y <- 0 until height do
    //   for x <- 0 until width do
    //     val cell = cell_at(x, y)
    //     if cell != None then
    //       rendering += cell.get.to_char
    //   rendering += "\n"
    // rendering

    // The following is slower
    // var rendering = ArrayBuffer[String]()
    // var (x, y) = (0, 0)
    // for y <- 0 until height do
    //   for x <- 0 until width do
    //     val cell = cell_at(x, y)
    //     if cell != None then
    //       rendering += cell.get.to_char
    //   rendering += "\n"
    // rendering.mkString("")

    // The following is the fastest
    val render_size = width * height + height
    val rendering = StringBuilder(render_size)
    for y <- 0 until height do
      for x <- 0 until width do
        val cell = cell_at(x, y)
        if cell.isDefined then
          rendering.append(cell.get.to_char)
      rendering.append("\n")
    rendering.toString

  private def make_key(x: Int, y: Int): String =
    // The following is the fastest
    s"$x-$y"

    // The following is slower
    // x.toString + "-" + y.toString

    // The following is slower
    // Seq(x, y).mkString("-")

  private def cell_at(x: Int, y: Int) =
    val key = make_key(x, y)
    cells.get(key)

  private def populate_cells =
    for y <- 0 until height do
      for x <- 0 until width do
        val alive = Random.nextFloat() <= 0.2
        add_cell(x, y, alive)

  private def add_cell(x: Int, y: Int, alive: Boolean = false) =
    val existing = cell_at(x, y)
    if existing.isDefined then
      throw LocationOccupied(x, y)

    val key = make_key(x, y)
    val cell = Cell(x, y, alive)
    cells.put(key, cell)
    true

  private def prepopulate_neighbours =
    for cell <- cells.values do
      val x = cell.x
      val y = cell.y

      for (rel_x, rel_y) <- DIRECTIONS do
        val nx = x + rel_x
        val ny = y + rel_y

        if nx >= 0 && ny >= 0 then
          if nx < width && ny < height then
            val neighbour = cell_at(nx, ny)
            if neighbour.isDefined then
              cell.neighbours.append(neighbour.get)
