// Tests use QUnit - See http://docs.jquery.com/QUnit

$(document).ready(function() {

  module("World");

  test("can be initialized", function() {
    var world = new World;
    equal(world.constructor, World);
    equal(world.cells.constructor, Object);
    equal(world.neighbours.constructor, Object);
  });

  test("cannot add cells if location already contains a cell", function() {
    var world = new World;
    other_cell = world.add_cell(0, 0);
    raises(function() {
      world.add_cell(0, 0);
    }, World.LocationOccupied);
  });

  test("can add cells", function() {
    var world = new World;
    var cell = world.add_cell(0, 0);
    equal(cell.constructor, Cell);
    equal(cell.x, 0);
    equal(cell.y, 0);
  });

  test("can retrieve cells at a given location", function() {
    var world = new World;
    var cell = world.add_cell(0, 0);
    equal(cell, world.cell_at(0, 0));
  });

  test("resets neighbours data when adding cells", function() {
    var world = new World;
    var cell1 = world.add_cell(0, 0);
    var cell2 = world.add_cell(0, 1);
    ok($.inArray(cell2, world.neighbours_around(cell1)) > -1);
    equal($.isEmptyObject(world.neighbours), false);

    var cell3 = world.add_cell(1, 0);
    equal($.isEmptyObject(world.neighbours), true);
  });

  test("can retrieve neighbours for a given location", function() {
    var world = new World;

    var center_cell = world.add_cell(0, 0);

    var cell = world.add_cell(0, 1);
    ok($.inArray(cell, world.neighbours_around(center_cell)) > -1);

    var cell = world.add_cell(1, 1, true);
    ok($.inArray(cell, world.neighbours_around(center_cell)) > -1);

    var cell = world.add_cell(1, 0);
    ok($.inArray(cell, world.neighbours_around(center_cell)) > -1);

    var cell = world.add_cell(1, -1, true);
    ok($.inArray(cell, world.neighbours_around(center_cell)) > -1);

    var cell = world.add_cell(0, -1);
    ok($.inArray(cell, world.neighbours_around(center_cell)) > -1);

    var cell = world.add_cell(-1, -1, true);
    ok($.inArray(cell, world.neighbours_around(center_cell)) > -1);

    var cell = world.add_cell(-1, 0);
    ok($.inArray(cell, world.neighbours_around(center_cell)) > -1);

    var cell = world.add_cell(-1, 1, true);
    ok($.inArray(cell, world.neighbours_around(center_cell)) > -1);
  });

  test("an retrieve alive neighbours for a given location", function() {
    var world = new World;

    var cell1 = world.add_cell(0, 0);
    var cell2 = world.add_cell(0, 1);
    var cell3 = world.add_cell(1, 0, true);
    equal(world.alive_neighbours_around(cell1), 1);
  });

  test("can tick along", function() {
    var world = new World;
    var tick = world.tick;
    world._tick();
    equal(world.tick, (tick + 1));
  });

  test("can be reset", function() {
    var world = new World;
    var cell = world.add_cell(0, 0);
    world.tick = 100;
    equal($.isEmptyObject(world.cells), false);
    world._reset();
    equal(world.tick, 0);
    equal($.isEmptyObject(world.cells), true);
  });

  test("has boundaries", function() {
    var world = new World;
    var cell1 = world.add_cell(0, 0);
    var cell2 = world.add_cell(5, 5);
    equal(world.boundaries()['x']['min'], 0);
    equal(world.boundaries()['x']['max'], 5);
    equal(world.boundaries()['y']['min'], 0);
    equal(world.boundaries()['y']['max'], 5);
  });

  module("Cell");

  test("can be initialized", function() {
    var cell = new Cell(0, 0);
    equal(cell.constructor, Cell);
    equal(cell.x, 0);
    equal(cell.y, 0);
    equal(cell.dead, false);
    equal(cell.next_action, null);
  });

  test("can initialize a dead cell", function() {
    var cell = new Cell(0, 0, true);
    equal(cell.dead, true);
  });

  test("should print out according to it's state", function() {
    var cell = new Cell(0, 0);
    equal('o', cell.to_char());

    cell.dead = true;
    equal(' ', cell.to_char());
  });

  module("Rules");

  test("Rule #1: Any live cell with fewer than two live neighbours dies, as if caused by under-population", function() {
    var world = new World;
    var cell1 = world.add_cell(0, 0);
    world._tick();
    equal(cell1.dead, true);

    world._reset();

    var cell1 = world.add_cell(0, 0);
    var cell2 = world.add_cell(0, 1);
    world._tick();
    equal(cell1.dead, true);
  });

  test("Rule #2: Any live cell with two or three live neighbours lives on to the next generation", function() {
    var world = new World;
    var cell1 = world.add_cell(0, 0);
    var cell2 = world.add_cell(0, 1);
    var cell3 = world.add_cell(1, 0);
    world._tick();
    equal(cell1.dead, false);

    world._reset();

    var cell1 = world.add_cell(0, 0);
    var cell2 = world.add_cell(0, 1);
    var cell3 = world.add_cell(1, 0);
    var cell4 = world.add_cell(1, 1);
    world._tick();
    equal(cell1.dead, false);
  });

  test("Rule #3: Any live cell with more than three live neighbours dies, as if by overcrowding", function() {
    var world = new World;
    var cell1 = world.add_cell(0, 0);
    var cell2 = world.add_cell(0, 1);
    var cell3 = world.add_cell(1, 0);
    var cell4 = world.add_cell(0, -1);
    var cell5 = world.add_cell(-1, 0);
    world._tick();
    equal(cell1.dead, true);
  });

  test("Rule #4: Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction", function() {
    var world = new World;
    var cell1 = world.add_cell(0, 0, true);
    var cell2 = world.add_cell(0, 1);
    var cell3 = world.add_cell(1, 0);
    var cell4 = world.add_cell(1, 1);
    world._tick();
    equal(cell1.dead, false);
  });

});
