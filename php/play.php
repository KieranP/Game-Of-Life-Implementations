<?php

error_reporting(E_ALL);

require_once('game.php');

class Play {

  public static $World_Width = 150;
  public static $World_Height = 40;

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
      $tick_time = round($tick_finish - $tick_start, 5);
      $total_tick += $tick_time;
      $avg_tick = round($total_tick / $world->tick, 5);

      $render_start = microtime(true);
      $rendered = $world->render();
      $render_finish = microtime(true);
      $render_time = round($render_finish - $render_start, 5);
      $total_render += $render_time;
      $avg_render = round($total_render / $world->tick, 5);

      $output = "#$world->tick";
      $output .= " - World tick took $tick_time ($avg_tick)";
      $output .= " - Rendering took $render_time ($avg_render)";
      $output .= "\n".$rendered;
      system('clear');
      echo $output;
    }
  }

}

Play::run();

?>
