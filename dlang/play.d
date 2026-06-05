import std.stdio : write, writeln, writefln;
import std.process : environment;
import std.datetime : MonoTime;
import std.algorithm.comparison : min;
import world;

class Play {
  public:
    enum worldWidth = 150;
    enum worldHeight = 40;

    static void run() {
      auto world = new World(
        width: worldWidth,
        height: worldHeight,
      );

      auto minimal = environment.get("MINIMAL") != null;

      if (!minimal) {
        writeln(world.render());
      }

      auto totalTick = 0.0;
      auto lowestTick = float.infinity;
      auto totalRender = 0.0;
      auto lowestRender = float.infinity;

      while (true) {
        auto tickStart = MonoTime.currTime;
        world.doTick();
        auto tickFinish = MonoTime.currTime;
        auto tickTime = (tickFinish - tickStart).total!"nsecs";
        totalTick += tickTime;
        lowestTick = min(lowestTick, tickTime);
        auto avgTick = totalTick / world.tick;

        auto renderStart = MonoTime.currTime;
        auto rendered = world.render();
        auto renderFinish = MonoTime.currTime;
        auto renderTime = (renderFinish - renderStart).total!"nsecs";
        totalRender += renderTime;
        lowestRender = min(lowestRender, renderTime);
        auto avgRender = totalRender / world.tick;

        if (!minimal) {
          write("\u001b[H\u001b[2J");
        }

        writefln(
          "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)",
          world.tick,
          _f(lowestTick),
          _f(avgTick),
          _f(lowestRender),
          _f(avgRender),
        );

        if (!minimal) {
          write(rendered);
        }
      }
    }

    static float _f(float value) {
      // nanoseconds -> milliseconds
      return value / 1_000_000.0;
    }
}

void main() {
  Play.run();
}
