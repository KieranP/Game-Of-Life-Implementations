import { World } from './world'

class Play {
  static WORLD_WIDTH: u32 = 150
  static WORLD_HEIGHT: u32 = 40

  public static run(): void {
    const world = new World(
      Play.WORLD_WIDTH,
      Play.WORLD_HEIGHT,
    )

    // TODO: Get this from environment
    let minimal: bool = true

    if (!minimal) {
      console.log(world.render())
    }

    let total_tick: f64 = 0.0
    let lowest_tick: f64 = 1e18
    let total_render: f64 = 0.0
    let lowest_render: f64 = 1e18

    while (true) {
      let tick_start = performance.now()
      world._tick()
      let tick_finish = performance.now()
      let tick_time = tick_finish - tick_start
      total_tick += tick_time
      if (tick_time < lowest_tick) lowest_tick = tick_time
      let avg_tick = total_tick / world.tick

      let render_start = performance.now()
      let rendered = world.render()
      let render_finish = performance.now()
      let render_time = render_finish - render_start
      total_render += render_time
      if (render_time < lowest_render) lowest_render = render_time
      let avg_render = total_render / world.tick

      if (!minimal) {
        console.log("\u001b[H\u001b[2J")
      }

      console.log(
        "#" + world.tick.toString()
        + " - World Tick (L: " + Play._f(lowest_tick) + "; A: " + Play._f(avg_tick) + ")"
        + " - Rendering (L: " + Play._f(lowest_render) + "; A: " + Play._f(avg_render) + ")"
      )

      if (!minimal) {
        console.log(rendered)
      }
    }
  }

  private static _f(value: f64): string {
    let rounded = Math.round(value * 1000.0) / 1000.0
    let parts = rounded.toString().split('.')
    const whole = parts[0]
    let frac = parts.length > 1 ? parts[1] : "0"
    while (frac.length < 3) {
      frac = "0" + frac
    }
    return `${whole}.${frac}`
  }
}

Play.run()
