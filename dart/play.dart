import 'world.dart';
import 'dart:io';
import 'dart:math';

class Play {
  static const WORLD_WIDTH  = 150;
  static const WORLD_HEIGHT = 40;

  static void run() {
    final world = World(
      WORLD_WIDTH,
      WORLD_HEIGHT,
    );

    var minimal = Platform.environment["MINIMAL"] != null;

    if (!minimal) {
      print(world.render());
    }

    var total_tick = 0.0;
    var lowest_tick = double.infinity;
    var total_render = 0.0;
    var lowest_render = double.infinity;

    final stopwatch = Stopwatch();
    stopwatch.start();

    while(true) {
      stopwatch.reset();
      world.tick_();
      final tick_time = stopwatch.elapsedMicroseconds / 1.0;
      total_tick += tick_time;
      lowest_tick = [lowest_tick, tick_time].reduce(min);
      final avg_tick = (total_tick / world.tick);

      stopwatch.reset();
      final rendered = world.render();
      final render_time = stopwatch.elapsedMicroseconds / 1.0;
      total_render += render_time;
      lowest_render = [lowest_render, render_time].reduce(min);
      final avg_render = (total_render / world.tick);

      if (!minimal) {
        stdout.write("\u001b[H\u001b[2J");
      }
      // Dart does not have native string formatting (i.e. printf),
      // so falling back to string concatenation
      stdout.writeln(
        "#${world.tick}" +
        " - World Tick (L: ${_f(lowest_tick)}; A: ${_f(avg_tick)})" +
        " - Rendering (L: ${_f(lowest_render)}, A: ${_f(avg_render)})"
      );
      if (!minimal) {
        stdout.write(rendered);
      }
    }
  }

  static String _f(double value) {
    // value is in microseconds, convert to milliseconds
    return (value / 1_000).toStringAsFixed(3);
  }
}

main() {
  Play.run();
}
