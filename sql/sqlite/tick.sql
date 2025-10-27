UPDATE cells
SET next_state = CASE
  WHEN alive = 0 AND (
    SELECT COALESCE(COUNT(*), 0)
    FROM neighbors n
    INNER JOIN cells c ON n.neighbor_x = c.x AND n.neighbor_y = c.y
    WHERE n.cell_x = cells.x AND n.cell_y = cells.y AND c.alive = 1
  ) = 3 THEN 1

  WHEN alive = 1 AND (
    SELECT COALESCE(COUNT(*), 0)
    FROM neighbors n
    INNER JOIN cells c ON n.neighbor_x = c.x AND n.neighbor_y = c.y
    WHERE n.cell_x = cells.x AND n.cell_y = cells.y AND c.alive = 1
  ) IN (2, 3) THEN 1

  ELSE 0
END;

UPDATE cells
SET alive = next_state;
