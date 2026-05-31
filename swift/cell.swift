final public class Cell {
  public let x: UInt32
  public let y: UInt32
  public var alive: Bool
  public var next_state: Bool?
  public var neighbours: [Cell]

  public init(x: UInt32, y: UInt32, alive: Bool = false) {
    self.x = x
    self.y = y
    self.alive = alive
    self.next_state = nil
    self.neighbours = []
  }

  public func to_char() -> String {
    return alive ? "o" : " "
  }

  public func alive_neighbours() -> UInt32 {
    // The following is the fastest
    return UInt32(neighbours.count(where: \.alive))

    // The following is slower
    // var alive_neighbours = UInt32(0);
    // for neighbour in neighbours {
    //   if neighbour.alive {
    //     alive_neighbours += 1
    //   }
    // }
    // return alive_neighbours

    // The following is slower
    // var alive_neighbours = UInt32(0)
    // let count = neighbours.count
    // for i in 0 ..< count {
    //   let neighbour = neighbours[i]
    //   if neighbour.alive {
    //     alive_neighbours += 1
    //   }
    // }
    // return alive_neighbours
  }
}
