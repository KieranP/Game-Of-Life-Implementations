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
    $total_render = 0;

    while (true) {
      $tick_start = microtime(true);
      $world->_tick();
      $tick_finish = microtime(true);
      $tick_time = ($tick_finish - $tick_start) * 1000;
      $total_tick += $tick_time;
      $avg_tick = ($total_tick / $world->tick);

      $render_start = microtime(true);
      $rendered = $world->render();
      $render_finish = microtime(true);
      $render_time = ($render_finish - $render_start) * 1000;
      $total_render += $render_time;
      $avg_render = ($total_render / $world->tick);

      $output = "#$world->tick";
      $output .= " - World tick took ".self::_f($tick_time)." (".self::_f($avg_tick).")";
      $output .= " - Rendering took ".self::_f($render_time)." (".self::_f($avg_render).")";
      $output .= "\n".$rendered;
      system('clear');
      echo $output;
    }
  }

  private static function _f($value) {
    return sprintf("%.3f", $value);
  }

}

Play::run();

?>
