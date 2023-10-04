import {World} from './world.js'

class Play {
  static #World_Width = 150
  static #World_Height = 40

  public static run() {
    const world = new World(
      Play.#World_Width,
      Play.#World_Height,
    )

    console.log(world.render())

    let total_tick = 0
    let lowest_tick = Infinity
    let total_render = 0
    let lowest_render = Infinity

    while(true) {
      const tick_start = performance.now()
      world._tick()
      const tick_finish = performance.now()
      const tick_time = (tick_finish - tick_start)
      total_tick += tick_time
      lowest_tick = Math.min(lowest_tick, tick_time)
      const avg_tick = (total_tick / world.tick)

      const render_start = performance.now()
      const rendered = world.render()
      const render_finish = performance.now()
      const render_time = (render_finish - render_start)
      total_render += render_time
      lowest_render = Math.min(lowest_render, render_time)
      const avg_render = (total_render / world.tick)

      console.log("\u001b[H\u001b[2J")
      // JS/TS does not have native string formatting (i.e. printf),
      // so falling back to string concatenation
      console.log(
        `#${world.tick}` +
        ` - World Tick (L: ${Play.#_f(lowest_tick)}; A: ${Play.#_f(avg_tick)})` +
        ` - Rendering (L: ${Play.#_f(lowest_render)}; A: ${Play.#_f(avg_render)})`
      )
      console.log(rendered)
    }
  }

  static #_f(value: number) {
    // value is in milliseconds, no conversion needed
    return value.toFixed(3)
  }
}

Play.run()
