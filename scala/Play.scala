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
    var total_render = 0.0

    while (true) {
      val tick_start = System.nanoTime()
      world._tick
      val tick_finish = System.nanoTime()
      val tick_time = (tick_finish - tick_start) / 1.0
      total_tick += tick_time
      val avg_tick = (total_tick / world.tick)

      val render_start = System.nanoTime()
      val rendered = world.render
      val render_finish = System.nanoTime()
      val render_time = (render_finish - render_start) / 1.0
      total_render += render_time
      val avg_render = (total_render / world.tick)

      var output = "#"+world.tick
      output += " - World tick took "+_f(tick_time)+" ("+_f(avg_tick)+")"
      output += " - Rendering took "+_f(render_time)+" ("+_f(avg_render)+")"
      output += "\n"+rendered
      print("\u001b[H\u001b[2J")
      println(output)
    }
  }

  private def _f(value: Double) = {
    // value is in nanoseconds, convert to milliseconds
    "%.3f".format(value / 1000000)
  }

}
