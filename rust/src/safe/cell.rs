use std::cell::RefCell;
use std::rc::Weak;

pub struct Cell {
    pub x: usize,
    pub y: usize,
    pub alive: bool,
    pub next_state: bool,
    pub neighbours: Vec<Weak<RefCell<Cell>>>,
}

impl Cell {
    pub fn new(x: usize, y: usize, alive: bool) -> Self {
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

    // Implement first using filter/lambda if available. Then implement
    // foreach and for. Use whatever implementation runs the fastest
    pub fn alive_neighbours(&self) -> usize {
        // The following works but is slower
        // self.neighbours
        //     .iter()
        //     .filter_map(|weak| weak.upgrade())
        //     .filter(|rc| rc.borrow().alive)
        //     .count()

        // The following was the fastest method
        let mut count = 0;
        for weak in &self.neighbours {
            if let Some(rc) = weak.upgrade() {
                let nb = rc.borrow();
                if nb.alive {
                    count += 1;
                }
            }
        }
        count
    }
}
