class Play {
  private static final int WORLD_WIDTH = 150
  private static final int WORLD_HEIGHT = 40
  private static final String CLEAR_SCREEN = "\u001b[?2026h\u001b[H\u001b[2J"
  private static final String SHOW_SCREEN = "\u001b[?2026l"

  public static void main(String[] args) {
    run()
  }

  public static void run() {
    var world = new World(
      WORLD_WIDTH,
      WORLD_HEIGHT,
    )

    var minimal = System.getenv("MINIMAL") == "1"

    if (!minimal) {
      println(world.render())
    }

    var totalTick = 0.0
    var lowestTick = Double.MAX_VALUE
    var totalRender = 0.0
    var lowestRender = Double.MAX_VALUE

    while (true) {
      var tickStart = System.nanoTime()
      world.doTick()
      var tickFinish = System.nanoTime()
      var tickTime = (tickFinish - tickStart) as double
      totalTick += tickTime
      lowestTick = Math.min(lowestTick, tickTime)
      var avgTick = (totalTick / world.tick) as double

      var renderStart = System.nanoTime()
      var rendered = world.render()
      var renderFinish = System.nanoTime()
      var renderTime = (renderFinish - renderStart) as double
      totalRender += renderTime
      lowestRender = Math.min(lowestRender, renderTime)
      var avgRender = (totalRender / world.tick) as double

      if (!minimal) {
        print(CLEAR_SCREEN)
      }

      printf(
        "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)%n",
        world.tick,
        _f(lowestTick),
        _f(avgTick),
        _f(lowestRender),
        _f(avgRender)
      )

      if (!minimal) {
        println(rendered + SHOW_SCREEN)
      }
    }
  }

  private static double _f(double value) {
    // nanoseconds -> milliseconds
    value / 1000000
  }
}
