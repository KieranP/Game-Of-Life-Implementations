function World() {
  this._reset();
}

World.LocationOccupied = function() {};

World.prototype.add_cell = function(x, y, dead) {
  dead = (dead || false);
  if (this.cell_at(x, y)) {
    throw new World.LocationOccupied;
  }
  this.cells[x+'-'+y] = new Cell(x, y, dead);
  this.neighbours = {}; // so it recomputes
  this.cached_boundaries = null; // so it recomputes
  return this.cells[x+'-'+y];
}

World.prototype.cell_at = function(x, y) {
  return this.cells[x+'-'+y];
}

World.prototype.neighbours_at = function(x, y) {
  if (!this.neighbours[x+'-'+y]) {
    this.neighbours[x+'-'+y] = new Array;
    $.each(this.directions, function(i, set) {
      var cell = this.cell_at((x + set[0]), (y + set[1]));
      if (cell) { this.neighbours[x+'-'+y].push(cell); }
    }.bind(this));
  }

  return this.neighbours[x+'-'+y];
}

World.prototype.alive_neighbours_at = function(x, y) {
  return $.grep(this.neighbours_at(x, y), function(cell) {
    return !cell.dead;
  });
}

World.prototype._tick = function(x, y) {
  var cells = $.map(this.cells, function(cell) { return cell; });

  // First determine the action for all cells
  $.each(cells, function(i, cell) {
     var alive_neighbours = this.alive_neighbours_at(cell.x, cell.y).length;
     if (cell.dead && alive_neighbours == 3) {
       cell.next_action = 'revive';
     } else if ($.inArray(alive_neighbours, [2,3]) == -1) {
       cell.next_action = 'kill';
     }
  }.bind(this));

  // Then execute the determined action for all cells
  $.each(cells, function(i, cell) {
    if (cell.next_action == 'revive') {
      cell.dead = false;
    } else if (cell.next_action == 'kill') {
      cell.dead = true;
    }
  });

  this.tick += 1;
}

World.prototype._reset = function(x, y) {
  this.tick = 0;
  this.cells = {};
  this.neighbours = {};
  this.cached_boundaries = null;
  this.directions = [
    [-1, 1], [0, 1], [1, 1],   // above
    [-1, 0], [1, 0],           // sides
    [-1, -1], [0, -1], [1, -1] // below
  ];
}

World.prototype.boundaries = function() {
  if (!this.cached_boundaries) {
    var x_vals = new Array, y_vals = new Array;
    $.each(this.cells, function(position, cell) {
      x_vals.push(cell.x);
      y_vals.push(cell.y);
    });

    this.cached_boundaries = {
      x: {
        min: Math.min.apply(null, y_vals),
        max: Math.max.apply(null, x_vals)
      },
      y: {
        min: Math.min.apply(null, y_vals),
        max: Math.max.apply(null, y_vals)
      }
    }
  }

  return this.cached_boundaries;
}

function Cell(x, y, dead) {
  this.x = x;
  this.y = y;
  this.dead = (dead || false);
  this.next_action = null;
}

Cell.prototype.to_char = function() {
  return (this.dead ? ' ' : 'o');
}
