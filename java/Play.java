public class Play {
  private static final int WORLD_WIDTH = 150;
  private static final int WORLD_HEIGHT = 40;

  public static void main(String[] args) throws Exception {
    run();
  }

  public static void run() throws Exception {
    var world = new World(
      WORLD_WIDTH,
      WORLD_HEIGHT
    );

    var minimal = System.getenv("MINIMAL") != null;

    if (!minimal) {
      System.out.println(world.render());
    }

    var totalTick = 0.0;
    var lowestTick = Double.MAX_VALUE;
    var totalRender = 0.0;
    var lowestRender = Double.MAX_VALUE;

    while (true) {
      var tickStart = System.nanoTime();
      world.doTick();
      var tickFinish = System.nanoTime();
      var tickTime = (tickFinish - tickStart);
      totalTick += tickTime;
      lowestTick = Math.min(lowestTick, tickTime);
      var avgTick = (totalTick / world.tick);

      var renderStart = System.nanoTime();
      var rendered = world.render();
      var renderFinish = System.nanoTime();
      var renderTime = (renderFinish - renderStart);
      totalRender += renderTime;
      lowestRender = Math.min(lowestRender, renderTime);
      var avgRender = (totalRender / world.tick);

      if (!minimal) {
        System.out.print("\u001b[H\u001b[2J");
      }

      System.out.println(
        "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)".formatted(
          world.tick,
          _f(lowestTick),
          _f(avgTick),
          _f(lowestRender),
          _f(avgRender)
        )
      );

      if (!minimal) {
        System.out.print(rendered);
      }
    }
  }

  private static double _f(double value) {
    // nanoseconds -> milliseconds
    return value / 1_000_000;
  }
}
