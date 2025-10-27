DROP TABLE IF EXISTS cells;
DROP TABLE IF EXISTS neighbors;

CREATE TABLE cells (
  x INTEGER NOT NULL,
  y INTEGER NOT NULL,
  alive INTEGER NOT NULL DEFAULT 0,
  next_state INTEGER DEFAULT NULL,
  PRIMARY KEY (x, y)
);

CREATE TABLE neighbors (
  cell_x INTEGER NOT NULL,
  cell_y INTEGER NOT NULL,
  neighbor_x INTEGER NOT NULL,
  neighbor_y INTEGER NOT NULL,
  PRIMARY KEY (cell_x, cell_y, neighbor_x, neighbor_y),
  FOREIGN KEY (cell_x, cell_y) REFERENCES cells(x, y),
  FOREIGN KEY (neighbor_x, neighbor_y) REFERENCES cells(x, y)
);

CREATE INDEX idx_neighbors_cell ON neighbors(cell_x, cell_y);

WITH RECURSIVE
  xs(x) AS (
    SELECT 0
    UNION ALL
    SELECT x + 1 FROM xs WHERE x < 150 - 1
  ),
  ys(y) AS (
    SELECT 0
    UNION ALL
    SELECT y + 1 FROM ys WHERE y < 40 - 1
  )
INSERT INTO cells (x, y, alive)
SELECT
  xs.x,
  ys.y,
  CASE WHEN (floor(random() * 100)::int) <= 20 THEN 1 ELSE 0 END
FROM xs, ys;

INSERT INTO neighbors (cell_x, cell_y, neighbor_x, neighbor_y)
SELECT
  c1.x AS cell_x,
  c1.y AS cell_y,
  c2.x AS neighbor_x,
  c2.y AS neighbor_y
FROM cells c1
INNER JOIN cells c2
  ON c2.x BETWEEN c1.x - 1 AND c1.x + 1
  AND c2.y BETWEEN c1.y - 1 AND c1.y + 1
  AND NOT (c2.x = c1.x AND c2.y = c1.y);
