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

  final int _width;
  final int _height;
  final Map<String, Cell> _cells = {};

  static const List<(int, int)> _DIRECTIONS = [
    (-1, 1),  (0, 1),  (1, 1), // above
    (-1, 0),           (1, 0), // sides
    (-1, -1), (0, -1), (1, -1) // below
  ];

  World(this._width, this._height) {
    _populate_cells();
    _prepopulate_neighbours();
  }

  void dotick() {
    // First determine the action for all cells
    for (final cell in _cells.values) {
      final alive_neighbours = cell.alive_neighbours();
      if (!cell.alive && alive_neighbours == 3) {
        cell.next_state = true;
      } else if (alive_neighbours < 2 || alive_neighbours > 3) {
        cell.next_state = false;
      } else {
        cell.next_state = cell.alive;
      }
    }

    // Then execute the determined action for all cells
    for (final cell in _cells.values) {
      cell.alive = cell.next_state ?? false;
    }

    tick += 1;
  }

  String render() {
    // The following is slower
    // var rendering = '';
    // for (var y = 0; y < _height; y++) {
    //   for (var x = 0; x < _width; x++) {
    //     final cell = _cell_at(x, y);
    //     if (cell != null) {
    //       rendering += cell.to_char();
    //     }
    //   }
    //   rendering += "\n";
    // }
    // return rendering;

    // The following is the fastest
    final rendering = <String>[];
    for (var y = 0; y < _height; y++) {
      for (var x = 0; x < _width; x++) {
        final cell = _cell_at(x, y);
        if (cell != null) {
          rendering.add(cell.to_char());
        }
      }
      rendering.add("\n");
    }
    return rendering.join("");

    // The following is slower
    // final rendering = StringBuffer();
    // for (var y = 0; y < _height; y++) {
    //   for (var x = 0; x < _width; x++) {
    //     final cell = _cell_at(x, y);
    //     if (cell != null) {
    //       rendering.write(cell.to_char());
    //     }
    //   }
    //   rendering.write("\n");
    // }
    // return rendering.toString();
  }

  String _make_key(int x, int y) {
    // The following is the fastest
    return "$x-$y";

    // The following is slower
    // return x.toString() + "-" + y.toString();

    // The following is slower
    // return [x, y].join("-");
  }

  Cell? _cell_at(int x, int y) {
    final key = _make_key(x, y);
    return _cells[key];
  }

  void _populate_cells() {
    final rng = Random();
    for (var y = 0; y < _height; y++) {
      for (var x = 0; x < _width; x++) {
        final alive = rng.nextDouble() <= 0.2;
        _add_cell(x, y, alive);
      }
    }
  }

  bool _add_cell(int x, int y, [bool alive = false]) {
    final existing = _cell_at(x, y);
    if (existing != null) {
      throw LocationOccupied(x, y);
    }

    final key = _make_key(x, y);
    final cell = Cell(x, y, alive);
    _cells[key] = cell;
    return true;
  }

  void _prepopulate_neighbours() {
    for (final cell in _cells.values) {
      final x = cell.x;
      final y = cell.y;

      for (final (rel_x, rel_y) in _DIRECTIONS) {
        final nx = x + rel_x;
        final ny = y + rel_y;
        if (nx < 0 || ny < 0) {
          continue; // Out of bounds
        }

        if (nx >= _width || ny >= _height) {
          continue; // Out of bounds
        }

        final neighbour = _cell_at(nx, ny);
        if (neighbour != null) {
          cell.neighbours.add(neighbour);
        }
      }
    }
  }
}
