<?php

error_reporting(E_ALL);

require_once 'world.php';

class Play {
  private static $WORLD_WIDTH = 150;
  private static $WORLD_HEIGHT = 40;

  public static function run() {
    $world = new World(
      width: self::$WORLD_WIDTH,
      height: self::$WORLD_HEIGHT,
    );

    $minimal = getenv("MINIMAL") != null;

    if (!$minimal) {
      echo $world->render();
    }

    $total_tick = 0;
    $lowest_tick = INF;
    $total_render = 0;
    $lowest_render = INF;

    while (true) {
      $tick_start = hrtime(true);
      $world->dotick();
      $tick_finish = hrtime(true);
      $tick_time = $tick_finish - $tick_start;
      $total_tick += $tick_time;
      $lowest_tick = min($lowest_tick, $tick_time);
      $avg_tick = $total_tick / $world->tick;

      $render_start = hrtime(true);
      $rendered = $world->render();
      $render_finish = hrtime(true);
      $render_time = $render_finish - $render_start;
      $total_render += $render_time;
      $lowest_render = min($lowest_render, $render_time);
      $avg_render = $total_render / $world->tick;

      if (!$minimal) {
        echo "\u{001b}[H\u{001b}[2J";
      }

      echo sprintf(
        "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)\n",
        $world->tick,
        self::_f($lowest_tick),
        self::_f($avg_tick),
        self::_f($lowest_render),
        self::_f($avg_render)
      );

      if (!$minimal) {
        echo $rendered;
      }
    }
  }

  private static function _f($value) {
    # nanoseconds -> milliseconds
    return $value / 1_000_000;
  }
}

Play::run();
