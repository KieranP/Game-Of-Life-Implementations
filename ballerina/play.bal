import ballerina/io;
import ballerina/os;
import ballerina/time;

const int WORLD_WIDTH = 150;
const int WORLD_HEIGHT = 40;

class Play {
  function run() returns error? {
    World world = check new(
      WORLD_WIDTH,
      WORLD_HEIGHT
    );

    boolean minimal = os:getEnv("MINIMAL") != "";

    if !minimal {
      io:print(world.render());
    }

    float total_tick = 0.0;
    float lowest_tick = float:Infinity;
    float total_render = 0.0;
    float lowest_render = float:Infinity;

    while true {
      decimal tick_start = time:monotonicNow();
      world.dotick();
      decimal tick_finish = time:monotonicNow();
      decimal tick_diff = tick_finish - tick_start;
      float tick_time = <float>tick_diff * 1000000000.0;
      total_tick += tick_time;
      lowest_tick = float:min(lowest_tick, tick_time);
      float avg_tick = total_tick / <float>world.tick;

      decimal render_start = time:monotonicNow();
      string rendered = world.render();
      decimal render_finish = time:monotonicNow();
      decimal render_diff = render_finish - render_start;
      float render_time = <float>render_diff * 1000000000.0;
      total_render += render_time;
      lowest_render = float:min(lowest_render, render_time);
      float avg_render = total_render / <float>world.tick;

      if !minimal {
        io:print("\u{001b}[H\u{001b}[2J");
      }

      io:println(
        string `#${world.tick}` +
        string ` - World Tick (L: ${self._f(lowest_tick)}; A: ${self._f(avg_tick)})` +
        string ` - Rendering (L: ${self._f(lowest_render)}; A: ${self._f(avg_render)})`
      );

      if !minimal {
        io:print(rendered);
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
