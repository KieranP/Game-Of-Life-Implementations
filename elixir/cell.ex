defmodule Cell do
  defstruct [:x, :y, :alive, :neighbours]

  def new(x, y, alive \\ false) do
    %Cell{
      x: x,
      y: y,
      alive: alive
    }
  end

  def to_char(cell) do
    if cell.alive, do: "o", else: " "
  end

  # Implement first using filter/lambda if available. Then implement
  # foreach and for. Use whatever implementation runs the fastest
  def alive_neighbours(cell, world) do
    neighbours = Map.take(world.cells, cell.neighbours)

    # The following works but is slower
    # Enum.count(neighbours, fn {_key, neighbour} ->
    #   neighbour.alive
    # end)

    # The following was the fastest method
    for {_key, neighbour} <- neighbours, reduce: 0 do
      count ->
        if neighbour.alive do
          count + 1
        else
          count
        end
    end
  end
end
