pub struct Cell {
    pub x: usize,
    pub y: usize,
    pub alive: bool,
    pub next_state: bool,
    pub neighbours: Vec<*const Cell>,
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
        //     .copied()
        //     .filter(|ptr| unsafe { (**ptr).alive })
        //     .count()

        // The following was the fastest method
        let mut count = 0;
        for ptr in self.neighbours.iter().copied() {
            unsafe {
                if (*ptr).alive {
                    count += 1;
                }
            }
        }
        count
    }
}
