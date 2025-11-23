public class Play {
  private static int WORLD_WIDTH = 150;
  private static int WORLD_HEIGHT = 40;

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

    var total_tick = 0.0;
    var lowest_tick = Double.MAX_VALUE;
    var total_render = 0.0;
    var lowest_render = Double.MAX_VALUE;

    while (true) {
      var tick_start = System.nanoTime();
      world._tick();
      var tick_finish = System.nanoTime();
      var tick_time = (tick_finish - tick_start);
      total_tick += tick_time;
      lowest_tick = Math.min(lowest_tick, tick_time);
      var avg_tick = (total_tick / world.tick);

      var render_start = System.nanoTime();
      var rendered = world.render();
      var render_finish = System.nanoTime();
      var render_time = (render_finish - render_start);
      total_render += render_time;
      lowest_render = Math.min(lowest_render, render_time);
      var avg_render = (total_render / world.tick);

      if (!minimal) {
        System.out.print("\u001b[H\u001b[2J");
      }

      System.out.println(
        String.format(
          "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)",
          world.tick,
          _f(lowest_tick),
          _f(avg_tick),
          _f(lowest_render),
          _f(avg_render)
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
