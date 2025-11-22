import Foundation

final public class World {
  public var tick: UInt32

  private var width: UInt32
  private var height: UInt32
  private var cells: [String: Cell]

  private struct LocationOccupied: Error, LocalizedError {
    let x: UInt32
    let y: UInt32

    var errorDescription: String? {
      return "LocationOccupied(\(x)-\(y))"
    }
  }

  private static let DIRECTIONS: [[Int]] = [
    [-1, 1],  [0, 1],  [1, 1], // above
    [-1, 0],           [1, 0], // sides
    [-1, -1], [0, -1], [1, -1] // below
  ]

  public init(width: UInt32, height: UInt32) {
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
      let alive_neighbours = cell.alive_neighbours()
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

  public func render() -> String {
    // The following is the fastest
    var rendering = ""
    for y in 0..<height {
      for x in 0..<width {
        let cell = cell_at(x: x, y: y)
        if cell != nil {
          rendering += cell!.to_char()
        }
      }
      rendering += "\n"
    }
    return rendering

    // The following is slower
    // var rendering: Array<String> = []
    // for y in 0..<height {
    //   for x in 0..<width {
    //     let cell = cell_at(x: x, y: y)
    //     if cell != nil {
    //       rendering.append(cell!.to_char())
    //     }
    //   }
    //   rendering.append("\n")
    // }
    // return rendering.joined()
  }

  private func cell_at(x: UInt32, y: UInt32) -> Cell? {
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

  private func add_cell(x: UInt32, y: UInt32, alive: Bool = false) -> Bool {
    let existing = cell_at(x: x, y: y)
    if existing != nil {
      do {
        throw LocationOccupied(x: x, y: y)
      } catch {
        print(error.localizedDescription)
        exit(1)
      }
    }

    let cell = Cell(x: x, y: y, alive: alive)
    cells["\(x)-\(y)"] = cell
    return true
  }

  private func prepopulate_neighbours() -> Void {
    for (_, cell) in cells {
      let x = Int(cell.x)
      let y = Int(cell.y)

      for set in World.DIRECTIONS {
        let nx = x + set[0]
        let ny = y + set[1]
        if nx < 0 || ny < 0 {
          continue // Out of bounds
        }

        let ux = UInt32(nx)
        let uy = UInt32(ny)
        if ux >= width || uy >= height {
          continue // Out of bounds
        }

        let neighbour = cell_at(x: ux, y: uy)
        if neighbour != nil {
          cell.neighbours.append(neighbour!)
        }
      }
    }
  }
}
