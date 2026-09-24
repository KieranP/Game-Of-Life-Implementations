import { World } from './world.js'

// @ts-expect-error Needed for Boa runtime
globalThis.performance ??= {
  now: () => Date.now(),
}

class Play {
  static readonly #WORLD_WIDTH = 150
  static readonly #WORLD_HEIGHT = 40
  static readonly #CLEAR_SCREEN = "\x1b[?2026h\x1b[H\x1b[2J"
  static readonly #SHOW_SCREEN = "\x1b[?2026l"

  public static run() {
    const world = new World(
      Play.#WORLD_WIDTH,
      Play.#WORLD_HEIGHT,
    )

    const minimal =
      typeof Deno === 'object' ? Deno.env.get('MINIMAL') == '1'
      : typeof process === 'object' ? process.env.MINIMAL == '1'
      : true

    if (!minimal) {
      console.log(world.render())
    }

    let totalTick = 0
    let lowestTick = Infinity
    let totalRender = 0
    let lowestRender = Infinity

    while(true) {
      const tickStart = performance.now()
      world.doTick()
      const tickFinish = performance.now()
      const tickTime = (tickFinish - tickStart)
      totalTick += tickTime
      lowestTick = Math.min(lowestTick, tickTime)
      const avgTick = (totalTick / world.tick)

      const renderStart = performance.now()
      const rendered = world.render()
      const renderFinish = performance.now()
      const renderTime = (renderFinish - renderStart)
      totalRender += renderTime
      lowestRender = Math.min(lowestRender, renderTime)
      const avgRender = (totalRender / world.tick)

      if (!minimal) {
        process.stdout.write(Play.#CLEAR_SCREEN)
      }

      console.log(
        `#${world.tick}` +
        ` - World Tick (L: ${Play.#_f(lowestTick)}; A: ${Play.#_f(avgTick)})` +
        ` - Rendering (L: ${Play.#_f(lowestRender)}; A: ${Play.#_f(avgRender)})`
      )

      if (!minimal) {
        console.log(rendered + Play.#SHOW_SCREEN)
      }
    }
  }

  static #_f(value: number) {
    // milliseconds -> no conversion needed
    return value.toFixed(3)
  }
}

Play.run()
