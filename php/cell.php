<?php

error_reporting(E_ALL);

class Cell {
  public $x, $y, $alive, $next_state, $neighbours;

  public function __construct($x, $y, $alive = false) {
    $this->x = $x;
    $this->y = $y;
    $this->alive = $alive;
    $this->next_state = null;
    $this->neighbours = [];
  }

  public function to_char() {
    return $this->alive ? 'o' : ' ';
  }

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Use whatever implementation runs the fastest
  public function alive_neighbours() {
    // The following works but is slower
    // return count(array_filter($this->neighbours, function($n) { return $n->alive; }));

    // The following was the fastest method
    $alive_neighbours = 0;
    foreach ($this->neighbours as $neighbour) {
      if ($neighbour->alive) {
        $alive_neighbours++;
      }
    }
    return $alive_neighbours;

    // The following works but is slower
    // $alive_neighbours = 0;
    // for ($i = 0; $i < count($this->neighbours); $i++) {
    //   $neighbour = $this->neighbours[$i];
    //   if ($neighbour->alive) {
    //     $alive_neighbours++;
    //   }
    // }
    // return $alive_neighbours;
  }
}
