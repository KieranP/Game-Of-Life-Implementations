using System;
using System.Linq;
using System.Diagnostics;

public class Play {
  private static readonly int World_Width  = 150;
  private static readonly int World_Height = 40;

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
    var lowest_tick = double.MaxValue;
    var total_render = 0.0;
    var lowest_render = double.MaxValue;

    while (true) {
      var tick_start = Stopwatch.GetTimestamp();
      world._tick();
      var tick_finish = Stopwatch.GetTimestamp();
      var tick_time = Stopwatch.GetElapsedTime(tick_start, tick_finish).TotalNanoseconds;
      total_tick += tick_time;
      lowest_tick = new double[]{ lowest_tick, tick_time }.Min();
      var avg_tick = (total_tick / world.tick);

      var render_start = Stopwatch.GetTimestamp();
      var rendered = world.render();
      var render_finish = Stopwatch.GetTimestamp();
      var render_time = Stopwatch.GetElapsedTime(render_start, render_finish).TotalNanoseconds;
      total_render += render_time;
      lowest_render = new double[]{ lowest_render, render_time }.Min();
      var avg_render = (total_render / world.tick);

      Console.Write("\u001b[H\u001b[2J");
      Console.WriteLine(
        "#{0} - World Tick (L: {1:f3}; A: {2:f3}) - Rendering (L: {3:f3}; A: {4:f3})",
        world.tick,
        _f(lowest_tick),
        _f(avg_tick),
        _f(lowest_render),
        _f(avg_render)
      );
      Console.WriteLine(rendered);
    }
  }

  private static double _f(double value) {
    // value is in nanoseconds, convert to milliseconds
    return value / 1_000_000;
  }
}
