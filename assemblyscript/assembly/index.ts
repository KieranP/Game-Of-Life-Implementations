import { World } from './world'

class Play {
  static readonly WORLD_WIDTH: u32 = 150
  static readonly WORLD_HEIGHT: u32 = 40

  public static run(): void {
    const world = new World(
      Play.WORLD_WIDTH,
      Play.WORLD_HEIGHT,
    )

    const minimal: bool = process.env.has('MINIMAL')

    if (!minimal) {
      console.log(world.render())
    }

    let totalTick: f64 = 0.0
    let lowestTick: f64 = 1e18
    let totalRender: f64 = 0.0
    let lowestRender: f64 = 1e18

    while (true) {
      const tickStart = performance.now()
      world.doTick()
      const tickFinish = performance.now()
      const tickTime = tickFinish - tickStart
      totalTick += tickTime
      if (tickTime < lowestTick) lowestTick = tickTime
      const avgTick = totalTick / world.tick

      const renderStart = performance.now()
      const rendered = world.render()
      const renderFinish = performance.now()
      const renderTime = renderFinish - renderStart
      totalRender += renderTime
      if (renderTime < lowestRender) lowestRender = renderTime
      const avgRender = totalRender / world.tick

      if (!minimal) {
        console.log("\u001b[H\u001b[2J")
      }

      console.log(
        `#${world.tick}`
        + ` - World Tick (L: ${Play._f(lowestTick)}; A: ${Play._f(avgTick)})`
        + ` - Rendering (L: ${Play._f(lowestRender)}; A: ${Play._f(avgRender)})`
      )

      if (!minimal) {
        console.log(rendered)
      }
    }
  }

  private static _f(value: f64): string {
    const rounded = Math.round(value * 1000.0) / 1000.0
    const parts = rounded.toString().split('.')
    const whole = parts[0]
    const frac = (parts.length > 1 ? parts[1] : "0").padEnd(3, "0")
    return `${whole}.${frac}`
  }
}

Play.run()
