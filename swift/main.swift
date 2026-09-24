import Foundation

private final class Play {
  private static let worldWidth: UInt32 = 150
  private static let worldHeight: UInt32 = 40
  private static let clearScreen = "\u{001b}[?2026h\u{001b}[H\u{001b}[2J"
  private static let showScreen = "\u{001b}[?2026l"

  public static func run() throws {
    let world = try World(
      width: worldWidth,
      height: worldHeight
    )

    let minimal = ProcessInfo.processInfo.environment["MINIMAL"] == "1"

    if !minimal {
      print(world.render())
    }

    var totalTick = 0.0
    var lowestTick = Double.greatestFiniteMagnitude
    var totalRender = 0.0
    var lowestRender = Double.greatestFiniteMagnitude

    while true {
      let tickStart = ProcessInfo.processInfo.systemUptime
      world.doTick()
      let tickFinish = ProcessInfo.processInfo.systemUptime
      let tickTime = (tickFinish - tickStart)
      totalTick += tickTime
      lowestTick = min(lowestTick, tickTime)
      let avgTick = (totalTick / Double(world.tick))

      let renderStart = ProcessInfo.processInfo.systemUptime
      let rendered = world.render()
      let renderFinish = ProcessInfo.processInfo.systemUptime
      let renderTime = (renderFinish - renderStart)
      totalRender += renderTime
      lowestRender = min(lowestRender, renderTime)
      let avgRender = (totalRender / Double(world.tick))

      if !minimal {
        print(clearScreen, terminator: "")
      }

      print(
        String(
          format: "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)",
          world.tick,
          _f(value: lowestTick),
          _f(value: avgTick),
          _f(value: lowestRender),
          _f(value: avgRender)
        )
      )

      if !minimal {
        print(rendered + showScreen)
      }
    }
  }

  private static func _f(value: Double) -> Double {
    // seconds -> milliseconds
    return value * 1_000
  }
}

try Play.run()
