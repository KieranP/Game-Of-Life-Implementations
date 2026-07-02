import Foundation

final public class World {
  public var tick: UInt32

  private let width: UInt32
  private let height: UInt32
  private var cells: [String: Cell]

  public struct LocationOccupied: Error, LocalizedError {
    let x: UInt32
    let y: UInt32

    public var errorDescription: String? {
      return "LocationOccupied(\(x)-\(y))"
    }
  }

  private static let directions: [(Int, Int)] = [
    (-1, 1),  (0, 1),  (1, 1), // above
    (-1, 0),           (1, 0), // sides
    (-1, -1), (0, -1), (1, -1) // below
  ]

  public init(width: UInt32, height: UInt32) throws(LocationOccupied) {
    self.tick = 0
    self.width = width
    self.height = height
    self.cells = [:]

    try populateCells()
    prepopulateNeighbours()
  }

  public func doTick() {
    // First determine the action for all cells
    for cell in cells.values {
      let aliveNeighbours = cell.aliveNeighbours()
      if !cell.alive && aliveNeighbours == 3 {
        cell.nextState = true
      } else if aliveNeighbours < 2 || aliveNeighbours > 3 {
        cell.nextState = false
      } else {
        cell.nextState = cell.alive
      }
    }

    // Then execute the determined action for all cells
    for cell in cells.values {
      cell.alive = cell.nextState ?? false
    }

    tick += 1
  }

  public func render() -> String {
    // The following is the fastest
    var rendering = ""
    for y in 0..<height {
      for x in 0..<width {
        if let cell = cellAt(x: x, y: y) {
          rendering += cell.toChar()
        }
      }
      rendering += "\n"
    }
    return rendering

    // The following is slower
    // var rendering: Array<String> = []
    // for y in 0..<height {
    //   for x in 0..<width {
    //     if let cell = cellAt(x: x, y: y) {
    //       rendering.append(cell.toChar())
    //     }
    //   }
    //   rendering.append("\n")
    // }
    // return rendering.joined()
  }

  private func makeKey(x: UInt32, y: UInt32) -> String {
    // The following is the fastest
    return "\(x)-\(y)"

    // The following is slower
    // return String(x) + "-" + String(y)

    // The following is slower
    // return [x, y].map(String.init).joined(separator: "-")
  }

  private func cellAt(x: UInt32, y: UInt32) -> Cell? {
    let key = makeKey(x: x, y: y)
    return cells[key]
  }

  private func populateCells() throws(LocationOccupied) {
    for y in 0..<height {
      for x in 0..<width {
        let alive = Double.random(in: 0..<1) <= 0.2
        _ = try addCell(x: x, y: y, alive: alive)
      }
    }
  }

  private func addCell(x: UInt32, y: UInt32, alive: Bool = false) throws(LocationOccupied) -> Bool {
    let existing = cellAt(x: x, y: y)
    if existing != nil {
      throw LocationOccupied(x: x, y: y)
    }

    let key = makeKey(x: x, y: y)
    let cell = Cell(x: x, y: y, alive: alive)
    cells[key] = cell
    return true
  }

  private func prepopulateNeighbours() {
    for cell in cells.values {
      let x = Int(cell.x)
      let y = Int(cell.y)

      for (relX, relY) in World.directions {
        let nx = x + relX
        let ny = y + relY
        if nx < 0 || ny < 0 {
          continue // Out of bounds
        }

        let ux = UInt32(nx)
        let uy = UInt32(ny)
        if ux >= width || uy >= height {
          continue // Out of bounds
        }

        if let neighbour = cellAt(x: ux, y: uy) {
          cell.neighbours.append(neighbour)
        }
      }
    }
  }
}
