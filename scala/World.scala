import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable.HashMap
import scala.util.Random

class World(
  private val width: Int,
  private val height: Int,
) {
  var tick = 0

  private var cells = HashMap[String,Cell]()

  private class LocationOccupied(x: Int, y: Int) extends
    Exception(s"LocationOccupied($x-$y)")

  private val DIRECTIONS = Array(
    Array(-1, 1),  Array(0, 1),  Array(1, 1),  // above
    Array(-1, 0),                Array(1, 0),  // sides
    Array(-1, -1), Array(0, -1), Array(1, -1), // below
  )

  populate_cells
  prepopulate_neighbours

  def _tick = {
    val cell_values = cells.values

    // First determine the action for all cells
    for (cell <- cell_values) {
      val alive_neighbours = cell.alive_neighbours
      if (!cell.alive && alive_neighbours == 3) {
        cell.next_state = Some(true)
      } else if (alive_neighbours < 2 || alive_neighbours > 3) {
        cell.next_state = Some(false)
      } else {
        cell.next_state = Some(cell.alive)
      }
    }

    // Then execute the determined action for all cells
    for (cell <- cell_values) {
      cell.alive = cell.next_state == Some(true)
    }

    tick += 1
  }

  // Implement first using string concatenation. Then implement any
  // special string builders, and use whatever runs the fastest
  def render = {
    // The following works but is slower
    // var rendering = ""
    // var (x, y) = (0, 0)
    // for (y <- 0 until height) {
    //   for (x <- 0 until width) {
    //     // get pulls the Cell out of an Option[]
    //     val cell = cell_at(x, y).get
    //     rendering += cell.to_char
    //   }
    //   rendering += "\n"
    // }
    // rendering

    // The following works but is slower
    // var rendering = ArrayBuffer[String]()
    // var (x, y) = (0, 0)
    // for (y <- 0 until height) {
    //   for (x <- 0 until width) {
    //     // get pulls the Cell out of an Option[]
    //     val cell = cell_at(x, y).get
    //     rendering += cell.to_char
    //   }
    //   rendering += "\n"
    // }
    // rendering.mkString("")

    // The following was the fastest method
    val rendering = new StringBuilder(width * height + height)
    var (x, y) = (0, 0)
    for (y <- 0 until height) {
      for (x <- 0 until width) {
        val cell = cell_at(x, y).get
        rendering.append(cell.to_char)
      }
      rendering.append("\n")
    }
    rendering.toString
  }

  private def cell_at(x: Int, y: Int) = {
    cells.get(s"$x-$y")
  }

  private def populate_cells = {
    var (x, y) = (0, 0)
    for (y <- 0 until height) {
      for (x <- 0 until width) {
        val alive = (Random.nextFloat() <= 0.2)
        add_cell(x, y, alive)
      }
    }
  }

  private def add_cell(x: Int, y: Int, alive: Boolean = false) = {
    if (cell_at(x, y) != None) {
      throw new LocationOccupied(x, y)
    }

    val cell = new Cell(x, y, alive)
    cells.put(s"$x-$y", cell)
    true
  }

  private def prepopulate_neighbours = {
    for (cell <- cells.values) {
      for (set <- DIRECTIONS) {
        val neighbour = cell_at(
          x = (cell.x + set(0)),
          y = (cell.y + set(1)),
        )

        if (neighbour != None) {
          cell.neighbours.append(neighbour.get)
        }
      }
    }
  }
}
