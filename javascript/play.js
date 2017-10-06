class Play {

  static run() {
    const world = new World(
      Play.World_Width,
      Play.World_Height,
    )

    const body = document.getElementsByTagName('body')[0]
    body.innerHTML = world.render()

    let total_tick = 0
    let total_render = 0

    // Can't use while(true) because it locks the page
    setInterval(() => {
      const tick_start = new Date()
      world._tick()
      const tick_finish = new Date()
      const tick_time = (tick_finish - tick_start) / 1000
      total_tick += tick_time
      const avg_tick = (total_tick / world.tick)

      const render_start = new Date()
      const rendered = world.render()
      const render_finish = new Date()
      const render_time = (render_finish - render_start) / 1000
      total_render += render_time
      const avg_render = (total_render / world.tick)

      let output = `#${world.tick}`
      output += ` - World tick took ${Play._f(tick_time)} (${Play._f(avg_tick)})`
      output += ` - Rendering took ${Play._f(render_time)} (${Play._f(avg_render)})`
      output += `<br />${rendered}`
      body.innerHTML = output
    }, 0)
  }

  static _f(value) {
    return value.toFixed(5)
  }

}

Play.World_Width  = 150
Play.World_Height = 40

Play.run()
