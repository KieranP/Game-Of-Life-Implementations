import 'world.dart';
import 'dart:io';
import 'dart:math';

class Play {
  static const worldWidth = 150;
  static const worldHeight = 40;

  static void run() {
    final world = World(
      worldWidth,
      worldHeight,
    );

    final minimal = Platform.environment["MINIMAL"] != null;

    if (!minimal) {
      print(world.render());
    }

    var totalTick = 0.0;
    var lowestTick = double.infinity;
    var totalRender = 0.0;
    var lowestRender = double.infinity;

    final stopwatch = Stopwatch();
    stopwatch.start();

    while(true) {
      stopwatch.reset();
      world.doTick();
      final tickTime = stopwatch.elapsedMicroseconds.toDouble();
      totalTick += tickTime;
      lowestTick = min(lowestTick, tickTime);
      final avgTick = (totalTick / world.tick);

      stopwatch.reset();
      final rendered = world.render();
      final renderTime = stopwatch.elapsedMicroseconds.toDouble();
      totalRender += renderTime;
      lowestRender = min(lowestRender, renderTime);
      final avgRender = (totalRender / world.tick);

      if (!minimal) {
        stdout.write("\u001b[H\u001b[2J");
      }

      stdout.writeln(
        "#${world.tick}"
        " - World Tick (L: ${_f(lowestTick)}; A: ${_f(avgTick)})"
        " - Rendering (L: ${_f(lowestRender)}; A: ${_f(avgRender)})"
      );

      if (!minimal) {
        stdout.write(rendered);
      }
    }
  }

  static String _f(double value) {
    // microseconds -> milliseconds
    return (value / 1_000).toStringAsFixed(3);
  }
}

void main() {
  Play.run();
}
