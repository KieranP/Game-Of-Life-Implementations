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
    $this->populateCells();
    $this->prepopulateNeighbours();
  }

  public function doTick(): void {
    // First determine the action for all cells
    foreach ($this->cells as $cell) {
      $aliveNeighbours = $cell->aliveNeighbours();
      if (!$cell->alive && $aliveNeighbours === 3) {
        $cell->nextState = true;
      } elseif ($aliveNeighbours < 2 || $aliveNeighbours > 3) {
        $cell->nextState = false;
      } else {
        $cell->nextState = $cell->alive;
      }
    }

    // Then execute the determined action for all cells
    foreach ($this->cells as $cell) {
      $cell->alive = $cell->nextState;
    }

    $this->tick += 1;
  }

  public function render(): string {
    // The following is the fastest
    $rendering = '';
    for ($y = 0; $y < $this->height; $y++) {
      for ($x = 0; $x < $this->width; $x++) {
        $cell = $this->cellAt($x, $y);
        if ($cell) {
          $rendering .= $cell->toChar();
        }
      }
      $rendering .= "\n";
    }
    return $rendering;

    // The following is slower
    // $rendering = array();
    // for ($y = 0; $y < $this->height; $y++) {
    //   for ($x = 0; $x < $this->width; $x++) {
    //     $cell = $this->cellAt($x, $y);
    //     if ($cell) {
    //       $rendering[] = $cell->toChar();
    //     }
    //   }
    //   $rendering[] = "\n";
    // }
    // return join($rendering);
  }

  private function makeKey(int $x, int $y): string {
    // The following is the fastest
    return "$x-$y";

    // The following is slower
    // return $x . '-' . $y;

    // The following is slower
    // return implode('-', [$x, $y]);
  }

  private function cellAt(int $x, int $y): ?Cell {
    $key = $this->makeKey($x, $y);
    return $this->cells[$key] ?? null;
  }

  private function populateCells(): void {
    for ($y = 0; $y < $this->height; $y++) {
      for ($x = 0; $x < $this->width; $x++) {
        $alive = rand(0, 99) < 20;
        $this->addCell($x, $y, $alive);
      }
    }
  }

  private function addCell(int $x, int $y, bool $alive = false): bool {
    $existing = $this->cellAt($x, $y);
    if ($existing) {
      throw new LocationOccupied($x, $y);
    }

    $key = $this->makeKey($x, $y);
    $cell = new Cell($x, $y, $alive);
    $this->cells[$key] = $cell;
    return true;
  }

  private function prepopulateNeighbours(): void {
    foreach ($this->cells as $cell) {
      $x = $cell->x;
      $y = $cell->y;

      foreach (self::DIRECTIONS as [$relX, $relY]) {
        $nx = $x + $relX;
        $ny = $y + $relY;
        if ($nx < 0 || $ny < 0) {
          continue; // Out of bounds
        }

        if ($nx >= $this->width || $ny >= $this->height) {
          continue; // Out of bounds
        }

        $neighbour = $this->cellAt($nx, $ny);
        if ($neighbour) {
          $cell->neighbours[] = $neighbour;
        }
      }
    }
  }
}
