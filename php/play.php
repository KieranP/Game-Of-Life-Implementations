<?php

error_reporting(E_ALL);

require_once('game.php');

$World_Width = 150;
$World_Height = 40;

function render($world) {
  global $World_Width, $World_Height;

  $rendering = '';
  for ($y = 0; $y <= $World_Height; $y++) {
    for ($x = 0; $x <= $World_Width; $x++) {
      $cell = $world->cell_at($x, $y);
      $rendering .= $cell->to_char();
    }
    $rendering .= "\n";
  }
  return $rendering;
}

$world = new World();

// Prepopulate the cells
for ($y = 0; $y <= $World_Height; $y++) {
  for ($x = 0; $x <= $World_Width; $x++) {
    $alive = (rand(0, 100) <= 20);
    $world->add_cell($x, $y, $alive);
  }
}

// Prepopulate the neighbours
for ($y = 0; $y <= $World_Height; $y++) {
  for ($x = 0; $x <= $World_Width; $x++) {
    $cell = $world->cell_at($x, $y);
    $world->neighbours_around($cell);
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
