import Darwin
import Foundation

final public class World {
  public var tick: Int

  private var width: Int
  private var height: Int
  private var cells: Dictionary<String, Cell>

  private struct LocationOccupied: Error, LocalizedError {
     let x: Int
     let y: Int

     var errorDescription: String? {
       return "LocationOccupied(\(x)-\(y))"
     }
   }

  private static let DIRECTIONS: Array<Array<Int>> = [
    [-1, 1],  [0, 1],  [1, 1], // above
    [-1, 0],           [1, 0], // sides
    [-1, -1], [0, -1], [1, -1] // below
  ]

  public init(width: Int, height: Int) {
    self.tick = 0
    self.width = width
    self.height = height
    self.cells = [:]

    populate_cells()
    prepopulate_neighbours()
  }

  public func _tick() -> Void {
    // First determine the action for all cells
    for (_, cell) in cells {
      let alive_neighbours = alive_neighbours_around(cell: cell)
      if !cell.alive && alive_neighbours == 3 {
        cell.next_state = true
      } else if alive_neighbours < 2 || alive_neighbours > 3 {
        cell.next_state = false
      } else {
        cell.next_state = cell.alive
      }
    }

    // Then execute the determined action for all cells
    for (_, cell) in cells {
      cell.alive = cell.next_state ?? false
    }

    tick += 1
  }

  // Implement first using string concatenation. Then implement any
  // special string builders, and use whatever runs the fastest
  public func render() -> String {
    // The following was the fastest method
    var rendering = ""
    for y in 0..<height {
      for x in 0..<width {
        let cell = cell_at(x: x, y: y)!
        rendering += cell.to_char()
      }
      rendering += "\n"
    }
    return rendering

    // The following works but is slower
    // var rendering: Array<String> = []
    // for y in 0..<height {
    //   for x in 0..<width {
    //     let cell = cell_at(x: x, y: y)!
    //     rendering.append(cell.to_char())
    //   }
    //   rendering.append("\n")
    // }
    // return rendering.joined()
  }

  private func cell_at(x: Int, y: Int) -> Cell? {
    return cells["\(x)-\(y)"]
  }

  private func populate_cells() -> Void {
    for y in 0..<height {
      for x in 0..<width {
        let alive = (Int(arc4random_uniform(100)) <= 20)
        _ = add_cell(x: x, y: y, alive: alive)
      }
    }
  }

  private func add_cell(x: Int, y: Int, alive: Bool = false) -> Cell {
    if cell_at(x: x, y: y) != nil {
      do {
        throw LocationOccupied(x: x, y: y)
      } catch {
        print(error.localizedDescription)
        exit(1)
      }
    }

    let cell = Cell(x: x, y: y, alive: alive)
    cells["\(x)-\(y)"] = cell
    return cell
  }

  private func prepopulate_neighbours() -> Void {
    for (_, cell) in cells {
      for set in World.DIRECTIONS {
        let neighbour = cell_at(
          x: (cell.x + set[0]),
          y: (cell.y + set[1])
        )

        if (neighbour != nil) {
          cell.neighbours.append(neighbour!)
        }
      }
    }
  }

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Use whatever implementation runs the fastest
  private func alive_neighbours_around(cell: Cell) -> Int {
    // The following works but is slower
    // return cell.neighbours.filter { $0.alive }.count

    // The following works but is slower
    // var alive_neighbours = 0;
    // for neighbour in cell.neighbours {
    //   if neighbour.alive {
    //     alive_neighbours += 1
    //   }
    // }
    // return alive_neighbours

    // The following was the fastest method
    var alive_neighbours = 0
    for i in 0 ..< cell.neighbours.count {
      let neighbour = cell.neighbours[i]
      if neighbour.alive {
        alive_neighbours += 1
      }
    }
    return alive_neighbours
  }
}

final private class Cell {
  public var x: Int
  public var y: Int
  public var alive: Bool
  public var next_state: Bool?
  public var neighbours: Array<Cell>

  public init(x: Int, y: Int, alive: Bool = false) {
    self.x = x
    self.y = y
    self.alive = alive
    self.next_state = nil
    self.neighbours = []
  }

  public func to_char() -> String {
    return alive ? "o" : " "
  }
}
