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
    for ($y = 0; $y <= $this->height; $y++) {
      for ($x = 0; $x <= $this->width; $x++) {
        $cell = $this->cell_at($x, $y);
        $rendering .= $cell->to_char();
      }
      $rendering .= "\n";
    }
    return $rendering;

    // The following also works but is slower
    // $rendering = array();
    // for ($y = 0; $y <= $this->height; $y++) {
    //   for ($x = 0; $x <= $this->width; $x++) {
    //     $cell = $this->cell_at($x, $y);
    //     $rendering[] = $cell->to_char();
    //   }
    //   $rendering[] = "\n";
    // }
    // return join($rendering);
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
    if ($this->cell_at($x, $y) != null) {
      throw new LocationOccupied;
    }

    $cell = new Cell($x, $y, $alive);
    $this->cells["$x-$y"] = $cell;
    return $this->cell_at($x, $y);
  }

  private function cell_at($x, $y) {
    if (isset($this->cells["$x-$y"])) {
      return $this->cells["$x-$y"];
    }
  }

  private function neighbours_around($cell) {
    if ($cell->neighbours == null) {
      $cell->neighbours = array();
      foreach ($this->cached_directions as $set) {
        $neighbour = $this->cell_at(
          ($cell->x + $set[0]),
          ($cell->y + $set[1])
        );
        if ($neighbour != null) {
          $cell->neighbours[] = $neighbour;
        }
      }
    }

    return $cell->neighbours;
  }

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Use whatever implementation runs the fastest
  private function alive_neighbours_around($cell) {
    // The following works but is slower
    // $neighbours = $this->neighbours_around($cell);
    // return count(array_filter($neighbours, function($n) { return $n->alive; }));

    // The following was the fastest method
    $alive_neighbours = 0;
    $neighbours = $this->neighbours_around($cell);
    foreach ($neighbours as $neighbour) {
      if ($neighbour->alive) {
        $alive_neighbours++;
      }
    }
    return $alive_neighbours;

    // The following works but is slower
    // $alive_neighbours = 0;
    // $neighbours = $this->neighbours_around($cell);
    // for ($i = 0; $i < count($neighbours); $i++) {
    //   $neighbour = $neighbours[$i];
    //   if ($neighbour->alive) {
    //     $alive_neighbours++;
    //   }
    // }
    // return $alive_neighbours;
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
