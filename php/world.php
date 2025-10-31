<?php

error_reporting(E_ALL);

require_once 'cell.php';

class LocationOccupied extends Exception {
  public function __construct($x, $y) {
    parent::__construct("LocationOccupied($x-$y)");
  }
}

class World {
  public $tick;

  private $width, $height, $cells;

  private static $DIRECTIONS = [
    [-1, 1],  [0, 1],  [1, 1], // above
    [-1, 0],           [1, 0], // sides
    [-1, -1], [0, -1], [1, -1] // below
  ];

  public function __construct($width, $height) {
    $this->tick = 0;
    $this->width = $width;
    $this->height = $height;
    $this->cells = [];

    $this->populate_cells();
    $this->prepopulate_neighbours();
  }

  public function _tick() {
    // First determine the action for all cells
    foreach ($this->cells as $cell) {
      $alive_neighbours = $cell->alive_neighbours();
      if (!$cell->alive && $alive_neighbours == 3) {
        $cell->next_state = true;
      } else if ($alive_neighbours < 2 || $alive_neighbours > 3) {
        $cell->next_state = false;
      } else {
        $cell->next_state = $cell->alive;
      }
    }

    // Then execute the determined action for all cells
    foreach ($this->cells as $cell) {
      $cell->alive = $cell->next_state;
    }

    $this->tick += 1;
  }

  // Implement first using string concatenation. Then implement any
  // special string builders, and use whatever runs the fastest
  public function render() {
    // The following was the fastest method
    $rendering = '';
    for ($y = 0; $y < $this->height; $y++) {
      for ($x = 0; $x < $this->width; $x++) {
        $cell = $this->cell_at($x, $y);
        $rendering .= $cell->to_char();
      }
      $rendering .= "\n";
    }
    return $rendering;

    // The following also works but is slower
    // $rendering = array();
    // for ($y = 0; $y < $this->height; $y++) {
    //   for ($x = 0; $x < $this->width; $x++) {
    //     $cell = $this->cell_at($x, $y);
    //     $rendering[] = $cell->to_char();
    //   }
    //   $rendering[] = "\n";
    // }
    // return join($rendering);
  }

  private function cell_at($x, $y) {
    if (isset($this->cells["$x-$y"])) {
      return $this->cells["$x-$y"];
    }
  }

  private function populate_cells() {
    for ($y = 0; $y < $this->height; $y++) {
      for ($x = 0; $x < $this->width; $x++) {
        $alive = rand(0, 100) <= 20;
        $this->add_cell($x, $y, $alive);
      }
    }
  }

  private function add_cell($x, $y, $alive = false) {
    if ($this->cell_at($x, $y) != null) {
      throw new LocationOccupied($x, $y);
    }

    $cell = new Cell($x, $y, $alive);
    $this->cells["$x-$y"] = $cell;
    return true;
  }

  private function prepopulate_neighbours() {
    foreach ($this->cells as $cell) {
      foreach (self::$DIRECTIONS as $set) {
        $neighbour = $this->cell_at(
          $cell->x + $set[0],
          $cell->y + $set[1]
        );

        if ($neighbour != null) {
          $cell->neighbours[] = $neighbour;
        }
      }
    }
  }
}
