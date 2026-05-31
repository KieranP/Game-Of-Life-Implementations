<?php

error_reporting(E_ALL);

require_once 'cell.php';

final class LocationOccupied extends Exception {
  public function __construct(
    public readonly int $x,
    public readonly int $y,
  ) {
    parent::__construct("LocationOccupied($x-$y)");
  }
}

final class World {
  public int $tick = 0;

  private array $cells = [];

  private const array DIRECTIONS = [
    [-1, 1],  [0, 1],  [1, 1],  // above
    [-1, 0],           [1, 0],  // sides
    [-1, -1], [0, -1], [1, -1], // below
  ];

  public function __construct(
    private readonly int $width,
    private readonly int $height,
  ) {
    $this->populate_cells();
    $this->prepopulate_neighbours();
  }

  public function dotick(): void {
    // First determine the action for all cells
    foreach ($this->cells as $cell) {
      $alive_neighbours = $cell->alive_neighbours();
      if (!$cell->alive && $alive_neighbours === 3) {
        $cell->next_state = true;
      } elseif ($alive_neighbours < 2 || $alive_neighbours > 3) {
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

  public function render(): string {
    // The following is the fastest
    $rendering = '';
    for ($y = 0; $y < $this->height; $y++) {
      for ($x = 0; $x < $this->width; $x++) {
        $cell = $this->cell_at($x, $y);
        if ($cell) {
          $rendering .= $cell->to_char();
        }
      }
      $rendering .= "\n";
    }
    return $rendering;

    // The following is slower
    // $rendering = array();
    // for ($y = 0; $y < $this->height; $y++) {
    //   for ($x = 0; $x < $this->width; $x++) {
    //     $cell = $this->cell_at($x, $y);
    //     if ($cell) {
    //       $rendering[] = $cell->to_char();
    //     }
    //   }
    //   $rendering[] = "\n";
    // }
    // return join($rendering);
  }

  private function make_key(int $x, int $y): string {
    // The following is the fastest
    return "$x-$y";

    // The following is slower
    // return $x . '-' . $y;

    // The following is slower
    // return implode('-', [$x, $y]);
  }

  private function cell_at(int $x, int $y): ?Cell {
    $key = $this->make_key($x, $y);
    return $this->cells[$key] ?? null;
  }

  private function populate_cells(): void {
    for ($y = 0; $y < $this->height; $y++) {
      for ($x = 0; $x < $this->width; $x++) {
        $alive = rand(0, 100) <= 20;
        $this->add_cell($x, $y, $alive);
      }
    }
  }

  private function add_cell(int $x, int $y, bool $alive = false): bool {
    $existing = $this->cell_at($x, $y);
    if ($existing) {
      throw new LocationOccupied($x, $y);
    }

    $key = $this->make_key($x, $y);
    $cell = new Cell($x, $y, $alive);
    $this->cells[$key] = $cell;
    return true;
  }

  private function prepopulate_neighbours(): void {
    foreach ($this->cells as $cell) {
      $x = $cell->x;
      $y = $cell->y;

      foreach (self::DIRECTIONS as [$rel_x, $rel_y]) {
        $nx = $x + $rel_x;
        $ny = $y + $rel_y;
        if ($nx < 0 || $ny < 0) {
          continue; // Out of bounds
        }

        if ($nx >= $this->width || $ny >= $this->height) {
          continue; // Out of bounds
        }

        $neighbour = $this->cell_at($nx, $ny);
        if ($neighbour) {
          $cell->neighbours[] = $neighbour;
        }
      }
    }
  }
}
