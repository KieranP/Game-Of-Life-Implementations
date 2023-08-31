using System;

public class Play {
  private static int World_Width  = 150;
  private static int World_Height = 40;

  public static void Main(string[] args) {
    run();
  }

  public static void run() {
    var world = new World(
      width: World_Width,
      height: World_Height
    );

    Console.WriteLine(world.render());

    var total_tick = 0.0;
    var total_render = 0.0;

    while (true) {
      var tick_start = DateTime.Now;
      world._tick();
      var tick_finish = DateTime.Now;
      var tick_time = (tick_finish - tick_start).TotalNanoseconds;
      total_tick += tick_time;
      var avg_tick = (total_tick / world.tick);

      var render_start = DateTime.Now;
      var rendered = world.render();
      var render_finish = DateTime.Now;
      var render_time = (render_finish - render_start).TotalNanoseconds;
      total_render += render_time;
      var avg_render = (total_render / world.tick);

      var output = $"#{world.tick}";
      output += $" - World tick took {_f(tick_time)} ({_f(avg_tick)})";
      output += $" - Rendering took {_f(render_time)} ({_f(avg_render)})";
      output += $"\n{rendered}";
      Console.Write("\u001b[H\u001b[2J");
      Console.WriteLine(output);
    }
  }

  private static string _f(double value) {
    // value is in milliseconds, no conversion needed
    return (value / 1_000_000.0).ToString("0.###");
  }
}
