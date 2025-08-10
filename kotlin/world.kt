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
    // First determine the action for all cells
    for ((_, cell) in cells) {
      val alive_neighbours = alive_neighbours_around(cell)
      if (!cell.alive && alive_neighbours == 3) {
        cell.next_state = true
      } else if (alive_neighbours < 2 || alive_neighbours > 3) {
        cell.next_state = false
      } else {
        cell.next_state = cell.alive
      }
    }

    // Then execute the determined action for all cells
    for ((_, cell) in cells) {
      cell.alive = cell.next_state!!
    }

    tick++
  }

  // Implement first using string concatenation. Then implement any
  // special string builders, and use whatever runs the fastest
  public fun render(): String {
    // The following works but is slower
    // var rendering = ""
    // for (y in 0 until height) {
    //   for (x in 0 until width) {
    //     val cell = cell_at(x, y)!!
    //     rendering += cell.to_char()
    //   }
    //   rendering += "\n"
    // }
    // return rendering

    // The following works but is slower
    // val rendering = ArrayList<String>();
    // for (y in 0 until height) {
    //   for (x in 0 until width) {
    //     val cell = cell_at(x, y)!!
    //     rendering.add(cell.to_char().toString())
    //   }
    //   rendering.add("\n")
    // }
    // return rendering.joinToString(separator = "");

    // The following was the fastest method
    val rendering = StringBuilder()
    for (y in 0 until height) {
      for (x in 0 until width) {
        val cell = cell_at(x, y)!!
        rendering.append(cell.to_char())
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

  private fun add_cell(x: Int, y: Int, alive: Boolean = false): Cell {
    if (cell_at(x, y) != null) {
      throw LocationOccupied(x, y)
    }

    val cell = Cell(x, y, alive)
    cells.put("$x-$y", cell)
    return cell
  }

  private fun prepopulate_neighbours() {
    for ((_, cell) in cells) {
      for ((rel_x, rel_y) in DIRECTIONS) {
        val neighbour = cell_at(
          (cell.x + rel_x),
          (cell.y + rel_y)
        )

        if (neighbour != null) {
          cell.neighbours.add(neighbour)
        }
      }
    }
  }

  private fun alive_neighbours_around(cell: Cell): Int {
    // The following works but is slower
    // return cell.neighbours.filter { it.alive }.size

    // The following works but is slower
    // var alive_neighbours = 0
    // for (neighbour in cell.neighbours) {
    //   if (neighbour.alive) {
    //     alive_neighbours += 1
    //   }
    // }
    // return alive_neighbours

    // The following was the fastest method
    var alive_neighbours = 0
    for (i in 0 until cell.neighbours.size) {
      val neighbour = cell.neighbours.get(i)
      if (neighbour.alive) {
        alive_neighbours++
      }
    }
    return alive_neighbours
  }
}

public class Cell(
  public val x: Int,
  public val y: Int,
  public var alive: Boolean = false
) {
  public var next_state: Boolean? = null
  public var neighbours = ArrayList<Cell>()

  fun to_char(): Char {
    return if (this.alive) 'o' else ' '
  }
}
