// Files must be named the same as the class/object they contain

import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable.Map
import scala.util.Random

class World(
  private val width: Int,
  private val height: Int,
) {

  class LocationOccupied extends Exception { }

  var tick = 0
  private var cells = Map[String,Cell]()
  private val cached_directions = Array(
    Array(-1, 1),  Array(0, 1),  Array(1, 1),  // above
    Array(-1, 0),                Array(1, 0),  // sides
    Array(-1, -1), Array(0, -1), Array(1, -1), // below
  )

  populate_cells
  prepopulate_neighbours

  def _tick = {
    // First determine the action for all cells
    for ((key, cell) <- cells) {
      val alive_neighbours = alive_neighbours_around(cell)
      if (!cell.alive && alive_neighbours == 3) {
        cell.next_state = Some(1)
      } else if (alive_neighbours < 2 || alive_neighbours > 3) {
        cell.next_state = Some(0)
      }
    }

    // Then execute the determined action for all cells
    for ((key, cell) <- cells) {
      if (cell.next_state != None && cell.next_state.get == 1) {
        cell.alive = true
      } else if (cell.next_state != None && cell.next_state.get == 0) {
        cell.alive = false
      }
    }

    tick += 1
  }

  // Implement first using string concatination. Then implement any
  // special string builders, and use whatever runs the fastest
  def render: String = {
    // The following works but is slower
    // var rendering = ""
    // var (x, y) = (0, 0)
    // for (y <- 0 to height) {
    //   for (x <- 0 to width) {
    //     // get pulls the Cell out of an Option[]
    //     val cell = cell_at(x, y).get
    //     rendering += cell.to_char
    //   }
    //   rendering += "\n"
    // }
    // rendering

    val rendering = new StringBuilder()
    var (x, y) = (0, 0)
    for (y <- 0 to height) {
      for (x <- 0 to width) {
        // get pulls the Cell out of an Option[]
        val cell = cell_at(x, y).get
        rendering.append(cell.to_char)
      }
      rendering.append("\n")
    }
    rendering.toString
  }

  private def populate_cells = {
    var (x, y) = (0, 0)
    for (y <- 0 to height) {
      for (x <- 0 to width) {
        val alive = (Random.nextFloat <= 0.2)
        add_cell(x, y, alive)
      }
    }
  }

  private def prepopulate_neighbours = {
    for ((key,cell) <- cells) {
      neighbours_around(cell)
    }
  }

  private def add_cell(x: Int, y: Int, alive: Boolean = false): Cell = {
    if (cell_at(x, y) != None) { // Must return a boolean
      throw new LocationOccupied()
    }

    val cell = new Cell(x, y, alive)
    cells.put(s"$x-$y", cell)
    // get pulls the Cell out of an Option[]
    cell_at(x, y).get
  }

  private def cell_at(x: Int, y: Int): Option[Cell] = {
    cells.get(s"$x-$y")
  }

  private def neighbours_around(cell: Cell): ArrayBuffer[Cell] = {
    if (cell.neighbours == null) { // Must return a boolean
      cell.neighbours = ArrayBuffer[Cell]()
      for (set <- cached_directions) {
        val neighbour = cell_at(
          x = (cell.x + set(0)),
          y = (cell.y + set(1)),
        )
        if (neighbour != None) {
          // get pulls the Cell out of an Option[]
          cell.neighbours.append(neighbour.get)
        }
      }
    }

    cell.neighbours
  }

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Retain whatever implementation runs the fastest
  private def alive_neighbours_around(cell: Cell): Int = {
    // The following works but is slower
    // neighbours_around(cell).filter(_.alive).length

    // The following was the fastest implementation
    var alive_neighbours = 0
    for (neighbour <- neighbours_around(cell)) {
      if (neighbour.alive) {
        alive_neighbours += 1
      }
    }
    alive_neighbours

    // The following works but is slower
    // var alive_neighbours = 0
    // val neighbours = neighbours_around(cell)
    // for (i <- 0 until neighbours.length) {
    //   val neighbour = neighbours(i)
    //   if (neighbour.alive) {
    //     alive_neighbours += 1
    //   }
    // }
    // alive_neighbours
  }

}

class Cell(
  val x: Int,
  val y: Int,
  var alive: Boolean = false,
) {

  var next_state: Option[Int] = None
  var neighbours: ArrayBuffer[Cell] = null

  def to_char: String = {
    if (alive) "o" else " "
  }

}
