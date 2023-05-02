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
    let total_render = 0

    while(true) {
      const tick_start = performance.now()
      world._tick()
      const tick_finish = performance.now()
      const tick_time = (tick_finish - tick_start)
      total_tick += tick_time
      const avg_tick = (total_tick / world.tick)

      const render_start = performance.now()
      const rendered = world.render()
      const render_finish = performance.now()
      const render_time = (render_finish - render_start)
      total_render += render_time
      const avg_render = (total_render / world.tick)

      let output = `#${world.tick}`
      output += ` - World tick took ${Play.#_f(tick_time)} (${Play.#_f(avg_tick)})`
      output += ` - Rendering took ${Play.#_f(render_time)} (${Play.#_f(avg_render)})`
      output += `\n${rendered}`
      console.log("\u001b[H\u001b[2J")
      console.log(output)
    }
  }

  static #_f(value: number) {
    // value is in milliseconds, no conversion needed
    return value.toFixed(3)
  }

}

Play.run()
