$:.push(File.dirname(__FILE__))

require 'rubygems'
require 'rspec'
require 'game'

describe "Conway's Game of Life" do

  describe World do

    let(:world) { World.new }

    it "can be initialized" do
      world.should be_instance_of World
      world.cells.should be_instance_of Hash
      world.neighbours.should be_instance_of Hash
    end

    it "cannot add cells if location already contains a cell" do
      other_cell = world.add_cell(0, 0)
      expect { world.add_cell(0, 0) }.to raise_error World::LocationOccupied
    end

    it "can add cells" do
      cell = world.add_cell(0, 0)
      cell.should be_instance_of Cell
      cell.x.should eq 0
      cell.y.should eq 0
    end

    it "resets neighbours data when adding cells" do
      cell1 = world.add_cell(0, 0)
      cell2 = world.add_cell(0, 1)
      world.neighbours_at(0, 0).should include cell2
      world.neighbours.keys.should_not be_empty

      cell2 = world.add_cell(1, 0)
      world.neighbours.keys.should be_empty
    end

    it "can retrieve cells at a given location" do
      cell = world.add_cell(0, 0)
      world.cell_at(0, 0).should eq cell
    end

    it "can retrieve neighbours for a given location" do
      cell = world.add_cell(0, 1)
      world.neighbours_at(0, 0).should include cell

      cell = world.add_cell(1, 1, true)
      world.neighbours_at(0, 0).should include cell

      cell = world.add_cell(1, 0)
      world.neighbours_at(0, 0).should include cell

      cell = world.add_cell(1, -1, true)
      world.neighbours_at(0, 0).should include cell

      cell = world.add_cell(0, -1)
      world.neighbours_at(0, 0).should include cell

      cell = world.add_cell(-1, -1, true)
      world.neighbours_at(0, 0).should include cell

      cell = world.add_cell(-1, 0)
      world.neighbours_at(0, 0).should include cell

      cell = world.add_cell(-1, 1, true)
      world.neighbours_at(0, 0).should include cell
    end

    it "can retrieve alive neighbours for a given location" do
      cell1 = world.add_cell(0, 0)
      cell2 = world.add_cell(0, 1)
      cell3 = world.add_cell(1, 0, true)
      world.alive_neighbours_at(0, 0).should include cell2
      world.alive_neighbours_at(0, 0).should_not include cell3
    end

    it "can tick along" do
      tick = world.tick
      world.tick!
      world.tick.should eq (tick + 1)
    end

    it "can be reset" do
      cell = world.add_cell(0, 0)
      world.tick = 100
      world.cells.values.should include cell
      world.reset!
      world.tick.should eq 0
      world.cells.should be_empty
    end

    it "has bounaries" do
      cell1 = world.add_cell(0, 0)
      cell2 = world.add_cell(5, 5)
      world.boundaries[:x][:min].should eq 0
      world.boundaries[:x][:max].should eq 5
      world.boundaries[:y][:min].should eq 0
      world.boundaries[:y][:max].should eq 5
    end

  end

  describe Cell do

    let(:world) { World.new }
    let(:cell) { world.add_cell(0, 0) }

    it "can be initialized" do
      cell.should be_instance_of Cell
      cell.x.should eq 0
      cell.y.should eq 0
      cell.dead.should be_false
      cell.next_action.should be_nil
    end

    it "can initialize a dead cell" do
      other_cell = world.add_cell(0, 0, true)
      other_cell.dead.should be_true
    end

    it "can store a next action" do
      cell.next_action = :kill!
      cell.next_action.should eq :kill!
    end

    it "should print out according to it's state" do
      cell.to_char.should eq 'o'

      cell.dead = true
      cell.to_char.should eq ' '
    end

  end

  describe "Rules" do

    let(:world) { World.new }

    it "Rule #1: Any live cell with fewer than two live neighbours dies, as if caused by under-population" do
      cell1 = world.add_cell(0, 0)
      world.tick!
      cell1.dead.should be_true

      world.reset!

      cell1 = world.add_cell(0, 0)
      cell2 = world.add_cell(0, 1)
      world.tick!
      cell1.dead.should be_true
    end

    it "Rule #2: Any live cell with two or three live neighbours lives on to the next generation" do
      cell1 = world.add_cell(0, 0)
      cell2 = world.add_cell(0, 1)
      cell3 = world.add_cell(1, 0)

      world.tick!
      cell1.dead.should be_false

      world.reset!

      cell1 = world.add_cell(0, 0)
      cell2 = world.add_cell(0, 1)
      cell3 = world.add_cell(1, 0)
      cell4 = world.add_cell(-1, 0)
      world.tick!
      cell1.dead.should be_false
    end

    it "Rule #3: Any live cell with more than three live neighbours dies, as if by overcrowding" do
      cell1 = world.add_cell(0, 0)
      cell2 = world.add_cell(0, 1)
      cell3 = world.add_cell(1, 0)
      cell4 = world.add_cell(0, -1)
      cell5 = world.add_cell(-1, 0)
      world.tick!
      cell1.dead.should be_true
    end

    it "Rule #4: Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction" do
      cell1 = world.add_cell(0, 0, true)
      cell2 = world.add_cell(0, 1)
      cell3 = world.add_cell(1, 0)
      world.tick!
      cell1.dead.should be_true

      cell4 = world.add_cell(1, 1)
      world.tick!
      cell1.dead.should be_true
    end

  end

end
