<?php

error_reporting(E_ALL);

require_once 'world.php';

final class Play {
  private const int WORLD_WIDTH = 150;
  private const int WORLD_HEIGHT = 40;

  public static function run(): void {
    $world = new World(
      width: self::WORLD_WIDTH,
      height: self::WORLD_HEIGHT,
    );

    $minimal = getenv("MINIMAL") !== false;

    if (!$minimal) {
      echo $world->render();
    }

    $totalTick = 0;
    $lowestTick = INF;
    $totalRender = 0;
    $lowestRender = INF;

    while (true) {
      $tickStart = hrtime(true);
      $world->doTick();
      $tickFinish = hrtime(true);
      $tickTime = $tickFinish - $tickStart;
      $totalTick += $tickTime;
      $lowestTick = min($lowestTick, $tickTime);
      $avgTick = $totalTick / $world->tick;

      $renderStart = hrtime(true);
      $rendered = $world->render();
      $renderFinish = hrtime(true);
      $renderTime = $renderFinish - $renderStart;
      $totalRender += $renderTime;
      $lowestRender = min($lowestRender, $renderTime);
      $avgRender = $totalRender / $world->tick;

      if (!$minimal) {
        echo "\u{001b}[H\u{001b}[2J";
      }

      printf(
        "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)\n",
        $world->tick,
        self::_f($lowestTick),
        self::_f($avgTick),
        self::_f($lowestRender),
        self::_f($avgRender)
      );

      if (!$minimal) {
        echo $rendered;
      }
    }
  }

  private static function _f(int|float $value): float {
    // nanoseconds -> milliseconds
    return $value / 1_000_000;
  }
}

Play::run();
