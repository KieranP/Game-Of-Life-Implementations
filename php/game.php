<?php

error_reporting(E_ALL);

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
    unset($this->neighbours);
    unset($this->boundaries);
    return $this->cells["$x-$y"] = new Cell($x, $y, $dead);
  }

  function cell_at($x, $y) {
    if (isset($this->cells["$x-$y"])) {
      return $this->cells["$x-$y"];
    }
  }

  function neighbours_at($x, $y) {
    if (!isset($this->neighbours["$x-$y"])) {
      $this->neighbours["$x-$y"] = array();
      foreach ($this->directions as $set) {
        $cell = $this->cell_at(($x + $set[0]), ($y + $set[1]));
        if ($cell) { array_push($this->neighbours["$x-$y"], $cell); }
      }
    }

    return $this->neighbours["$x-$y"];
  }

  function alive_neighbours_at($x, $y) {
    $alive_neighbours = array();
    foreach ($this->neighbours_at($x, $y) as $cell) {
      if (!$cell->dead) {
        $alive_neighbours[] = $cell;
      }
    }
    return $alive_neighbours;
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
    $this->directions = array(
      array(-1, 1), array(0, 1), array(1, 1),   // above
      array(-1, 0), array(1, 0),                // sides
      array(-1, -1), array(0, -1), array(1, -1) // below
    );
  }

  function boundaries() {
    if (!isset($this->boundaries)) {
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
