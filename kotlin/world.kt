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
      intArrayOf(-1, 1),  intArrayOf(0, 1),  intArrayOf(1, 1), // above
      intArrayOf(-1, 0),                     intArrayOf(1, 0), // sides
      intArrayOf(-1, -1), intArrayOf(0, -1), intArrayOf(1, -1) // below
    )
  }

  init {
    populate_cells()
    prepopulate_neighbours()
  }

  public fun _tick() {
    val cell_values = cells.values

    // First determine the action for all cells
    for (cell in cell_values) {
      val alive_neighbours = cell.alive_neighbours()
      if (!cell.alive && alive_neighbours == 3) {
        cell.next_state = true
      } else if (alive_neighbours < 2 || alive_neighbours > 3) {
        cell.next_state = false
      } else {
        cell.next_state = cell.alive
      }
    }

    // Then execute the determined action for all cells
    for (cell in cell_values) {
      cell.alive = cell.next_state!!
    }

    tick++
  }

  public fun render(): String {
    // The following is slower
    // var rendering = ""
    // for (y in 0 until height) {
    //   for (x in 0 until width) {
    //     val cell = cell_at(x, y)
    //     if (cell != null) {
    //       rendering += cell.to_char()
    //     }
    //   }
    //   rendering += "\n"
    // }
    // return rendering

    // The following is slower
    // val rendering = ArrayList<String>();
    // for (y in 0 until height) {
    //   for (x in 0 until width) {
    //     val cell = cell_at(x, y)
    //     if (cell != null) {
    //       rendering.add(cell.to_char().toString())
    //     }
    //   }
    //   rendering.add("\n")
    // }
    // return rendering.joinToString(separator = "");

    // The following is the fastest
    var render_size = width * height + height
    val rendering = StringBuilder(render_size)
    for (y in 0 until height) {
      for (x in 0 until width) {
        val cell = cell_at(x, y)
        if (cell != null) {
          rendering.append(cell.to_char())
        }
      }
      rendering.append("\n")
    }
    return rendering.toString()
  }

  private fun cell_at(x: Int, y: Int): Cell? {
    return cells["$x-$y"]
  }

  private fun populate_cells() {
    for (y in 0 until height) {
      for (x in 0 until width) {
        val alive = (Math.random() <= 0.2)
        add_cell(x, y, alive)
      }
    }
  }

  private fun add_cell(x: Int, y: Int, alive: Boolean = false): Boolean {
    val existing = cell_at(x, y)
    if (existing != null) {
      throw LocationOccupied(x, y)
    }

    val cell = Cell(x, y, alive)
    cells.put("$x-$y", cell)
    return true
  }

  private fun prepopulate_neighbours() {
    for (cell in cells.values) {
      val x = cell.x
      val y = cell.y

      for ((rel_x, rel_y) in DIRECTIONS) {
        val nx = x + rel_x
        val ny = y + rel_y
        if (nx < 0 || ny < 0) {
          continue // Out of bounds
        }

        if (nx >= width || ny >= height) {
          continue // Out of bounds
        }

        val neighbour = cell_at(nx, ny)
        if (neighbour != null) {
          cell.neighbours.add(neighbour)
        }
      }
    }
  }
}
