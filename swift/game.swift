import Darwin

public class World {

  private enum WorldError: Error {
    case LocationOccupied
  }

  public var tick: Int
  private var width: Int
  private var height: Int
  private var cells: [[Cell?]]
  private var cached_directions: Array<Array<Int>>

  public init(width: Int, height: Int) {
    self.width = width
    self.height = height
    self.tick = 0
    self.cells = Array(repeating: Array(repeating: nil, count: height), count: width)
    self.cached_directions = [
      [-1, 1],  [0, 1],  [1, 1], // above
      [-1, 0],           [1, 0], // sides
      [-1, -1], [0, -1], [1, -1] // below
    ]

    populate_cells()
    prepopulate_neighbours()
  }

  public func _tick() -> Void {
    // First determine the action for all cells
    for column in cells {
      for cell in column {
        guard let cell = cell else { continue }
        let alive_neighbours: Int = alive_neighbours_around(cell: cell)
        if !cell.alive && alive_neighbours == 3 {
          cell.next_state = 1
        } else if alive_neighbours < 2 || alive_neighbours > 3 {
          cell.next_state = 0
        }
      }
    }

    // Then execute the determined action for all cells
    for column in cells {
      for cell in column {
        guard let cell = cell else { continue }
        if cell.next_state == 1 {
          cell.alive = true
        } else if cell.next_state == 0 {
          cell.alive = false
        }
      }
    }

    tick += 1
  }

  // Implement first using string concatenation. Then implement any
  // special string builders, and use whatever runs the fastest
  public func render() -> String {
    var rendering = ""
    for y in 0..<height {
      for x in 0..<width {
        guard let cell = cells[x][y] else { continue }
        rendering += cell.to_char()
      }
      rendering += "\n"
    }
    return rendering

    // The following works but is slower
    // var rendering: Array<String> = []
    // for y in 0...height {
    //   for x in 0...width {
    //     // The ! tells Swift to unwrap it from an Optional
    //     let cell: Cell = cell_at(x: x, y: y)!
    //     rendering.append(cell.to_char())
    //   }
    //   rendering.append("\n")
    // }
    // return rendering.joined()
  }

  private func populate_cells() -> Void {
    for y in 0..<height {
      for x in 0..<width {
        let alive: Bool = (Int(arc4random_uniform(100)) <= 20)
        cells[x][y] = Cell(x: x, y: y, alive: alive)
      }
    }
  }

  private func prepopulate_neighbours() -> Void {
    for column in cells {
      for cell in column {
        guard let cell = cell else { continue }
        neighbours_around(cell: cell)
      }
    }
  }

  private func cell_at(x: Int, y: Int) -> Cell? {
    guard x >= 0, x < width, y >= 0, y < height else { return nil }
    return cells[x][y]
  }
  
  @discardableResult
  private func neighbours_around(cell: Cell) -> Array<Cell> {
    if cell.neighbours == nil { // Must return a boolean
      cell.neighbours = []
      for set in cached_directions {
        let neighbour = cell_at(
          x: (cell.x + set[0]),
          y: (cell.y + set[1])
        )
        if (neighbour != nil) {
          // The ! tells Swift to unwrap it from an Optional
          cell.neighbours!.append(neighbour!)
        }
      }
    }

    // The ! tells Swift to unwrap it from an Optional
    return cell.neighbours!
  }

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Retain whatever implementation runs the fastest
  private func alive_neighbours_around(cell: Cell) -> Int {
    // The following works but is slower
    // let neighbours = neighbours_around(cell: cell)
    // return neighbours.filter { $0.alive }.count

    // The following also works but is slower
    // var alive_neighbours = 0;
    // for neighbour in neighbours_around(cell: cell) {
    //   if neighbour.alive {
    //     alive_neighbours += 1
    //   }
    // }
    // return alive_neighbours

    var alive_neighbours = 0
    let neighbours = cell.neighbours ?? []
    for i in 0 ..< neighbours.count {
      let neighbour = neighbours[i]
      if neighbour.alive {
        alive_neighbours += 1
      }
    }
    return alive_neighbours
  }

}

public class Cell {

  public var x: Int
  public var y: Int
  public var alive: Bool
  public var next_state: Int?         // ? allows value to be nil
  public var neighbours: Array<Cell>? // ? allows value to be nil

  public init(x: Int, y: Int, alive: Bool = false) {
    self.x = x
    self.y = y
    self.alive = alive
    self.next_state = nil
    self.neighbours = nil
  }

  public func to_char() -> String {
    return alive ? "o" : " "
  }

}
