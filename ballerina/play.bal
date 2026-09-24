import ballerina/io;
import ballerina/os;
import ballerina/time;

const int WORLD_WIDTH = 150;
const int WORLD_HEIGHT = 40;
const string CLEAR_SCREEN = "\u{001b}[?2026h\u{001b}[H\u{001b}[2J";
const string SHOW_SCREEN = "\u{001b}[?2026l";

class Play {
  function run() returns error? {
    World world = check new(
      WORLD_WIDTH,
      WORLD_HEIGHT
    );

    boolean minimal = os:getEnv("MINIMAL") == "1";

    if !minimal {
      io:println(world.render());
    }

    float totalTick = 0.0;
    float lowestTick = float:Infinity;
    float totalRender = 0.0;
    float lowestRender = float:Infinity;

    while true {
      decimal tickStart = time:monotonicNow();
      world.doTick();
      decimal tickFinish = time:monotonicNow();
      decimal tickDiff = tickFinish - tickStart;
      float tickTime = <float>tickDiff * 1000000000.0;
      totalTick += tickTime;
      lowestTick = float:min(lowestTick, tickTime);
      float avgTick = totalTick / <float>world.tick;

      decimal renderStart = time:monotonicNow();
      string rendered = world.render();
      decimal renderFinish = time:monotonicNow();
      decimal renderDiff = renderFinish - renderStart;
      float renderTime = <float>renderDiff * 1000000000.0;
      totalRender += renderTime;
      lowestRender = float:min(lowestRender, renderTime);
      float avgRender = totalRender / <float>world.tick;

      if !minimal {
        io:print(CLEAR_SCREEN);
      }

      io:println(
        string `#${world.tick}` +
        string ` - World Tick (L: ${self._f(lowestTick)}; A: ${self._f(avgTick)})` +
        string ` - Rendering (L: ${self._f(lowestRender)}; A: ${self._f(avgRender)})`
      );

      if !minimal {
        io:println(rendered + SHOW_SCREEN);
      }
    }
  }

  function _f(float value) returns string {
    // nanoseconds -> milliseconds, padded to 3 decimal places
    return (value / 1000000.0).toFixedString(3);
  }
}

public function main() returns error? {
  Play play = new;
  check play.run();
}
