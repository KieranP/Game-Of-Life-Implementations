public class Play {
  companion object {
    private const val WORLD_WIDTH: Int = 150
    private const val WORLD_HEIGHT: Int = 40

    public fun run() {
      val world = World(
        width = WORLD_WIDTH,
        height = WORLD_HEIGHT,
      )

      val minimal = System.getenv("MINIMAL") != null

      if (!minimal) {
        println(world.render())
      }

      var totalTick = 0.0
      var lowestTick = Double.MAX_VALUE
      var totalRender = 0.0
      var lowestRender = Double.MAX_VALUE

      while (true) {
        val tickStart = System.nanoTime()
        world.doTick()
        val tickFinish = System.nanoTime()
        val tickTime = (tickFinish - tickStart).toDouble()
        totalTick += tickTime
        lowestTick = minOf(lowestTick, tickTime)
        val avgTick = (totalTick / world.tick)

        val renderStart = System.nanoTime()
        val rendered = world.render()
        val renderFinish = System.nanoTime()
        val renderTime = (renderFinish - renderStart).toDouble()
        totalRender += renderTime
        lowestRender = minOf(lowestRender, renderTime)
        val avgRender = (totalRender / world.tick)

        if (!minimal) {
          print("\u001b[H\u001b[2J")
        }

        println(
          String.format(
            "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)",
            world.tick,
            _f(lowestTick),
            _f(avgTick),
            _f(lowestRender),
            _f(avgRender)
          )
        )

        if (!minimal) {
          print(rendered)
        }
      }
    }

    private fun _f(value: Double): Double {
      // nanoseconds -> milliseconds
      return value / 1_000_000
    }
  }
}

fun main() {
  Play.run()
}
