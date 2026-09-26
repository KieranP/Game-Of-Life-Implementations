use crate::cell::Cell;
use std::collections::HashMap;
use std::error::Error;
use std::fmt;

#[rustfmt::skip]
const DIRECTIONS: [(isize, isize); 8] = [
    (-1, 1),  (0, 1),  (1, 1),  // above
    (-1, 0),           (1, 0),  // sides
    (-1, -1), (0, -1), (1, -1), // below
];

#[derive(Debug)]
pub struct LocationOccupied(u32, u32);
impl Error for LocationOccupied {}
impl fmt::Display for LocationOccupied {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "LocationOccupied({}-{})", self.0, self.1)
    }
}

pub struct World {
    pub tick: u32,
    width: u32,
    height: u32,
    cells: HashMap<String, *mut Cell>,
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
        for &ptr in self.cells.values() {
            let cell = unsafe { &mut *ptr };
            let alive_neighbours = cell.alive_neighbours();
            if !cell.alive && alive_neighbours == 3 {
                cell.next_state = Some(true);
            } else if alive_neighbours < 2 || alive_neighbours > 3 {
                cell.next_state = Some(false);
            } else {
                cell.next_state = Some(cell.alive);
            }
        }

        // Then execute the determined action for all cells
        for &ptr in self.cells.values() {
            let cell = unsafe { &mut *ptr };
            cell.alive = cell.next_state.unwrap_or(false);
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
        //             let cell_char = unsafe { (*cell).to_char() };
        //             rendering.push_str(&cell_char.to_string());
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
        //             let cell_char = unsafe { (*cell).to_char() };
        //             rendering.push(cell_char);
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
                    let cell_char = unsafe { (*cell).to_char() };
                    rendering.push(cell_char);
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
        //             let cell_char = unsafe { (*cell).to_char() };
        //             buffer[idx] = cell_char as u8;
        //             idx += 1;
        //         }
        //     }
        //     buffer[idx] = b'\n';
        //     idx += 1;
        // }
        // buffer.truncate(idx);
        // String::from_utf8(buffer).unwrap()
    }

    fn make_key(buf: &mut [u8; 24], x: u32, y: u32) -> &str {
        // The following is slower
        // let key = format!("{x}-{y}");
        // buf[..key.len()].copy_from_slice(key.as_bytes());
        // std::str::from_utf8(&buf[..key.len()]).unwrap()

        // The following is slower
        // let key = vec![x.to_string(), y.to_string()].join("-");
        // buf[..key.len()].copy_from_slice(key.as_bytes());
        // std::str::from_utf8(&buf[..key.len()]).unwrap()

        // The following is the fastest
        let mut pos = 0;
        let mut x_buf = itoa::Buffer::new();
        let x_str = x_buf.format(x);
        buf[..x_str.len()].copy_from_slice(x_str.as_bytes());
        pos += x_str.len();
        buf[pos] = b'-';
        pos += 1;
        let mut y_buf = itoa::Buffer::new();
        let y_str = y_buf.format(y);
        buf[pos..pos + y_str.len()].copy_from_slice(y_str.as_bytes());
        pos += y_str.len();
        std::str::from_utf8(&buf[..pos]).unwrap()
    }

    fn cell_at(&self, x: u32, y: u32) -> Option<*mut Cell> {
        let mut buf = [0u8; 24];
        let key = Self::make_key(&mut buf, x, y);

        self.cells.get(key).copied()
    }

    fn populate_cells(&mut self) {
        for y in 0..self.height {
            for x in 0..self.width {
                let alive = rand::random_bool(0.20);
                let _ = self.add_cell(x, y, alive);
            }
        }
    }

    fn add_cell(&mut self, x: u32, y: u32, alive: bool) -> bool {
        let existing = self.cell_at(x, y);
        if existing.is_some() {
            panic!("{}", LocationOccupied(x, y));
        }

        let mut buf = [0u8; 24];
        let key = Self::make_key(&mut buf, x, y).to_owned();

        let cell = Box::into_raw(Box::new(Cell::new(x, y, alive)));
        self.cells.insert(key, cell);
        true
    }

    fn prepopulate_neighbours(&mut self) {
        for &ptr in self.cells.values() {
            let cell = unsafe { &mut *ptr };
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

                if let Some(neighbour) = self.cell_at(ux, uy) {
                    cell.neighbours.push(neighbour);
                }
            }
        }
    }
}

// The cells come from Box::into_raw, so nothing else frees them
impl Drop for World {
    fn drop(&mut self) {
        for &ptr in self.cells.values() {
            drop(unsafe { Box::from_raw(ptr) });
        }
    }
}
