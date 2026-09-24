import 'world.dart';
import 'dart:io';
import 'dart:math';

class Play {
  static const _worldWidth = 150;
  static const _worldHeight = 40;
  static const _clearScreen = "\x1b[?2026h\x1b[H\x1b[2J";
  static const _showScreen = "\x1b[?2026l";

  static void run() {
    final world = World(
      _worldWidth,
      _worldHeight,
    );

    final minimal = Platform.environment["MINIMAL"] == "1";

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
      final tickStart = stopwatch.elapsedMicroseconds;
      world.doTick();
      final tickFinish = stopwatch.elapsedMicroseconds;
      final tickTime = (tickFinish - tickStart).toDouble();
      totalTick += tickTime;
      lowestTick = min(lowestTick, tickTime);
      final avgTick = (totalTick / world.tick);

      final renderStart = stopwatch.elapsedMicroseconds;
      final rendered = world.render();
      final renderFinish = stopwatch.elapsedMicroseconds;
      final renderTime = (renderFinish - renderStart).toDouble();
      totalRender += renderTime;
      lowestRender = min(lowestRender, renderTime);
      final avgRender = (totalRender / world.tick);

      if (!minimal) {
        stdout.write(_clearScreen);
      }

      stdout.writeln(
        "#${world.tick}"
        " - World Tick (L: ${_f(lowestTick)}; A: ${_f(avgTick)})"
        " - Rendering (L: ${_f(lowestRender)}; A: ${_f(avgRender)})"
      );

      if (!minimal) {
        stdout.writeln(rendered + _showScreen);
      }
    }
  }

  static String _f(double value) {
    // microseconds -> milliseconds, padded to 3 decimal places
    return (value / 1_000).toStringAsFixed(3);
  }
}

void main() {
  Play.run();
}
