<?php

error_reporting(E_ALL);

require_once('game.php');

function render($world) {
  $rendering = '';
  $boundaries = $world->boundaries();
  for ($y = $boundaries['y']['min']; $y <= $boundaries['y']['max']; $y++) {
    for ($x = $boundaries['x']['min']; $x <= $boundaries['x']['max']; $x++) {
      $cell = $world->cell_at($x, $y);
      $rendering .= ($cell ? $cell->to_char() : ' ');
    }
    $rendering .= "\n";
  }
  return $rendering;
}

$world = new World();

// Prepopulate the cells
for ($x = 0; $x <= 150; $x++) {
  for ($y = 0; $y <= 40; $y++) {
    $world->add_cell($x, $y, (rand(0, 100) <= 20));
  }
}

// Prepopulate the neighbours
for ($x = 0; $x <= 150; $x++) {
  for ($y = 0; $y <= 40; $y++) {
    $world->neighbours_around($world->cell_at($x, $y));
  }
}

echo render($world);

$total_tick = 0;
$total_render = 0;

while (true) {
  $tick_start = microtime(true);
  $world->tick();
  $tick_finish = microtime(true);
  $tick_time = round($tick_finish - $tick_start, 5);
  $total_tick += $tick_time;
  $avg_tick = round($total_tick / $world->tick, 5);

  $render_start = microtime(true);
  $rendered = render($world);
  $render_finish = microtime(true);
  $render_time = round($render_finish - $render_start, 5);
  $total_render += $render_time;
  $avg_render = round($total_render / $world->tick, 5);

  $output = "#$world->tick";
  $output .= " - World tick took $tick_time ($avg_tick)";
  $output .= " - Rendering took $render_time ($avg_render)";
  $output .= "\n".render($world);
  system('clear');
  echo $output;
}

?>
