WITH neighbour_counts AS (
  SELECT
    base.x,
    base.y,
    COUNT(c.x) AS alive_neighbours
  FROM cells base
  LEFT JOIN neighbours n ON n.cell_x = base.x AND n.cell_y = base.y
  LEFT JOIN cells c ON n.neighbour_x = c.x AND n.neighbour_y = c.y AND c.alive = 1
  GROUP BY base.x, base.y
)
UPDATE cells
SET next_state = CASE
  WHEN cells.alive = 0 AND nc.alive_neighbours = 3 THEN 1
  WHEN cells.alive = 1 AND nc.alive_neighbours IN (2, 3) THEN 1
  ELSE 0
END
FROM neighbour_counts nc
WHERE cells.x = nc.x AND cells.y = nc.y;

UPDATE cells
SET alive = next_state;
