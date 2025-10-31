import 'cell.dart';
import 'dart:math';

class LocationOccupied implements Exception {
  final int _x, _y;

  LocationOccupied(this._x, this._y);

  @override
  String toString() => 'LocationOccupied($_x-$_y)';
}

class World {
  int tick = 0;

  int _width;
  int _height;
  Map<String, Cell> _cells = {};

  static const List<List<int>> _DIRECTIONS = [
    [-1, 1],  [0, 1],  [1, 1], // above
    [-1, 0],           [1, 0], // sides
    [-1, -1], [0, -1], [1, -1] // below
  ];

  World(this._width, this._height) {
    _populate_cells();
    _prepopulate_neighbours();
  }

  void tick_() {
    // First determine the action for all cells
    this._cells.forEach((key, cell) {
      final alive_neighbours = cell.alive_neighbours();
      if (!cell.alive && alive_neighbours == 3) {
        cell.next_state = true;
      } else if (alive_neighbours < 2 || alive_neighbours > 3) {
        cell.next_state = false;
      } else {
        cell.next_state = cell.alive;
      }
    });

    // Then execute the determined action for all cells
    this._cells.forEach((key, cell) {
      cell.alive = cell.next_state ?? false;
    });

    this.tick += 1;
  }

  // Implement first using string concatenation. Then implement any
  // special string builders, and use whatever runs the fastest
  String render() {
    // The following works but is slower
    // var rendering = '';
    // for (var y = 0; y < this._height; y++) {
    //   for (var x = 0; x < this._width; x++) {
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
    for (var y = 0; y < this._height; y++) {
      for (var x = 0; x < this._width; x++) {
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
    // for (var y = 0; y < this._height; y++) {
    //   for (var x = 0; x < this._width; x++) {
    //     final cell = this._cell_at(x, y);
    //     if (cell != null) {
    //       rendering.write(cell.to_char());
    //     }
    //   }
    //   rendering.write("\n");
    // }
    // return rendering.toString();
  }

  Cell? _cell_at(int x, int y) {
    return this._cells["$x-$y"];
  }

  void _populate_cells() {
    final rng = Random();
    for (var y = 0; y < this._height; y++) {
      for (var x = 0; x < this._width; x++) {
        final alive = (rng.nextDouble() <= 0.2);
        this._add_cell(x, y, alive);
      }
    }
  }

  bool _add_cell(int x, int y, [bool alive = false]) {
    if (this._cell_at(x, y) != null) {
      throw LocationOccupied(x, y);
    }

    final cell = Cell(x, y, alive);
    this._cells["$x-$y"] = cell;
    return true;
  }

  void _prepopulate_neighbours() {
    this._cells.forEach((key, cell) {
      for (final set in _DIRECTIONS) {
        final neighbour = this._cell_at(
          (cell.x + set[0]),
          (cell.y + set[1])
        );

        if (neighbour != null) {
          cell.neighbours.add(neighbour);
        }
      }
    });
  }
}
