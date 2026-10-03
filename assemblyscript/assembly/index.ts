import { World } from './world'

class Play {
  private static readonly WORLD_WIDTH: u32 = 150
  private static readonly WORLD_HEIGHT: u32 = 40
  private static readonly CLEAR_SCREEN: string = "\x1b[?2026h\x1b[H\x1b[2J"
  private static readonly SHOW_SCREEN: string = "\x1b[?2026l"

  public static run(): void {
    const world = new World(
      Play.WORLD_WIDTH,
      Play.WORLD_HEIGHT,
    )

    const minimal: bool = process.env.has('MINIMAL') && process.env.get('MINIMAL') == '1'

    if (!minimal) {
      console.log(world.render())
    }

    let totalTick: f64 = 0.0
    let lowestTick: f64 = Infinity
    let totalRender: f64 = 0.0
    let lowestRender: f64 = Infinity

    while (true) {
      const tickStart = performance.now()
      world.doTick()
      const tickFinish = performance.now()
      const tickTime = tickFinish - tickStart
      totalTick += tickTime
      lowestTick = Math.min(lowestTick, tickTime)
      const avgTick = totalTick / world.tick

      const renderStart = performance.now()
      const rendered = world.render()
      const renderFinish = performance.now()
      const renderTime = renderFinish - renderStart
      totalRender += renderTime
      lowestRender = Math.min(lowestRender, renderTime)
      const avgRender = totalRender / world.tick

      if (!minimal) {
        process.stdout.write(Play.CLEAR_SCREEN)
      }

      console.log(
        `#${world.tick}`
        + ` - World Tick (L: ${Play._f(lowestTick)}; A: ${Play._f(avgTick)})`
        + ` - Rendering (L: ${Play._f(lowestRender)}; A: ${Play._f(avgRender)})`
      )

      if (!minimal) {
        console.log(rendered + Play.SHOW_SCREEN)
      }
    }
  }

  private static _f(value: f64): string {
    // milliseconds -> no conversion needed, padded to 3 decimal places
    const rounded = Math.round(value * 1000.0) / 1000.0
    const parts = rounded.toString().split('.')
    const whole = parts[0]
    let frac = "0"
    if (parts.length > 1) {
      frac = parts[1]
    }
    return `${whole}.${frac.padEnd(3, "0")}`
  }
}

Play.run()
