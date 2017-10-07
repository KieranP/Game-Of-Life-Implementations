using System;

public class Play {

  private static int World_Width  = 150;
  private static int World_Height = 40;

  public static void Main(string[] args) {
    run();
  }

  public static void run() {
    World world = new World(
      width: World_Width,
      height: World_Height
    );

    Console.WriteLine(world.render());

    double total_tick = 0.0;
    double total_render = 0.0;

    while (true) {
      DateTime tick_start = DateTime.Now;
      world._tick();
      DateTime tick_finish = DateTime.Now;
      double tick_time = (tick_finish - tick_start).TotalMilliseconds / 1000;
      total_tick += tick_time;
      double avg_tick = (total_tick / world.tick);

      DateTime render_start = DateTime.Now;
      string rendered = world.render();
      DateTime render_finish = DateTime.Now;
      double render_time = (render_finish - render_start).TotalMilliseconds / 1000;
      total_render += render_time;
      double avg_render = (total_render / world.tick);

      string output = $"#{world.tick}";
      output += $" - World tick took {_f(tick_time)} ({_f(avg_tick)})";
      output += $" - Rendering took {_f(render_time)} ({_f(avg_render)})";
      output += $"\n{rendered}";
      Console.Write("\u001b[H\u001b[2J");
      Console.WriteLine(output);
    }

  }

  private static string _f(double value) {
    return value.ToString("0.#####");
  }

}
