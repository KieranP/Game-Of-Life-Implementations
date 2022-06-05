// File couldn't be named play.swift because Swift doesnt allow
// top-level code (such as below) unless the file is named main

import Foundation

// Swift doesn't support class constants so declare them here
let World_Width: Int  = 150
let World_Height: Int = 40

public class Play {

  public class func run() -> Void {
    let world: World = World(
      width: World_Width,
      height: World_Height
    )

    print(world.render())

    var total_tick: Double = 0
    var total_render: Double = 0

    while true {
      let tick_start = ProcessInfo.processInfo.systemUptime
      world._tick()
      let tick_finish = ProcessInfo.processInfo.systemUptime
      let tick_time = (tick_finish - tick_start)
      total_tick += tick_time
      let avg_tick = (total_tick / Double(world.tick))

      let render_start = ProcessInfo.processInfo.systemUptime
      let rendered = world.render()
      let render_finish = ProcessInfo.processInfo.systemUptime
      let render_time = (render_finish - render_start)
      total_render += render_time
      let avg_render = (total_render / Double(world.tick))

      var output = "#\(world.tick)"
      output += " - World tick took \(_f(value: tick_time)) (\(_f(value: avg_tick)))"
      output += " - Rendering took \(_f(value: render_time)) (\(_f(value: avg_render)))"
      output += "\n"+rendered
      print("\u{001b}[H\u{001b}[2J")
      print(output)
    }
  }

  private class func _f(value: Double) -> String {
    // value is in seconds, convert to milliseconds
    return String(format: "%.3f", value * 1000)
  }

}

Play.run()
