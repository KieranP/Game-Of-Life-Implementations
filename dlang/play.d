import std.stdio : writeln, printf;
import std.datetime : MonoTime;
import world;

class Play {
  public:
    static const auto World_Width = 150;
    static const auto World_Height = 40;

    static void run() {
      auto world = new World(
        World_Width,
        World_Height
      );

      writeln(world.render());

      auto total_tick = 0.0;
      auto total_render = 0.0;

      while (true) {
        auto tick_start = MonoTime.currTime;
        world._tick();
        auto tick_finish = MonoTime.currTime;
        auto tick_time = (tick_finish - tick_start).total!"usecs";
        total_tick += tick_time;
        auto avg_tick = total_tick / world.tick;

        auto render_start = MonoTime.currTime;
        auto rendered = world.render();
        auto render_finish = MonoTime.currTime;
        auto render_time = (render_finish - render_start).total!"usecs";
        total_render += render_time;
        auto avg_render = total_render / world.tick;

        writeln("\u001b[H\u001b[2J");
        printf(
          "#%d - World tick took %.3f (%.3f) - Rendering took %.3f (%.3f)\n",
          world.tick,
          tick_time / 1000.0,
          avg_tick / 1000.0,
          render_time / 1000.0,
          avg_render / 1000.0,
        );
        writeln(rendered);
      }
    }
}

void main() {
  Play.run();
}
