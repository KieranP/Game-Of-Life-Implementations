class Play {

  static #World_Width = 150
  static #World_Height = 40

  static run() {
    const world = new World(
      Play.#World_Width,
      Play.#World_Height,
    )

    const body = document.getElementsByTagName('body')[0]
    body.innerHTML = world.render()

    let total_tick = 0
    let total_render = 0

    // Can't use while(true) because it locks the page
    setInterval(() => {
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
      output += `<br />${rendered}`
      body.innerHTML = output
    }, 0)
  }

  static #_f(value) {
    // value is in milliseconds, no conversion needed
    return value.toFixed(3)
  }

}

Play.run()
