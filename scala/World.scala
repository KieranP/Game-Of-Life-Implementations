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

  def dotick = {
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

  def render = {
    // The following is slower
    // var rendering = ""
    // var (x, y) = (0, 0)
    // for (y <- 0 until height) {
    //   for (x <- 0 until width) {
    //     val cell = cell_at(x, y)
    //     if (cell != None) {
    //       rendering += cell.get.to_char
    //     }
    //   }
    //   rendering += "\n"
    // }
    // rendering

    // The following is slower
    // var rendering = ArrayBuffer[String]()
    // var (x, y) = (0, 0)
    // for (y <- 0 until height) {
    //   for (x <- 0 until width) {
    //     val cell = cell_at(x, y)
    //     if (cell != None) {
    //       rendering += cell.get.to_char
    //     }
    //   }
    //   rendering += "\n"
    // }
    // rendering.mkString("")

    // The following is the fastest
    val render_size = width * height + height
    val rendering = new StringBuilder(render_size)
    var (x, y) = (0, 0)
    for (y <- 0 until height) {
      for (x <- 0 until width) {
        val cell = cell_at(x, y)
        if (cell != None) {
          rendering.append(cell.get.to_char)
        }
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
    val existing = cell_at(x, y)
    if (existing != None) {
      throw new LocationOccupied(x, y)
    }

    val cell = new Cell(x, y, alive)
    cells.put(s"$x-$y", cell)
    true
  }

  private def prepopulate_neighbours = {
    for (cell <- cells.values) {
      val x = cell.x
      val y = cell.y

      for (set <- DIRECTIONS) {
        val nx = x + set(0)
        val ny = y + set(1)

        if (nx >= 0 && ny >= 0) {
          if (nx < width && ny < height) {
            val neighbour = cell_at(nx, ny)
            if (neighbour != None) {
              cell.neighbours.append(neighbour.get)
            }
          }
        }
      }
    }
  }
}
