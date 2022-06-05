// In Dart, anything preceeded by an underscore (_) is a private function/variable

import 'world.dart';
import 'dart:io';

class Play {

  static const World_Width  = 150;
  static const World_Height = 40;

  static void run() {
    final world = World(
      World_Width,
      World_Height,
    );

    print(world.render());

    var total_tick = 0.0;
    var total_render = 0.0;

    while(true) {
      final tick_start = DateTime.now().microsecondsSinceEpoch;
      world.tick_();
      final tick_finish = DateTime.now().microsecondsSinceEpoch;
      final tick_time = (tick_finish - tick_start) / 1.0;
      total_tick += tick_time;
      final avg_tick = (total_tick / world.tick);

      final render_start = DateTime.now().microsecondsSinceEpoch;
      final rendered = world.render();
      final render_finish = DateTime.now().microsecondsSinceEpoch;
      final render_time = (render_finish - render_start) / 1.0;
      total_render += render_time;
      final avg_render = (total_render / world.tick);

      var output = "#${world.tick}";
      output += " - World tick took ${_f(tick_time / 1000)} (${_f(avg_tick / 1000)})";
      output += " - Rendering took ${_f(render_time / 1000)} (${_f(avg_render / 1000)})";
      output += "\n${rendered}";
      stdout.write("\u001b[H\u001b[2J");
      stdout.write(output);
    }
  }

  static String _f(double value) {
    return value.toStringAsFixed(3);
  }

}

main() {
  Play.run();
}
