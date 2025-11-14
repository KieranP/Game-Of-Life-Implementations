use std::cell::RefCell;
use std::rc::Weak;

pub struct Cell {
    pub x: u32,
    pub y: u32,
    pub alive: bool,
    pub next_state: bool,
    pub neighbours: Vec<Weak<RefCell<Cell>>>,
}

impl Cell {
    pub fn new(x: u32, y: u32, alive: bool) -> Self {
        Self {
            x,
            y,
            alive,
            next_state: false,
            neighbours: Vec::new(),
        }
    }

    pub fn to_char(&self) -> char {
        if self.alive { 'o' } else { ' ' }
    }

    pub fn alive_neighbours(&self) -> u32 {
        // The following is slower
        // self.neighbours
        //     .iter()
        //     .filter_map(|weak| weak.upgrade())
        //     .filter(|rc| rc.borrow().alive)
        //     .count()

        // The following is the fastest
        let mut alive_neighbours = 0;
        for weak in &self.neighbours {
            if let Some(rc) = weak.upgrade() {
                let nb = rc.borrow();
                if nb.alive {
                    alive_neighbours += 1;
                }
            }
        }
        alive_neighbours

        // The following is about the same speed
        // let mut alive_neighbours = 0;
        // let count = self.neighbours.len();
        // for i in 0..count {
        //     if let Some(rc) = self.neighbours[i].upgrade() {
        //         let nb = rc.borrow();
        //         if nb.alive {
        //             alive_neighbours += 1;
        //         }
        //     }
        // }
        // alive_neighbours
    }
}
