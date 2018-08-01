import {World} from './world'

class Play {

  private static World_Width: number = 150;
  private static World_Height: number = 40;

  public static run(): void {
    const world = new World(
      Play.World_Width,
      Play.World_Height,
    )

    console.log(world.render())

    let total_tick: number = 0
    let total_render: number = 0

    while(true) {
      const tick_start: number = new Date().valueOf()
      world._tick()
      const tick_finish: number = new Date().valueOf()
      const tick_time = (tick_finish - tick_start) / 1000
      total_tick += tick_time
      const avg_tick = (total_tick / world.tick)

      const render_start: number = new Date().valueOf()
      const rendered = world.render()
      const render_finish: number = new Date().valueOf()
      const render_time = (render_finish - render_start) / 1000
      total_render += render_time
      const avg_render = (total_render / world.tick)

      let output = `#${world.tick}`
      output += ` - World tick took ${Play._f(tick_time)} (${Play._f(avg_tick)})`
      output += ` - Rendering took ${Play._f(render_time)} (${Play._f(avg_render)})`
      output += `\n${rendered}`
      console.log("\u001b[H\u001b[2J")
      console.log(output)
    }
  }

  private static _f(value: number): string {
    return value.toFixed(5)
  }

}

Play.run()
