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
    unset($this->neighbours, $this->boundaries);
    return $this->cells["$x-$y"] = new Cell($x, $y, $dead);
  }

  function cell_at($x, $y) {
    if (isset($this->cells["$x-$y"])) {
      return $this->cells["$x-$y"];
    }
  }

  function neighbours_around($cell) {
    if (!isset($this->neighbours[$cell->key])) {
      $this->neighbours[$cell->key] = array();
      foreach ($this->directions as $set) {
        $neighbour = $this->cell_at(($cell->x + $set[0]), ($cell->y + $set[1]));
        if ($neighbour) { $this->neighbours[$cell->key][] = $neighbour; }
      }
    }
    return $this->neighbours[$cell->key];
  }

  function alive_neighbours_around($cell) {
    $alive_neighbours = 0;
    foreach ($this->neighbours_around($cell) as $cell) {
      if (!$cell->dead) {
        $alive_neighbours++;
      }
    }
    return $alive_neighbours;
  }

  function tick() {
    // First determine the action for all cells
    foreach ($this->cells as $cell) {
      $alive_neighbours = $this->alive_neighbours_around($cell);
      if ($cell->dead && $alive_neighbours == 3) {
        $cell->next_action = 'revive';
      } else if ($alive_neighbours < 2 || $alive_neighbours > 3) {
        $cell->next_action = 'kill';
      }
    }

    // Then execute the determined action for all cells
    foreach ($this->cells as $cell) {
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
        $x_vals[] = $cell->x;
        $y_vals[] = $cell->y;
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

  var $x, $y, $key, $dead, $next_action;

  function __construct($x, $y, $dead = false) {
    $this->x = $x;
    $this->y = $y;
    $this->key = "$x-$y";
    $this->dead = $dead;
  }

  function to_char() {
    return ($this->dead ? ' ' : 'o');
  }

}

?>
