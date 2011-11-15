<?php

class LocationOccupied extends Exception { }

class World {

  var $tick, $cells, $neighbours;

  function __construct() {
    $this->reset();
  }

  function add_cell($x, $y, $dead = false) {
    if ($this->cell_at($x, $y)) {
      throw new LocationOccupied;
    }
    $this->neighbours = array(); // so it recomputes
    $this->boundaries = null;
    return $this->cells["$x-$y"] = new Cell($x, $y, $dead);
  }

  function cell_at($x, $y) {
    return $this->cells["$x-$y"];
  }

  function neighbours_at($x, $y) {
    if (!$this->neighbours["$x-$y"]) {
      $directions = array(
        array(-1, 1), array(0, 1), array(1, 1),   // above
        array(-1, 0), array(1, 0),                // sides
        array(-1, -1), array(0, -1), array(1, -1) // below
      );

      $this->neighbours["$x-$y"] = array();
      foreach ($directions as $set) {
        $cell = $this->cell_at(($x + $set[0]), ($y + $set[1]));
        if ($cell) { array_push($this->neighbours["$x-$y"], $cell); }
      }
    }

    return $this->neighbours["$x-$y"];
  }

  function alive_neighbours_at($x, $y) {
    return array_filter($this->neighbours_at($x, $y), function($cell) {
      return !$cell->dead;
    });
  }

  function tick() {
    $cells = array_values($this->cells);

    // First determine the action for all cells
    foreach ($cells as $cell) {
      $alive_neighbours = count($this->alive_neighbours_at($cell->x, $cell->y));
      if ($cell->dead && $alive_neighbours == 3) {
        $cell->next_action = 'revive';
      } else if (!in_array($alive_neighbours, array(2,3))) {
        $cell->next_action = 'kill';
      }
    }

    // Then execute the determined action for all cells
    foreach ($cells as $cell) {
      if ($cell->next_action == 'revive') {
        $cell->dead = false;
      } else if ($cell->next_action == 'kill') {
        $cell->dead = true;
      }
    }

    $this->tick += 1;
  }

  function reset() {
    $this->tick = 0;
    $this->cells = array();
    $this->neighbours = array();
    $this->boundaries = null;
  }

  function boundaries() {
    if (!$this->boundaries) {
      $x_vals = $y_vals = array();
      foreach ($this->cells as $cell) {
        array_push($x_vals, $cell->x);
        array_push($y_vals, $cell->y);
      }

      $this->boundaries = array(
        'x' => array(
          'min' => min($x_vals),
          'max' => max($x_vals)
        ),
        'y' => array(
          'min' => min($y_vals),
          'max' => max($y_vals)
        )
      );
    }

    return $this->boundaries;
  }

}

class Cell {

  var $x, $y, $dead, $next_action;

  function __construct($x, $y, $dead = false) {
    $this->x = $x;
    $this->y = $y;
    $this->dead = $dead;
  }

  function to_char() {
    return ($this->dead ? ' ' : 'o');
  }

}

?>