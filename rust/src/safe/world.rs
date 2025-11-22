use crate::cell::Cell;
use rand::Rng;
use std::cell::RefCell;
use std::collections::HashMap;
use std::error::Error;
use std::fmt;
use std::rc::Rc;

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
    cells: HashMap<String, Rc<RefCell<Cell>>>,
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

    pub fn render(&self) -> String {
        let render_size = (self.width * self.height + self.height) as usize;

        // The following is slower
        // let mut rendering: Vec<char> = Vec::with_capacity(render_size);
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

        // The following is the fastest
        let mut rendering = String::with_capacity(render_size);
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
    }

    fn cell_at(&self, x: u32, y: u32) -> Option<Rc<RefCell<Cell>>> {
        let key = format!("{}-{}", x, y);
        self.cells.get(&key).cloned()
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
        let cell = Rc::new(RefCell::new(Cell::new(x, y, alive)));
        self.cells.insert(key, cell);
        true
    }

    fn prepopulate_neighbours(&mut self) {
        for rc in self.cells.values() {
            let mut cell = rc.borrow_mut();
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

                if let Some(neighbour_rc) = self.cell_at(ux, uy) {
                    cell.neighbours.push(Rc::downgrade(&neighbour_rc));
                }
            }
        }
    }
}
