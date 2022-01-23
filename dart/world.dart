// In Dart, anything preceeded by an underscore (_) is a private function/variable

import 'dart:math';

class LocationOccupied implements Exception {}

class World {

  int width;
  int height;
  int tick = 0;
  Map<String, Cell> _cells = {};
  List<List<int>> _cached_directions = const [
    [-1, 1],  [0, 1],  [1, 1], // above
    [-1, 0],           [1, 0], // sides
    [-1, -1], [0, -1], [1, -1] // below
  ];

  World(this.width, this.height) {
    _populate_cells();
    _prepopulate_neighbours();
  }

  void tick_() {
    // First determine the action for all cells
    this._cells.forEach((key, cell) {
      final alive_neighbours = this._alive_neighbours_around(cell);
      if (!cell.alive && alive_neighbours == 3) {
        cell.next_state = 1;
      } else if (alive_neighbours < 2 || alive_neighbours > 3) {
        cell.next_state = 0;
      }
    });

    // Then execute the determined action for all cells
    this._cells.forEach((key, cell) {
      if (cell.next_state == 1) {
        cell.alive = true;
      } else if (cell.next_state == 0) {
        cell.alive = false;
      }
    });

    this.tick += 1;
  }

  // Implement first using string concatenation. Then implement any
  // special string builders, and use whatever runs the fastest
  String render() {
    // The following works but is slower
    // var rendering = '';
    // for (var y = 0; y <= this.height; y++) {
    //   for (var x = 0; x <= this.width; x++) {
    //     final cell = this._cell_at(x, y);
    //     if (cell != null) {
    //       rendering += cell.to_char();
    //     }
    //   }
    //   rendering += "\n";
    // }
    // return rendering;

    // The following was the fastest method
    var rendering = [];
    for (var y = 0; y <= this.height; y++) {
      for (var x = 0; x <= this.width; x++) {
        final cell = this._cell_at(x, y);
        if (cell != null) {
          rendering.add(cell.to_char());
        }
      }
      rendering.add("\n");
    }
    return rendering.join("");

    // The following works but is slower
    // var rendering = StringBuffer();
    // for (var y = 0; y <= this.height; y++) {
    //   for (var x = 0; x <= this.width; x++) {
    //     final cell = this._cell_at(x, y);
    //     if (cell != null) {
    //       rendering.write(cell.to_char());
    //     }
    //   }
    //   rendering.write("\n");
    // }
    // return rendering.toString();
  }

  void _populate_cells() {
    final rng = Random();
    for (var y = 0; y <= this.height; y++) {
      for (var x = 0; x <= this.width; x++) {
        final alive = (rng.nextDouble() <= 0.2);
        this._add_cell(x, y, alive);
      }
    }
  }

  void _prepopulate_neighbours() {
    this._cells.forEach((key, cell) {
      this._neighbours_around(cell);
    });
  }

  Cell? _add_cell(int x, int y, [bool alive = false]) {
    if (this._cell_at(x, y) != null) { // Must return a boolean
      throw LocationOccupied();
    }

    final cell = Cell(x, y, alive);
    this._cells["$x-$y"] = cell;
    return this._cell_at(x, y);
  }

  Cell? _cell_at(int x, int y) {
    return this._cells["$x-$y"];
  }

  List<Cell>? _neighbours_around(Cell cell) {
    if (cell.neighbours == null) { // Must return a boolean
      cell.neighbours = [];
      for (final set in this._cached_directions) {
        final neighbour = this._cell_at(
          (cell.x + set[0]),
          (cell.y + set[1])
        );
        if (neighbour != null) {
          cell.neighbours?.add(neighbour);
        }
      }
    }

    return cell.neighbours;
  }

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Retain whatever implementation runs the fastest
  int _alive_neighbours_around(Cell cell) {
    // The following works but is slower
    // final neighbours = this._neighbours_around(cell);
    // return neighbours!.where(
    //   (neighbour) => neighbour.alive
    // ).length;

    // The following was the fastest method
    var alive_neighbours = 0;
    final neighbours = this._neighbours_around(cell);
    neighbours!.forEach((neighbour) {
      if (neighbour.alive) {
        alive_neighbours += 1;
      }
    });
    return alive_neighbours;

    // The following also works but is slower
    // var alive_neighbours = 0;
    // final neighbours = this._neighbours_around(cell);
    // for (var i = 0; i < neighbours!.length; i++) {
    //   final neighbour = neighbours[i];
    //   if (neighbour.alive) {
    //     alive_neighbours += 1;
    //   }
    // }
    // return alive_neighbours;
  }

}

class Cell {

  int x;
  int y;
  bool alive;
  int? next_state = null;
  List<Cell>? neighbours = null;

  Cell(this.x, this.y, [this.alive = false]) {}

  String to_char() {
    return this.alive ? 'o' : ' ';
  }

}
