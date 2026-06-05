import kotlin.random.Random

public class World(
  private val width: Int,
  private val height: Int
) {
  public var tick = 0

  private val cells = HashMap<String, Cell>()

  private class LocationOccupied(x: Int, y: Int):
    Exception("LocationOccupied($x-$y)")

  companion object {
    private val DIRECTIONS = arrayOf(
      -1 to 1,  0 to 1,  1 to 1, // above
      -1 to 0,           1 to 0, // sides
      -1 to -1, 0 to -1, 1 to -1 // below
    )
  }

  init {
    populateCells()
    prepopulateNeighbours()
  }

  public fun doTick() {
    val cellValues = cells.values

    // First determine the action for all cells
    for (cell in cellValues) {
      val aliveNeighbours = cell.aliveNeighbours()
      if (!cell.alive && aliveNeighbours == 3) {
        cell.nextState = true
      } else if (aliveNeighbours < 2 || aliveNeighbours > 3) {
        cell.nextState = false
      } else {
        cell.nextState = cell.alive
      }
    }

    // Then execute the determined action for all cells
    for (cell in cellValues) {
      cell.alive = cell.nextState!!
    }

    tick++
  }

  public fun render(): String {
    // The following is slower
    // var rendering = ""
    // for (y in 0..<height) {
    //   for (x in 0..<width) {
    //     val cell = cellAt(x, y)
    //     if (cell != null) {
    //       rendering += cell.toChar()
    //     }
    //   }
    //   rendering += "\n"
    // }
    // return rendering

    // The following is slower
    // val rendering = ArrayList<String>();
    // for (y in 0..<height) {
    //   for (x in 0..<width) {
    //     val cell = cellAt(x, y)
    //     if (cell != null) {
    //       rendering.add(cell.toChar().toString())
    //     }
    //   }
    //   rendering.add("\n")
    // }
    // return rendering.joinToString(separator = "");

    // The following is the fastest
    val renderSize = width * height + height
    val rendering = StringBuilder(renderSize)
    for (y in 0..<height) {
      for (x in 0..<width) {
        val cell = cellAt(x, y)
        if (cell != null) {
          rendering.append(cell.toChar())
        }
      }
      rendering.append("\n")
    }
    return rendering.toString()
  }

  private fun makeKey(x: Int, y: Int): String {
    // The following is slower
    // return "$x-$y"

    // The following is the fastest
    return x.toString() + "-" + y.toString()

    // The following is slower
    // return intArrayOf(x, y).joinToString("-")
  }

  private fun cellAt(x: Int, y: Int): Cell? {
    val key = makeKey(x, y)
    return cells[key]
  }

  private fun populateCells() {
    for (y in 0..<height) {
      for (x in 0..<width) {
        val alive = Random.nextDouble() <= 0.2
        addCell(x, y, alive)
      }
    }
  }

  private fun addCell(x: Int, y: Int, alive: Boolean = false): Boolean {
    val existing = cellAt(x, y)
    if (existing != null) {
      throw LocationOccupied(x, y)
    }

    val key = makeKey(x, y)
    val cell = Cell(x, y, alive)
    cells[key] = cell
    return true
  }

  private fun prepopulateNeighbours() {
    for (cell in cells.values) {
      val x = cell.x
      val y = cell.y

      for ((relX, relY) in DIRECTIONS) {
        val nx = x + relX
        val ny = y + relY
        if (nx < 0 || ny < 0) {
          continue // Out of bounds
        }

        if (nx >= width || ny >= height) {
          continue // Out of bounds
        }

        val neighbour = cellAt(nx, ny)
        if (neighbour != null) {
          cell.neighbours.add(neighbour)
        }
      }
    }
  }
}
