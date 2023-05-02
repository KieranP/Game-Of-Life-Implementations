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

    System.out.println(world.render());

    var total_tick = 0.0;
    var total_render = 0.0;

    while (true) {
      var tick_start = System.nanoTime();
      world._tick();
      var tick_finish = System.nanoTime();
      var tick_time = (tick_finish - tick_start) / 1d;
      total_tick += tick_time;
      var avg_tick = (total_tick / world.tick);

      var render_start = System.nanoTime();
      var rendered = world.render();
      var render_finish = System.nanoTime();
      var render_time = (render_finish - render_start) / 1d;
      total_render += render_time;
      var avg_render = (total_render / world.tick);

      var output = "#"+world.tick;
      output += " - World tick took "+_f(tick_time)+" ("+_f(avg_tick)+")";
      output += " - Rendering took "+_f(render_time)+" ("+_f(avg_render)+")";
      output += "\n"+rendered;
      System.out.print("\u001b[H\u001b[2J");
      System.out.println(output);
    }
  }

  private static String _f(double value) {
    // value is in nanoseconds, convert to milliseconds
    return String.format("%.3f", value / 1000000);
  }

}
