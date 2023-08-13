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
end
