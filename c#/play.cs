using System;
// using System.Linq;
using System.Diagnostics;

public class Play {
  private const uint WorldWidth = 150;
  private const uint WorldHeight = 40;

  public static void Main(string[] args) {
    Run();
  }

  public static void Run() {
    var world = new World(
      width: WorldWidth,
      height: WorldHeight
    );

    var minimal = Environment.GetEnvironmentVariable("MINIMAL") is not null;

    if (!minimal) {
      Console.WriteLine(world.Render());
    }

    var totalTick = 0.0;
    var lowestTick = double.MaxValue;
    var totalRender = 0.0;
    var lowestRender = double.MaxValue;

    while (true) {
      var tickStart = Stopwatch.GetTimestamp();
      world.DoTick();
      var tickFinish = Stopwatch.GetTimestamp();
      var tickTime = Stopwatch.GetElapsedTime(tickStart, tickFinish).TotalNanoseconds;
      totalTick += tickTime;
      lowestTick = Math.Min(lowestTick, tickTime);
      var avgTick = (totalTick / world.Tick);

      var renderStart = Stopwatch.GetTimestamp();
      var rendered = world.Render();
      var renderFinish = Stopwatch.GetTimestamp();
      var renderTime = Stopwatch.GetElapsedTime(renderStart, renderFinish).TotalNanoseconds;
      totalRender += renderTime;
      lowestRender = Math.Min(lowestRender, renderTime);
      var avgRender = (totalRender / world.Tick);

      if (!minimal) {
        Console.Write("\u001b[H\u001b[2J");
      }

      Console.WriteLine(
        $"#{world.Tick}" +
        $" - World Tick (L: {_f(lowestTick):f3}; A: {_f(avgTick):f3})" +
        $" - Rendering (L: {_f(lowestRender):f3}; A: {_f(avgRender):f3})"
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
