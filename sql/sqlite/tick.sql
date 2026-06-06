-- Only alive cells contribute to neighbour counts and the neighbours relation
-- is symmetric, so scatter +1 from each alive cell (~20% of the board) instead
-- of counting per cell, and only write rows whose state actually changes.
UPDATE cells
SET next_state = 0
WHERE next_state IS DISTINCT FROM 0;

WITH neighbour_counts AS (
  SELECT
    n.neighbour_x AS x,
    n.neighbour_y AS y,
    COUNT(*) AS alive_neighbours
  FROM cells c
  INNER JOIN neighbours n ON n.cell_x = c.x AND n.cell_y = c.y
  WHERE c.alive = 1
  GROUP BY n.neighbour_x, n.neighbour_y
)
UPDATE cells
SET next_state = 1
FROM neighbour_counts nc
WHERE cells.x = nc.x AND cells.y = nc.y
  AND (
    (cells.alive = 0 AND nc.alive_neighbours = 3) OR
    (cells.alive = 1 AND nc.alive_neighbours IN (2, 3))
  );

UPDATE cells
SET alive = next_state
WHERE alive <> next_state;
