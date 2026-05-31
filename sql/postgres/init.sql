DROP TABLE IF EXISTS cells;
DROP TABLE IF EXISTS neighbours;

CREATE TABLE cells (
  x INTEGER NOT NULL,
  y INTEGER NOT NULL,
  alive INTEGER NOT NULL DEFAULT 0,
  next_state INTEGER DEFAULT NULL,
  PRIMARY KEY (x, y)
);

CREATE TABLE neighbours (
  cell_x INTEGER NOT NULL,
  cell_y INTEGER NOT NULL,
  neighbour_x INTEGER NOT NULL,
  neighbour_y INTEGER NOT NULL,
  PRIMARY KEY (cell_x, cell_y, neighbour_x, neighbour_y),
  FOREIGN KEY (cell_x, cell_y) REFERENCES cells(x, y),
  FOREIGN KEY (neighbour_x, neighbour_y) REFERENCES cells(x, y)
);

CREATE INDEX idx_neighbours_cell ON neighbours(cell_x, cell_y);

INSERT INTO cells (x, y, alive)
SELECT
  gx,
  gy,
  CASE WHEN random(0, 99) <= 20 THEN 1 ELSE 0 END
FROM generate_series(0, 149) gx, generate_series(0, 39) gy;

INSERT INTO neighbours (cell_x, cell_y, neighbour_x, neighbour_y)
SELECT
  c1.x AS cell_x,
  c1.y AS cell_y,
  c2.x AS neighbour_x,
  c2.y AS neighbour_y
FROM cells c1
INNER JOIN cells c2
  ON c2.x BETWEEN c1.x - 1 AND c1.x + 1
  AND c2.y BETWEEN c1.y - 1 AND c1.y + 1
  AND NOT (c2.x = c1.x AND c2.y = c1.y);
