<?php

error_reporting(E_ALL);

final class Cell {
  public function __construct(
    public readonly int $x,
    public readonly int $y,
    public bool $alive = false,
    public ?bool $nextState = null,
    public array $neighbours = [],
  ) {}

  public function toChar(): string {
    return $this->alive ? 'o' : ' ';
  }

  public function aliveNeighbours(): int {
    // The following is slower
    // return count(array_filter($this->neighbours, function($n) { return $n->alive; }));

    // The following is the fastest
    $aliveNeighbours = 0;
    foreach ($this->neighbours as $neighbour) {
      if ($neighbour->alive) {
        $aliveNeighbours++;
      }
    }
    return $aliveNeighbours;

    // The following is slower
    // $aliveNeighbours = 0;
    // $count = count($this->neighbours);
    // for ($i = 0; $i < $count; $i++) {
    //   $neighbour = $this->neighbours[$i];
    //   if ($neighbour->alive) {
    //     $aliveNeighbours++;
    //   }
    // }
    // return $aliveNeighbours;
  }
}
