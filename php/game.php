<?php

error_reporting(E_ALL);

// PHP doesn't have a concept of nested classes
class LocationOccupied extends Exception { }

class World {

  public $tick;

  function __construct($width, $height) {
    $this->width = $width;
    $this->height = $height;
    $this->tick = 0;
    $this->cells = array();
    $this->cached_directions = array(
      array(-1, 1),  array(0, 1),  array(1, 1), // above
      array(-1, 0),                array(1, 0), // sides
      array(-1, -1), array(0, -1), array(1, -1) // below
    );

    $this->populate_cells();
    $this->prepopulate_neighbours();
  }

  public function _tick() {
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

  public function render() {
    $rendering = '';
    for ($y = 0; $y <= $this->height; $y++) {
      for ($x = 0; $x <= $this->width; $x++) {
        $cell = $this->cell_at($x, $y);
        $rendering .= $cell->to_char();
      }
      $rendering .= "\n";
    }
    return $rendering;
  }

  private function populate_cells() {
    for ($y = 0; $y <= $this->height; $y++) {
      for ($x = 0; $x <= $this->width; $x++) {
        $alive = (rand(0, 100) <= 20);
        $this->add_cell($x, $y, $alive);
      }
    }
  }

  private function prepopulate_neighbours() {
    foreach ($this->cells as $cell) {
      $this->neighbours_around($cell);
    }
  }

  private function add_cell($x, $y, $alive = false) {
    if ($this->cell_at($x, $y)) {
      throw new LocationOccupied;
    }

    $this->cells["$x-$y"] = new Cell($x, $y, $alive);
    return $this->cells["$x-$y"];
  }

  private function cell_at($x, $y) {
    if (isset($this->cells["$x-$y"])) {
      return $this->cells["$x-$y"];
    }
  }

  private function neighbours_around($cell) {
    if (!$cell->neighbours) {
      $cell->neighbours = array();
      foreach ($this->cached_directions as $set) {
        $neighbour = $this->cell_at(($cell->x + $set[0]), ($cell->y + $set[1]));
        if ($neighbour) { $cell->neighbours[] = $neighbour; }
      }
    }

    return $cell->neighbours;
  }

  private function alive_neighbours_around($cell) {
    $alive_neighbours = 0;
    foreach ($this->neighbours_around($cell) as $neighbour) {
      if ($neighbour->alive) {
        $alive_neighbours++;
      }
    }
    return $alive_neighbours;
  }

}

class Cell {

  var $x, $y, $alive, $next_state, $neighbours;

  function __construct($x, $y, $alive = false) {
    $this->x = $x;
    $this->y = $y;
    $this->alive = $alive;
    $this->next_state = null;
    $this->neighbours = null;
  }

  public function to_char() {
    return ($this->alive ? 'o' : ' ');
  }

}

?>
