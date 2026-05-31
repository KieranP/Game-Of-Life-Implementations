<?php

error_reporting(E_ALL);

final class Cell {
  public function __construct(
    public readonly int $x,
    public readonly int $y,
    public bool $alive = false,
    public ?bool $next_state = null,
    public array $neighbours = [],
  ) {}

  public function to_char(): string {
    return $this->alive ? 'o' : ' ';
  }

  public function alive_neighbours(): int {
    // The following is slower
    // return count(array_filter($this->neighbours, function($n) { return $n->alive; }));

    // The following is the fastest
    $alive_neighbours = 0;
    foreach ($this->neighbours as $neighbour) {
      if ($neighbour->alive) {
        $alive_neighbours++;
      }
    }
    return $alive_neighbours;

    // The following is slower
    // $alive_neighbours = 0;
    // $count = count($this->neighbours);
    // for ($i = 0; $i < $count; $i++) {
    //   $neighbour = $this->neighbours[$i];
    //   if ($neighbour->alive) {
    //     $alive_neighbours++;
    //   }
    // }
    // return $alive_neighbours;
  }
}
