use std::collections::HashMap;
use rand::Rng;

pub struct World<'a> {
  width: u32,
  height: u32,
  pub tick: u32,
  cells: HashMap<String, Cell<'a>>,
  cached_directions: [[i8; 2]; 8],
}

impl<'a> World<'a> {

  pub fn new(width: u32, height: u32) -> World<'a> {
    let mut world = World {
      width,
      height,
      tick: 0,
      cells: HashMap::new(),
      cached_directions: [
        [-1, 1],  [0, 1],  [1, 1], // above
        [-1, 0],           [1, 0], // sides
        [-1, -1], [0, -1], [1, -1] // below
      ],
    };

    world.populate_cells();
    world.prepopulate_neighbours();

    world
  }

  pub fn _tick(&'a mut self) {
    // First determine the action for all cells
    for (_key,mut cell) in self.cells {
      let alive_neighbours = self.alive_neighbours_around(&mut cell);
      if !cell.alive && alive_neighbours == 3 {
        cell.next_state = Some(1);
      } else if alive_neighbours < 2 || alive_neighbours > 3 {
        cell.next_state = Some(0);
      }
    }

    // Then execute the determined action for all cells
    for (_key,mut cell) in self.cells {
      if cell.next_state == Some(1) {
        cell.alive = true;
      } else if cell.next_state == Some(0) {
        cell.alive = false;
      }
    }

    self.tick += 1;
  }

  // Implement first using string concatenation. Then implement any
  // special string builders, and use whatever runs the fastest
  pub fn render(&'a self) -> String {
    let mut rendering = String::new();
    for y in 0..self.height {
      for x in 0..self.width {
        // unwrap pulls the Cell out of an Option<>
        let cell = self.cell_at(x, y).unwrap();
        rendering += &cell.to_char().to_string();
      }
      rendering += "\n";
    }
    rendering
  }

  fn populate_cells(&'a mut self) {
    for y in 0..self.height {
      for x in 0..self.width {
        let alive = rand::thread_rng().gen::<f32>() <= 0.2;
        self.add_cell(x, y, alive);
      }
    }
  }

  fn prepopulate_neighbours(&'a mut self) {
    for (_key,cell) in self.cells {
      self.neighbours_around(&mut cell);
    }
  }

  fn add_cell(&'a mut self, x: u32, y: u32, alive: bool) -> &Cell<'a> {
    // TODO: Custom exceptions

    let cell = Cell::new(x, y, alive);
    let key = String::from(format!("{}-{}", x, y));
    self.cells.insert(key, cell);
    // unwrap pulls the Cell out of an Option<>
    &self.cell_at(x, y).unwrap()
  }

  fn cell_at(&'a self, x: u32, y: u32) -> Option<&Cell<'a>> {
    let key = String::from(format!("{}-{}", x, y));
    self.cells.get(&key)
  }

  fn neighbours_around(&'a self, cell: &'a mut Cell<'a>) -> &'a Vec<&'a Cell<'a>> {
    if cell.neighbours.is_none() { // Must return a boolean
      let mut neighbours: Vec<&Cell<'a>> = Vec::new();
      for set in self.cached_directions.iter() {
        let neighbour = self.cell_at(
          cell.x + set[0] as u32,
          cell.y + set[1] as u32,
        );

        if neighbour.is_some() {
          // unwrap pulls the Cell out of an Option<>
          neighbours.push(neighbour.unwrap());
        }
      }
      cell.neighbours = Some(neighbours);
    }

    // unwrap pulls the Cell out of an Option<>
    cell.neighbours.as_ref().unwrap()
  }

  // Implement first using filter/lambda if available. Then implement
  // foreach and for. Retain whatever implementation runs the fastest
  fn alive_neighbours_around(&'a self, cell: &'a mut Cell<'a>) -> u8 {
    let mut alive_neighbours = 0 as u8;
    let neighbours = self.neighbours_around(cell);
    for i in 0..neighbours.len() {
      let neighbour = neighbours[i];
      if neighbour.alive {
        alive_neighbours += 1;
      }
    }
    alive_neighbours
  }

}

struct Cell<'a> {
  x: u32,
  y: u32,
  alive: bool,
  next_state: Option<u8>,
  neighbours: Option<Vec<&'a Cell<'a>>>,
}

impl<'a> Cell<'a> {

  pub fn new(x: u32, y: u32, alive: bool) -> Cell<'a> {
    let cell = Cell {
      x,
      y,
      alive,
      next_state: None,
      neighbours: None,
    };

    cell
  }

  pub fn to_char(&'a self) -> char {
    if self.alive { 'o' } else { ' ' }
  }

}
