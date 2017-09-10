function World() {
  this.tick = 0;
  this.cells = {};
  this.cached_directions = [
    [-1, 1],  [0, 1],  [1, 1], // above
    [-1, 0],           [1, 0], // sides
    [-1, -1], [0, -1], [1, -1] // below
  ];
}

World.LocationOccupied = function() {};

World.prototype.add_cell = function(x, y, alive) {
  alive = (alive || false);
  if (this.cell_at(x, y)) {
    throw new World.LocationOccupied;
  }

  this.cells[x+'-'+y] = new Cell(x, y, alive);
  return this.cells[x+'-'+y];
}

World.prototype.cell_at = function(x, y) {
  return this.cells[x+'-'+y];
}

World.prototype.neighbours_around = function(cell) {
  if (!cell.neighbours) {
    cell.neighbours = new Array;
    $.each(this.cached_directions, function(i, set) {
      var neighbour = this.cell_at((cell.x + set[0]), (cell.y + set[1]));
      if (neighbour) { cell.neighbours.push(neighbour); }
    }.bind(this));
  }

  return cell.neighbours;
}

World.prototype.alive_neighbours_around = function(cell) {
  return $.grep(this.neighbours_around(cell), function(cell) {
    return cell.alive;
  }).length;
}

World.prototype._tick = function() {
  var cells = $.map(this.cells, function(cell) { return cell; });

  // First determine the action for all cells
  $.each(cells, function(i, cell) {
     var alive_neighbours = this.alive_neighbours_around(cell);
     if (!cell.alive && alive_neighbours == 3) {
       cell.next_state = 1;
     } else if (alive_neighbours < 2 || alive_neighbours > 3) {
       cell.next_state = 0;
     }
  }.bind(this));

  // Then execute the determined action for all cells
  $.each(cells, function(i, cell) {
    if (cell.next_state == 1) {
      cell.alive = true;
    } else if (cell.next_state == 0) {
      cell.alive = false;
    }
  });

  this.tick += 1;
}

function Cell(x, y, alive) {
  this.x = x;
  this.y = y;
  this.key = (x+'-'+y);
  this.alive = (alive || false);
  this.next_state = null;
  this.neighbours = null;
}

Cell.prototype.to_char = function() {
  return (this.alive ? 'o' : ' ');
}
