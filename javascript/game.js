function World(width, height) {
  // Javascript doesn't have a concept of public/private variables

  this.width = width;
  this.height = height;
  this.tick = 0;
  this.cells = {};
  this.cached_directions = [
    [-1, 1],  [0, 1],  [1, 1], // above
    [-1, 0],           [1, 0], // sides
    [-1, -1], [0, -1], [1, -1] // below
  ];

  this.populate_cells();
  this.prepopulate_neighbours();
}

World.LocationOccupied = function() {};

World.prototype._tick = function() {
  let cells = Object.values(this.cells);

  // First determine the action for all cells
  for (let cell of cells) {
    let alive_neighbours = this.alive_neighbours_around(cell);
    if (!cell.alive && alive_neighbours == 3) {
      cell.next_state = 1;
    } else if (alive_neighbours < 2 || alive_neighbours > 3) {
      cell.next_state = 0;
    }
  }

  // Then execute the determined action for all cells
  for (let cell of cells) {
    if (cell.next_state == 1) {
      cell.alive = true;
    } else if (cell.next_state == 0) {
      cell.alive = false;
    }
  }

  this.tick += 1;
}

World.prototype.render = function() {
  let rendering = '';
  for (let y = 0; y <= this.height; y++) {
    for (let x = 0; x <= this.width; x++) {
      let cell = this.cell_at(x, y);
      rendering += cell.to_char().replace(' ', '&nbsp;');
    }
    rendering += "<br />"
  }
  return rendering;
}

// Javascript doesn't have a concept of public/private methods

World.prototype.populate_cells = function() {
  for (let y = 0; y <= this.height; y++) {
    for (let x = 0; x <= this.width; x++) {
      let alive = (Math.random() <= 0.2);
      this.add_cell(x, y, alive);
    }
  }
}

World.prototype.prepopulate_neighbours = function() {
  for (let cell of Object.values(this.cells)) {
    this.neighbours_around(cell);
  }
}

World.prototype.add_cell = function(x, y, alive) {
  alive = (alive || false);
  if (this.cell_at(x, y)) {
    throw new World.LocationOccupied;
  }

  let cell = new Cell(x, y, alive);
  this.cells[x+'-'+y] = cell;
  return this.cell_at(x, y);
}

World.prototype.cell_at = function(x, y) {
  return this.cells[x+'-'+y];
}

World.prototype.neighbours_around = function(cell) {
  if (!cell.neighbours) {
    cell.neighbours = new Array;
    for (let set of this.cached_directions) {
      let neighbour = this.cell_at(
        (cell.x + set[0]),
        (cell.y + set[1])
      );
      if (neighbour) {
        cell.neighbours.push(neighbour);
      }
    }
  }

  return cell.neighbours;
}

// Implement first using filter/lambda if available. Then implement
// foreach and for. Retain whatever implementation runs the fastest
World.prototype.alive_neighbours_around = function(cell) {
  // The following works but is slower
  // let neighbours = this.neighbours_around(cell);
  // return neighbours.filter(function(neighbour) {
  //   return neighbour.alive;
  // }).length;

  // The following also works but is slower
  // var alive_neighbours = 0;
  // for (let neighbour of this.neighbours_around(cell)) {
  //   if (neighbour.alive) {
  //     alive_neighbours = alive_neighbours + 1;
  //   }
  // }
  // return alive_neighbours;

  var alive_neighbours = 0;
  var neighbours = this.neighbours_around(cell);
  for (let i = 0; i < neighbours.length; i++) {
    let neighbour = neighbours[i];
    if (neighbour.alive) {
      alive_neighbours = alive_neighbours + 1;
    }
  }
  return alive_neighbours;
}

function Cell(x, y, alive) {
  this.x = x;
  this.y = y;
  this.alive = (alive || false);
  this.next_state = null;
  this.neighbours = null;
}

Cell.prototype.to_char = function() {
  return (this.alive ? 'o' : ' ');
}
