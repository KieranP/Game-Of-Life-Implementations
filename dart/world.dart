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

  static const List<(int, int)> _directions = [
    (-1, 1),  (0, 1),  (1, 1), // above
    (-1, 0),           (1, 0), // sides
    (-1, -1), (0, -1), (1, -1) // below
  ];

  World(this._width, this._height) {
    _populateCells();
    _prepopulateNeighbours();
  }

  void doTick() {
    // First determine the action for all cells
    for (final cell in _cells.values) {
      final aliveNeighbours = cell.aliveNeighbours();
      if (!cell.alive && aliveNeighbours == 3) {
        cell.nextState = true;
      } else if (aliveNeighbours < 2 || aliveNeighbours > 3) {
        cell.nextState = false;
      } else {
        cell.nextState = cell.alive;
      }
    }

    // Then execute the determined action for all cells
    for (final cell in _cells.values) {
      cell.alive = cell.nextState ?? false;
    }

    tick += 1;
  }

  String render() {
    // The following is slower
    // var rendering = '';
    // for (var y = 0; y < _height; y++) {
    //   for (var x = 0; x < _width; x++) {
    //     final cell = _cellAt(x, y);
    //     if (cell != null) {
    //       rendering += cell.toChar();
    //     }
    //   }
    //   rendering += "\n";
    // }
    // return rendering;

    // The following is the fastest
    final rendering = <String>[];
    for (var y = 0; y < _height; y++) {
      for (var x = 0; x < _width; x++) {
        final cell = _cellAt(x, y);
        if (cell != null) {
          rendering.add(cell.toChar());
        }
      }
      rendering.add("\n");
    }
    return rendering.join("");

    // The following is slower
    // final rendering = StringBuffer();
    // for (var y = 0; y < _height; y++) {
    //   for (var x = 0; x < _width; x++) {
    //     final cell = _cellAt(x, y);
    //     if (cell != null) {
    //       rendering.write(cell.toChar());
    //     }
    //   }
    //   rendering.write("\n");
    // }
    // return rendering.toString();
  }

  String _makeKey(int x, int y) {
    // The following is the fastest
    return "$x-$y";

    // The following is slower
    // return x.toString() + "-" + y.toString();

    // The following is slower
    // return [x, y].join("-");
  }

  Cell? _cellAt(int x, int y) {
    final key = _makeKey(x, y);
    return _cells[key];
  }

  void _populateCells() {
    final rng = Random();
    for (var y = 0; y < _height; y++) {
      for (var x = 0; x < _width; x++) {
        final alive = rng.nextDouble() <= 0.2;
        _addCell(x, y, alive);
      }
    }
  }

  bool _addCell(int x, int y, [bool alive = false]) {
    final existing = _cellAt(x, y);
    if (existing != null) {
      throw LocationOccupied(x, y);
    }

    final key = _makeKey(x, y);
    final cell = Cell(x, y, alive);
    _cells[key] = cell;
    return true;
  }

  void _prepopulateNeighbours() {
    for (final cell in _cells.values) {
      final x = cell.x;
      final y = cell.y;

      for (final (relX, relY) in _directions) {
        final nx = x + relX;
        final ny = y + relY;
        if (nx < 0 || ny < 0) {
          continue; // Out of bounds
        }

        if (nx >= _width || ny >= _height) {
          continue; // Out of bounds
        }

        final neighbour = _cellAt(nx, ny);
        if (neighbour != null) {
          cell.neighbours.add(neighbour);
        }
      }
    }
  }
}
