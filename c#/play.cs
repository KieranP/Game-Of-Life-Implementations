using System;
// using System.Linq;
using System.Diagnostics;

public class Play {
  private const uint WORLD_WIDTH = 150;
  private const uint WORLD_HEIGHT = 40;

  public static void Main(string[] args) {
    run();
  }

  public static void run() {
    var world = new World(
      width: WORLD_WIDTH,
      height: WORLD_HEIGHT
    );

    var minimal = Environment.GetEnvironmentVariable("MINIMAL") is not null;

    if (!minimal) {
      Console.WriteLine(world.render());
    }

    var total_tick = 0.0;
    var lowest_tick = double.MaxValue;
    var total_render = 0.0;
    var lowest_render = double.MaxValue;

    while (true) {
      var tick_start = Stopwatch.GetTimestamp();
      world.dotick();
      var tick_finish = Stopwatch.GetTimestamp();
      var tick_time = Stopwatch.GetElapsedTime(tick_start, tick_finish).TotalNanoseconds;
      total_tick += tick_time;
      lowest_tick = Math.Min(lowest_tick, tick_time);
      var avg_tick = (total_tick / world.tick);

      var render_start = Stopwatch.GetTimestamp();
      var rendered = world.render();
      var render_finish = Stopwatch.GetTimestamp();
      var render_time = Stopwatch.GetElapsedTime(render_start, render_finish).TotalNanoseconds;
      total_render += render_time;
      lowest_render = Math.Min(lowest_render, render_time);
      var avg_render = (total_render / world.tick);

      if (!minimal) {
        Console.Write("\u001b[H\u001b[2J");
      }

      Console.WriteLine(
        $"#{world.tick}" +
        $" - World Tick (L: {_f(lowest_tick):f3}; A: {_f(avg_tick):f3})" +
        $" - Rendering (L: {_f(lowest_render):f3}; A: {_f(avg_render):f3})"
      );

      if (!minimal) {
        Console.WriteLine(rendered);
      }
    }
  }

  private static double _f(double value) {
    // nanoseconds -> milliseconds
    return value / 1_000_000;
  }
}
