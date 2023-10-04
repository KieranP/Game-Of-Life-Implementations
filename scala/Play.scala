// Files must be named the same as the class/object they contain

object Play {
  private val World_Width  = 150
  private val World_Height = 40

  def main(args: Array[String]) = {
    val world = new World(
      width = World_Width,
      height = World_Height,
    )

    println(world.render)

    var total_tick = 0.0
    var lowest_tick = Double.MaxValue
    var total_render = 0.0
    var lowest_render = Double.MaxValue

    while (true) {
      val tick_start = System.nanoTime()
      world._tick
      val tick_finish = System.nanoTime()
      val tick_time = (tick_finish - tick_start) / 1.0
      total_tick += tick_time
      lowest_tick = Math.min(lowest_tick, tick_time)
      val avg_tick = (total_tick / world.tick)

      val render_start = System.nanoTime()
      val rendered = world.render
      val render_finish = System.nanoTime()
      val render_time = (render_finish - render_start) / 1.0
      total_render += render_time
      lowest_render = Math.min(lowest_render, render_time)
      val avg_render = (total_render / world.tick)

      print("\u001b[H\u001b[2J")
      println(
        "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)".format(
          world.tick,
          _f(lowest_tick),
          _f(avg_tick),
          _f(lowest_render),
          _f(avg_render)
        )
      )
      print(rendered)
    }
  }

  private def _f(value: Double) = {
    // value is in nanoseconds, convert to milliseconds
    value / 1_000_000
  }
}
