// File couldn't be named play.swift because Swift doesnt allow
// top-level code (such as below) unless the file is named main

import Foundation

// Swift doesn't support class constants so declare them here
let World_Width  = 150
let World_Height = 40

final private class Play {
  public class func run() -> Void {
    let world = World(
      width: World_Width,
      height: World_Height
    )

    let minimal = ProcessInfo.processInfo.environment["MINIMAL"] != nil

    if !minimal {
      print(world.render())
    }

    var total_tick = Double(0)
    var lowest_tick = Double(Int64.max)
    var total_render = Double(0)
    var lowest_render = Double(Int64.max)

    while true {
      let tick_start = ProcessInfo.processInfo.systemUptime
      world._tick()
      let tick_finish = ProcessInfo.processInfo.systemUptime
      let tick_time = (tick_finish - tick_start)
      total_tick += tick_time
      lowest_tick = [lowest_tick, tick_time].min()!
      let avg_tick = (total_tick / Double(world.tick))

      let render_start = ProcessInfo.processInfo.systemUptime
      let rendered = world.render()
      let render_finish = ProcessInfo.processInfo.systemUptime
      let render_time = (render_finish - render_start)
      total_render += render_time
      lowest_render = [lowest_render, render_time].min()!
      let avg_render = (total_render / Double(world.tick))

      if !minimal {
        print("\u{001b}[H\u{001b}[2J")
      }
      print(
        String(
          format: "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)",
          world.tick,
          _f(value: lowest_tick),
          _f(value: avg_tick),
          _f(value: lowest_render),
          _f(value: avg_render)
        )
      )
      if !minimal {
        print(rendered)
      }
    }
  }

  private class func _f(value: Double) -> Double {
    // value is in seconds, convert to milliseconds
    return value * 1_000
  }
}

Play.run()
