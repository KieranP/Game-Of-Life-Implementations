use crate::cell::Cell;
use rand::Rng;
use std::collections::HashMap;
use std::error::Error;
use std::fmt;

const DIRECTIONS: [(isize, isize); 8] = [
    // above
    (-1, 1),
    (0, 1),
    (1, 1),
    // sides
    (-1, 0),
    (1, 0),
    // below
    (-1, -1),
    (0, -1),
    (1, -1),
];

#[derive(Debug)]
pub struct LocationOccupied(u32, u32);
impl Error for LocationOccupied {}
impl fmt::Display for LocationOccupied {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "LocationOccupied({},{})", self.0, self.1)
    }
}

pub struct World {
    pub tick: u32,
    width: u32,
    height: u32,
    cells: HashMap<String, Box<Cell>>,
}

impl World {
    pub fn new(width: u32, height: u32) -> Self {
        let mut world = Self {
            tick: 0,
            width,
            height,
            cells: HashMap::with_capacity((width * height) as usize),
        };

        world.populate_cells();
        world.prepopulate_neighbours();

        world
    }

    pub fn tick(&mut self) {
        // First determine the action for all cells
        for boxed in self.cells.values_mut() {
            let cell: &mut Cell = &mut *boxed;
            let alive_neighbours = cell.alive_neighbours();
            if !cell.alive && alive_neighbours == 3 {
                cell.next_state = true;
            } else if alive_neighbours < 2 || alive_neighbours > 3 {
                cell.next_state = false;
            } else {
                cell.next_state = cell.alive;
            }
        }

        // Then execute the determined action for all cells
        for boxed in self.cells.values_mut() {
            let cell: &mut Cell = &mut *boxed;
            cell.alive = cell.next_state;
        }

        self.tick += 1;
    }

    pub fn render(&self) -> String {
        let render_size = (self.width * self.height + self.height) as usize;

        // The following is the slowest
        // let mut rendering = String::new();
        // for y in 0..self.height {
        //     for x in 0..self.width {
        //         if let Some(cell) = self.cell_at(x, y) {
        //             rendering.push_str(&cell.to_char().to_string());
        //         }
        //     }
        //     rendering.push('\n');
        // }
        // rendering

        // The following is slower
        // let mut rendering: Vec<char> = Vec::with_capacity(render_size);
        // for y in 0..self.height {
        //     for x in 0..self.width {
        //         if let Some(cell) = self.cell_at(x, y) {
        //             rendering.push(cell.to_char());
        //         }
        //     }
        //     rendering.push('\n');
        // }
        // String::from_iter(rendering)

        // The following is the fastest
        let mut rendering = String::with_capacity(render_size);
        for y in 0..self.height {
            for x in 0..self.width {
                if let Some(cell) = self.cell_at(x, y) {
                    rendering.push(cell.to_char());
                }
            }
            rendering.push('\n');
        }
        rendering

        // The following is slower
        // let mut buffer = vec![0u8; render_size];
        // let mut idx: usize = 0;
        // for y in 0..self.height {
        //     for x in 0..self.width {
        //         if let Some(cell) = self.cell_at(x, y) {
        //             buffer[idx] = cell.to_char() as u8;
        //         }
        //         idx += 1;
        //     }
        //     buffer[idx] = b'\n';
        //     idx += 1;
        // }
        // String::from_utf8(buffer).unwrap()
    }

    fn cell_at(&self, x: u32, y: u32) -> Option<&Cell> {
        let key = format!("{}-{}", x, y);
        self.cells.get(&key).map(|b| &**b)
    }

    fn populate_cells(&mut self) {
        let mut rng = rand::rng();
        for y in 0..self.height {
            for x in 0..self.width {
                let alive = rng.random_bool(0.20);
                let _ = self.add_cell(x, y, alive);
            }
        }
    }

    fn add_cell(&mut self, x: u32, y: u32, alive: bool) -> bool {
        let existing = self.cell_at(x, y);
        if existing.is_some() {
            panic!("{}", LocationOccupied(x, y));
        }

        let key = format!("{}-{}", x, y);
        let cell = Box::new(Cell::new(x, y, alive));
        self.cells.insert(key, cell);
        true
    }

    fn prepopulate_neighbours(&mut self) {
        // Cannot use self.cells.get inside of self.cells.values_mut() because
        // Rust detects that the cell could changed in between those calls, and
        // is therefore unsafe. Workaround by making a temporary map of
        // (x,y) -> raw pointer for reference later.
        let ptrs: HashMap<(u32, u32), *const Cell> = self
            .cells
            .iter()
            .map(|(_k, v)| ((v.x, v.y), &**v as *const Cell))
            .collect();

        for boxed in self.cells.values_mut() {
            let cell: &mut Cell = &mut *boxed;
            let x = cell.x as isize;
            let y = cell.y as isize;

            for &(rel_x, rel_y) in &DIRECTIONS {
                let nx = x + rel_x;
                let ny = y + rel_y;
                if nx < 0 || ny < 0 {
                    continue; // Out of bounds
                }

                let ux = nx as u32;
                let uy = ny as u32;
                if ux >= self.width || uy >= self.height {
                    continue; // Out of bounds
                }

                if let Some(ptr) = ptrs.get(&(ux, uy)) {
                    cell.neighbours.push(*ptr);
                }
            }
        }
    }
}
