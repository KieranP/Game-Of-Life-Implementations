// Files must be named the same as the class they contain
// Files can have multiple classes, but only one public class

public class Play {

  private static int World_Width  = 150;
  private static int World_Height = 40;

  public static void main(String[] args) {
    run();
  }

  public static void run() {
    World world = new World(
      World_Width,
      World_Height
    );

    System.out.println(world.render());

    double total_tick = 0.0;
    double total_render = 0.0;

    while (true) {
      double tick_start = System.currentTimeMillis();
      world._tick();
      double tick_finish = System.currentTimeMillis();
      double tick_time = (tick_finish - tick_start) / 1000d;
      total_tick += tick_time;
      double avg_tick = (total_tick / world.tick);

      double render_start = System.currentTimeMillis();
      String rendered = world.render();
      double render_finish = System.currentTimeMillis();
      double render_time = (render_finish - render_start) / 1000d;
      total_render += render_time;
      double avg_render = (total_render / world.tick);

      String output = "#"+world.tick;
      output += " - World tick took "+_f(tick_time)+" ("+_f(avg_tick)+")";
      output += " - Rendering took "+_f(render_time)+" ("+_f(avg_render)+")";
      output += "\n"+rendered;
      System.out.print("\033[H\033[2J");
      System.out.println(output);
    }
  }

  private static String _f(double value) {
    return String.format("%.5f", value);
  }

}
