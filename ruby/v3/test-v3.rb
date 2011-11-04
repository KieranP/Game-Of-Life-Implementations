$:.push(File.dirname(__FILE__))

require 'rubygems'
require 'rspec'
require 'game-v3'

describe "Conway's Game of Life" do

  describe World do

    let(:world) { World.new }

    it "can be initialized" do
      world.should be_instance_of World
      world.cells.should be_instance_of Hash
    end

    it "can add cells" do
      cell = world.add_cell(x: 0, y: 0)
      cell.should be_instance_of Cell
      cell.x.should eq 0
      cell.y.should eq 0
    end

    it "cannot add cells if location already contains a cell" do
      other_cell = world.add_cell(x: 0, y: 0)
      expect { world.add_cell(x: 0, y: 0) }.to raise_error World::LocationOccupied
    end

    it "can retrieve cells at a given location" do
      cell = world.add_cell(x: 0, y: 0)
      world.cell_at(x: 0, y: 0).should eq cell
    end

    it "detects alive neighbours at given location" do
      # North
      other_cell = world.add_cell(x: 0, y: 1)
      world.alive_neighbours_at(x: 0, y: 0).should include other_cell

      # North-East
      other_cell = world.add_cell(x: 1, y: 1)
      world.alive_neighbours_at(x: 0, y: 0).should include other_cell

      # East
      other_cell = world.add_cell(x: 1, y: 0)
      world.alive_neighbours_at(x: 0, y: 0).should include other_cell

      # South-East
      other_cell = world.add_cell(x: 1, y: -1)
      world.alive_neighbours_at(x: 0, y: 0).should include other_cell

      # South
      other_cell = world.add_cell(x: 0, y: -1)
      world.alive_neighbours_at(x: 0, y: 0).should include other_cell

      # South-West
      other_cell = world.add_cell(x: -1, y: -1)
      world.alive_neighbours_at(x: 0, y: 0).should include other_cell

      # West
      other_cell = world.add_cell(x: -1, y: 0)
      world.alive_neighbours_at(x: 0, y: 0).should include other_cell

      # North-West
      other_cell = world.add_cell(x: -1, y: 1)
      world.alive_neighbours_at(x: 0, y: 0).should include other_cell
    end

    it "does not detect dead neighbours" do
      cell2 = world.add_cell(x: 0, y: 1)
      cell3 = world.add_cell(x: 1, y: 0)
      cell4 = world.add_cell(x: 0, y: -1)
      cell5 = world.add_cell(x: -1, y: 0, dead: true)
      world.alive_neighbours_at(x: 0, y: 0).should_not include cell5
    end

    it "can tick along" do
      tick = world.tick
      world.tick!
      world.tick.should eq (tick + 1)
    end

    it "can be reset" do
      cell = world.add_cell(x: 0, y: 0)
      world.tick = 100
      world.cells.values.should include cell
      world.reset!
      world.tick.should eq 0
      world.cells.should be_empty
    end

    it "has bounaries" do
      cell1 = world.add_cell(x: 0, y: 0)
      cell2 = world.add_cell(x: 5, y: 5)
      world.boundaries[:x][:min].should eq -3
      world.boundaries[:x][:max].should eq 8
      world.boundaries[:y][:min].should eq -3
      world.boundaries[:y][:max].should eq 8
    end

  end

  describe Cell do

    let(:world) { World.new }
    let(:cell) { world.add_cell(x: 0, y: 0) }

    it "can be initialized" do
      cell.should be_instance_of Cell
      cell.x.should eq 0
      cell.y.should eq 0
      cell.dead.should be_false
      cell.next_action.should be_nil
    end

    it "can initialize a dead cell" do
      other_cell = world.add_cell(x: 0, y: 0, dead: true)
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
      cell1 = world.add_cell(x: 0, y: 0)
      world.tick!
      cell1.dead.should be_true

      world.reset!

      cell1 = world.add_cell(x: 0, y: 0)
      cell2 = world.add_cell(x: 0, y: 1)
      world.tick!
      cell1.dead.should be_true
    end

    it "Rule #2: Any live cell with two or three live neighbours lives on to the next generation" do
      cell1 = world.add_cell(x: 0, y: 0)
      cell2 = world.add_cell(x: 0, y: 1)
      cell3 = world.add_cell(x: 1, y: 0)

      world.tick!
      cell1.dead.should be_false

      world.reset!

      cell1 = world.add_cell(x: 0, y: 0)
      cell2 = world.add_cell(x: 0, y: 1)
      cell3 = world.add_cell(x: 1, y: 0)
      cell4 = world.add_cell(x: -1, y: 0)
      world.tick!
      cell1.dead.should be_false
    end

    it "Rule #3: Any live cell with more than three live neighbours dies, as if by overcrowding" do
      cell1 = world.add_cell(x: 0, y: 0)
      cell2 = world.add_cell(x: 0, y: 1)
      cell3 = world.add_cell(x: 1, y: 0)
      cell4 = world.add_cell(x: 0, y: -1)
      cell5 = world.add_cell(x: -1, y: 0)
      world.tick!
      cell1.dead.should be_true
    end

    it "Rule #4: Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction" do
      cell1 = world.add_cell(x: 0, y: 0, dead: true)
      cell2 = world.add_cell(x: 0, y: 1)
      cell3 = world.add_cell(x: 1, y: 0)
      world.tick!
      cell1.dead.should be_true

      cell4 = world.add_cell(x: 1, y: 1)
      world.tick!
      cell1.dead.should be_true
    end

  end

end
