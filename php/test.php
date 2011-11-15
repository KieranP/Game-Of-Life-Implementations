<?php

// Tests use SimpleTest - See http://simpletest.org/en/unit_test_documentation.html

require_once('simpletest/autorun.php');
require_once('game.php');

class WorldTest extends UnitTestCase {

  var $world;

  function setUp() {
    $this->world = new World;
  }

  function test_can_be_initialized() {
    $this->assertEqual(get_class($this->world), World);
    $this->assertTrue(is_array($this->world->cells));
    $this->assertTrue(is_array($this->world->neighbours));
  }

  function test_cannot_add_cells_if_location_already_contains_a_cell() {
    $other_cell = $this->world->add_cell(0, 0);
    $this->expectException(new LocationOccupied);
    $this->world->add_cell(0, 0);
  }

  function test_can_add_cells() {
    $cell = $this->world->add_cell(0, 0);
    $this->assertEqual(get_class($cell), Cell);
    $this->assertEqual($cell->x, 0);
    $this->assertEqual($cell->y, 0);
  }

  function test_can_retrieve_cells_at_a_given_location() {
    $cell = $this->world->add_cell(0, 0);
    $this->assertEqual($this->world->cell_at(0, 0), $cell);
  }

  function test_resets_neighbours_data_when_adding_cells() {
    $cell1 = $this->world->add_cell(0, 0);
    $cell2 = $this->world->add_cell(0, 1);
    $this->assertTrue(in_array($cell2, $this->world->neighbours_at(0, 0)));
    $this->assertFalse(empty($this->world->neighbours));

    $cell3 = $this->world->add_cell(1, 0);
    $this->assertTrue(empty($this->world->neighbours));
  }

  function test_can_retrieve_neighbours_for_a_given_location() {
    $cell = $this->world->add_cell(0, 1);
    $this->assertTrue(in_array($cell, $this->world->neighbours_at(0, 0)));

    $cell = $this->world->add_cell(1, 1, true);
    $this->assertTrue(in_array($cell, $this->world->neighbours_at(0, 0)));

    $cell = $this->world->add_cell(1, 0);
    $this->assertTrue(in_array($cell, $this->world->neighbours_at(0, 0)));

    $cell = $this->world->add_cell(1, -1, true);
    $this->assertTrue(in_array($cell, $this->world->neighbours_at(0, 0)));

    $cell = $this->world->add_cell(0, -1);
    $this->assertTrue(in_array($cell, $this->world->neighbours_at(0, 0)));

    $cell = $this->world->add_cell(-1, -1, true);
    $this->assertTrue(in_array($cell, $this->world->neighbours_at(0, 0)));

    $cell = $this->world->add_cell(-1, 0);
    $this->assertTrue(in_array($cell, $this->world->neighbours_at(0, 0)));

    $cell = $this->world->add_cell(-1, 1, true);
    $this->assertTrue(in_array($cell, $this->world->neighbours_at(0, 0)));
  }

  function test_can_retrieve_alive_neighbours_for_a_given_location() {
    $cell1 = $this->world->add_cell(0, 0);
    $cell2 = $this->world->add_cell(0, 1);
    $cell3 = $this->world->add_cell(1, 0, true);
    $this->assertTrue(in_array($cell2, $this->world->alive_neighbours_at(0, 0)));
    $this->assertFalse(in_array($cell3, $this->world->alive_neighbours_at(0, 0)));
  }

  function test_can_tick_along() {
    $tick = $this->world->tick;
    $this->world->tick();
    $this->assertEqual($this->world->tick, ($tick + 1));
  }

  function test_can_be_reset() {
    $cell = $this->world->add_cell(0, 0);
    $this->world->tick = 100;
    $this->assertFalse(empty($this->world->cells));
    $this->world->reset();
    $this->assertEqual($this->world->tick, 0);
    $this->assertTrue(empty($this->world->cells));
  }

  function test_has_boundaries() {
    $cell1 = $this->world->add_cell(0, 0);
    $cell2 = $this->world->add_cell(5, 5);
    $boundaries = $this->world->boundaries();
    $this->assertEqual($boundaries['x']['min'], 0);
    $this->assertEqual($boundaries['x']['max'], 5);
    $this->assertEqual($boundaries['y']['min'], 0);
    $this->assertEqual($boundaries['y']['max'], 5);
  }

}

class CellTest extends UnitTestCase {

  var $cell;

  function setUp() {
    $this->cell = new Cell(0, 0);
  }

  function test_can_be_initialized() {
    $this->assertEqual(get_class($this->cell), Cell);
    $this->assertEqual($cell->x, 0);
    $this->assertEqual($cell->y, 0);
    $this->assertEqual($cell->dead, false);
    $this->assertEqual($cell->next_action, null);
  }

  function test_can_initialize_a_dead_cell() {
    $other_cell = new Cell(0, 0, true);
    $this->assertTrue($other_cell->dead);
  }

  function test_should_print_out_according_to_its_state() {
    $this->assertEqual($this->cell->to_char(), 'o');

    $this->cell->dead = true;
    $this->assertEqual($this->cell->to_char(), ' ');
  }

}

class RulesTest extends UnitTestCase {

  var $world;

  function setUp() {
    $this->world = new World;
  }

  // Rule #1: Any live cell with fewer than two live neighbours dies, as if caused by under-population
  function test_rule_1_killed_by_underpopulation() {
    $cell1 = $this->world->add_cell(0, 0);
    $this->world->tick();
    $this->assertTrue($cell1->dead);

    $this->world->reset();

    $cell1 = $this->world->add_cell(0, 0);
    $cell2 = $this->world->add_cell(0, 1);
    $this->world->tick();
    $this->assertTrue($cell1->dead);
  }

  // Rule #2: Any live cell with two or three live neighbours lives on to the next generation
  function test_rule_2_lives_with_two_or_three_neighbours() {
    $cell1 = $this->world->add_cell(0, 0);
    $cell2 = $this->world->add_cell(0, 1);
    $cell3 = $this->world->add_cell(1, 0);

    $this->world->tick();
    $this->assertFalse($cell1->dead);

    $this->world->reset();

    $cell1 = $this->world->add_cell(0, 0);
    $cell2 = $this->world->add_cell(0, 1);
    $cell3 = $this->world->add_cell(1, 0);
    $cell4 = $this->world->add_cell(-1, 0);
    $this->world->tick();
    $this->assertFalse($cell1->dead);
  }

  // Rule #3: Any live cell with more than three live neighbours dies, as if by overcrowding
  function test_rule_3_killed_by_overpopulation() {
    $cell1 = $this->world->add_cell(0, 0);
    $cell2 = $this->world->add_cell(0, 1);
    $cell3 = $this->world->add_cell(1, 0);
    $cell4 = $this->world->add_cell(0, -1);
    $cell5 = $this->world->add_cell(-1, 0);
    $this->world->tick();
    $this->assertTrue($cell1->dead);
  }

  // Rule #4: Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction
  function test_rule_4_revive_dead_cells_with_three_neighbours() {
    $cell1 = $this->world->add_cell(0, 0, true);
    $cell2 = $this->world->add_cell(0, 1);
    $cell3 = $this->world->add_cell(1, 0);
    $cell4 = $this->world->add_cell(1, 1);
    $this->world->tick();
    $this->assertFalse($cell1->dead);
  }

}

?>