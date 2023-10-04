<?php

error_reporting(E_ALL);

require_once('world.php');

class Play {
  private static $World_Width = 150;
  private static $World_Height = 40;

  public static function run() {
    $world = new World(
      self::$World_Width,
      self::$World_Height
    );

    echo $world->render();

    $total_tick = 0;
    $lowest_tick = INF;
    $total_render = 0;
    $lowest_render = INF;

    while (true) {
      $tick_start = hrtime(true);
      $world->_tick();
      $tick_finish = hrtime(true);
      $tick_time = ($tick_finish - $tick_start);
      $total_tick += $tick_time;
      $lowest_tick = min($lowest_tick, $tick_time);
      $avg_tick = ($total_tick / $world->tick);

      $render_start = hrtime(true);
      $rendered = $world->render();
      $render_finish = hrtime(true);
      $render_time = ($render_finish - $render_start);
      $total_render += $render_time;
      $lowest_render = min($lowest_render, $render_time);
      $avg_render = ($total_render / $world->tick);

      echo "\u{001b}[H\u{001b}[2J";
      echo sprintf(
        "#%d - World Tick (L: %.3f; A: %.3f) - Rendering (L: %.3f; A: %.3f)",
        $world->tick,
        self::_f($lowest_tick),
        self::_f($avg_tick),
        self::_f($lowest_render),
        self::_f($avg_render)
      );
      echo $rendered;
    }
  }

  private static function _f($value) {
    # value is in nanoseconds, convert to milliseconds
    return $value / 1_000_000;
  }
}

Play::run();

?>
