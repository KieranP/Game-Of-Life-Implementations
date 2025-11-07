use rand::Rng;
use std::cell::RefCell;
use std::collections::HashMap;
use std::rc::Rc;

use crate::cell::Cell;

const DIRECTIONS: [(isize, isize); 8] = [
    (-1, 1),
    (0, 1),
    (1, 1), // above
    (-1, 0),
    (1, 0), // sides
    (-1, -1),
    (0, -1),
    (1, -1), // below
];

#[allow(dead_code)]
pub struct LocationOccupied(usize, usize);

pub struct World {
    pub tick: usize,
    width: usize,
    height: usize,
    cells: HashMap<String, Rc<RefCell<Cell>>>,
}

impl World {
    pub fn new(width: usize, height: usize) -> Self {
        let mut world = Self {
            tick: 0,
            width,
            height,
            cells: HashMap::with_capacity(width * height),
        };

        world.populate_cells();
        world.prepopulate_neighbours();

        world
    }

    pub fn tick(&mut self) {
        // First determine the action for all cells
        for rc in self.cells.values() {
            let mut cell = rc.borrow_mut();
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
        for rc in self.cells.values() {
            let mut cell = rc.borrow_mut();
            cell.alive = cell.next_state;
        }

        self.tick += 1;
    }

    // Implement first using string concatenation. Then implement any
    // special string builders, and use whatever runs the fastest
    pub fn render(&self) -> String {
        let total_size = self.width * self.height + self.height;

        // The following was the fastest method
        let mut rendering = String::with_capacity(total_size);
        for y in 0..self.height {
            for x in 0..self.width {
                if let Some(rc) = self.cell_at(x, y) {
                    let cell = rc.borrow();
                    rendering.push(cell.to_char());
                }
            }
            rendering.push('\n');
        }
        rendering

        // The following works but is slower
        // let mut rendering: Vec<char> = Vec::with_capacity(total_size);
        // for y in 0..self.height {
        //     for x in 0..self.width {
        //         if let Some(rc) = self.cell_at(x, y) {
        //             let cell = rc.borrow();
        //             rendering.push(cell.to_char());
        //         }
        //     }
        //     rendering.push('\n');
        // }
        // String::from_iter(rendering)
    }

    pub fn cell_at(&self, x: usize, y: usize) -> Option<Rc<RefCell<Cell>>> {
        let key = format!("{}-{}", x, y);
        self.cells.get(&key).cloned()
    }

    fn populate_cells(&mut self) {
        let mut rng = rand::rng();
        for y in 0..self.height {
            for x in 0..self.width {
                let alive = rng.random_range(0..=100) <= 20;
                let _ = self.add_cell(x, y, alive);
            }
        }
    }

    pub fn add_cell(&mut self, x: usize, y: usize, alive: bool) -> Result<bool, LocationOccupied> {
        if self.cell_at(x, y).is_some() {
            return Err(LocationOccupied(x, y));
        }

        let key = format!("{}-{}", x, y);
        let cell = Rc::new(RefCell::new(Cell::new(x, y, alive)));
        self.cells.insert(key, cell);
        Ok(true)
    }

    fn prepopulate_neighbours(&mut self) {
        for rc in self.cells.values() {
            let mut cell = rc.borrow_mut();
            let x = cell.x as isize;
            let y = cell.y as isize;

            for &(dx, dy) in &DIRECTIONS {
                let nx = x + dx;
                let ny = y + dy;
                if nx < 0 || ny < 0 {
                    continue;
                }

                let ux = nx as usize;
                let uy = ny as usize;
                if ux >= self.width || uy >= self.height {
                    continue;
                }

                if let Some(neighbour_rc) = self.cell_at(ux, uy) {
                    cell.neighbours.push(Rc::downgrade(&neighbour_rc));
                }
            }
        }
    }
}
