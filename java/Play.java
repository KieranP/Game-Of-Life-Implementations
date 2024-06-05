// Files must be named the same as the class they contain
// Files can have multiple classes, but only one public class

public class Play {
  private static int World_Width  = 150;
  private static int World_Height = 40;

  public static void main(String[] args) {
    run();
  }

  public static void run() {
    var world = new World(
      World_Width,
      World_Height
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
      var tick_time = (tick_finish - tick_start) / 1d;
      total_tick += tick_time;
      lowest_tick = Math.min(lowest_tick, tick_time);
      var avg_tick = (total_tick / world.tick);

      var render_start = System.nanoTime();
      var rendered = world.render();
      var render_finish = System.nanoTime();
      var render_time = (render_finish - render_start) / 1d;
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
    // value is in nanoseconds, convert to milliseconds
    return value / 1_000_000;
  }
}
