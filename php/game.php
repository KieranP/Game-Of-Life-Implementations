<?php

error_reporting(E_ALL);

class LocationOccupied extends Exception { }

class World {

  var $tick, $cells;

  function __construct() {
    $this->tick = 0;
    $this->cells = array();
    $this->cached_directions = array(
      array(-1, 1),  array(0, 1),  array(1, 1), // above
      array(-1, 0),                array(1, 0), // sides
      array(-1, -1), array(0, -1), array(1, -1) // below
    );
  }

  function add_cell($x, $y, $alive = false) {
    if ($this->cell_at($x, $y)) {
      throw new LocationOccupied;
    }

    $this->cells["$x-$y"] = new Cell($x, $y, $alive);
    return $this->cells["$x-$y"];
  }

  function cell_at($x, $y) {
    if (isset($this->cells["$x-$y"])) {
      return $this->cells["$x-$y"];
    }
  }

  function neighbours_around($cell) {
    if (!$cell->neighbours) {
      $cell->neighbours = array();
      foreach ($this->cached_directions as $set) {
        $neighbour = $this->cell_at(($cell->x + $set[0]), ($cell->y + $set[1]));
        if ($neighbour) { $cell->neighbours[] = $neighbour; }
      }
    }
    return $cell->neighbours;
  }

  function alive_neighbours_around($cell) {
    $alive_neighbours = 0;
    foreach ($this->neighbours_around($cell) as $cell) {
      if ($cell->alive) {
        $alive_neighbours++;
      }
    }
    return $alive_neighbours;
  }

  function tick() {
    // First determine the action for all cells
    foreach ($this->cells as $cell) {
      $alive_neighbours = $this->alive_neighbours_around($cell);
      if (!$cell->alive && $alive_neighbours == 3) {
        $cell->next_state = 1;
      } else if ($alive_neighbours < 2 || $alive_neighbours > 3) {
        $cell->next_state = 0;
      }
    }

    // Then execute the determined action for all cells
    foreach ($this->cells as $cell) {
      if ($cell->next_state == 1) {
        $cell->alive = true;
      } else if ($cell->next_state == 0) {
        $cell->alive = false;
      }
    }

    $this->tick += 1;
  }

}

class Cell {

  var $x, $y, $key, $alive, $next_state, $neighbours;

  function __construct($x, $y, $alive = false) {
    $this->x = $x;
    $this->y = $y;
    $this->key = "$x-$y";
    $this->alive = $alive;
    $this->next_state = null;
    $this->neighbours = null;
  }

  function to_char() {
    return ($this->alive ? 'o' : ' ');
  }

}

?>
