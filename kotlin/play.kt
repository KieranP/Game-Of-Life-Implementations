public class Play {
  companion object {
    private const val WORLD_WIDTH: Int  = 150
    private const val WORLD_HEIGHT: Int = 40

    public fun run() {
      val world = World(
        width = WORLD_WIDTH,
        height = WORLD_HEIGHT,
      )

      var minimal = System.getenv("MINIMAL") != null;

      if (!minimal) {
        println(world.render())
      }

      var total_tick = 0.0
      var lowest_tick = Double.MAX_VALUE
      var total_render = 0.0
      var lowest_render = Double.MAX_VALUE

      while (true) {
        val tick_start = System.nanoTime()
        world._tick()
        val tick_finish = System.nanoTime()
        val tick_time = (tick_finish - tick_start) / 1.0
        total_tick += tick_time
        lowest_tick = Math.min(lowest_tick, tick_time)
        val avg_tick = (total_tick / world.tick)

        val render_start = System.nanoTime()
        val rendered = world.render()
        val render_finish = System.nanoTime()
        val render_time = (render_finish - render_start) / 1.0
        total_render += render_time
        lowest_render = Math.min(lowest_render, render_time)
        val avg_render = (total_render / world.tick)

        if (!minimal) {
          print("\u001b[H\u001b[2J")
        }
        println(
          String.format(
            "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)",
            world.tick,
            _f(lowest_tick),
            _f(avg_tick),
            _f(lowest_render),
            _f(avg_render)
          )
        )
        if (!minimal) {
          print(rendered)
        }
      }
    }

    private fun _f(value: Double): Double {
      // value is in nanoseconds, convert to milliseconds
      return value / 1_000_000
    }
  }
}

fun main() {
  Play.run()
}
