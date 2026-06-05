final public class Cell {
  public let x: UInt32
  public let y: UInt32
  public var alive: Bool
  public var nextState: Bool?
  public var neighbours: [Cell]

  public init(x: UInt32, y: UInt32, alive: Bool = false) {
    self.x = x
    self.y = y
    self.alive = alive
    self.nextState = nil
    self.neighbours = []
  }

  public func toChar() -> String {
    return alive ? "o" : " "
  }

  public func aliveNeighbours() -> UInt32 {
    // The following is the fastest
    return UInt32(neighbours.count(where: \.alive))

    // The following is slower
    // var aliveNeighbours = UInt32(0);
    // for neighbour in neighbours {
    //   if neighbour.alive {
    //     aliveNeighbours += 1
    //   }
    // }
    // return aliveNeighbours

    // The following is slower
    // var aliveNeighbours = UInt32(0)
    // let count = neighbours.count
    // for i in 0 ..< count {
    //   let neighbour = neighbours[i]
    //   if neighbour.alive {
    //     aliveNeighbours += 1
    //   }
    // }
    // return aliveNeighbours
  }
}
