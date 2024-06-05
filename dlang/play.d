import std.stdio : write, writeln, writefln;
import std.process : environment;
import std.datetime : MonoTime;
import std.algorithm.comparison : min;
import world;

class Play {
  public:
    static const auto World_Width = 150;
    static const auto World_Height = 40;

    static void run() {
      auto world = new World(
        width: World_Width,
        height: World_Height,
      );

      auto minimal = environment.get("MINIMAL") != null;

      if (!minimal) {
        writeln(world.render());
      }

      auto total_tick = 0.0;
      auto lowest_tick = float.infinity;
      auto total_render = 0.0;
      auto lowest_render = float.infinity;

      while (true) {
        auto tick_start = MonoTime.currTime;
        world._tick();
        auto tick_finish = MonoTime.currTime;
        auto tick_time = (tick_finish - tick_start).total!"nsecs";
        total_tick += tick_time;
        lowest_tick = min(lowest_tick, tick_time);
        auto avg_tick = total_tick / world.tick;

        auto render_start = MonoTime.currTime;
        auto rendered = world.render();
        auto render_finish = MonoTime.currTime;
        auto render_time = (render_finish - render_start).total!"nsecs";
        total_render += render_time;
        lowest_render = min(lowest_render, render_time);
        auto avg_render = total_render / world.tick;

        if (!minimal) {
          write("\u001b[H\u001b[2J");
        }
        writefln(
          "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)",
          world.tick,
          _f(lowest_tick),
          _f(avg_tick),
          _f(lowest_render),
          _f(avg_render),
        );
        if (!minimal) {
          write(rendered);
        }
      }
    }

    static float _f(float value) {
      // value is in nanoseconds, convert to milliseconds
      return value / 1_000_000.0;
    }
}

void main() {
  Play.run();
}
