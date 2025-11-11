pub struct Cell {
    pub x: u32,
    pub y: u32,
    pub alive: bool,
    pub next_state: bool,
    pub neighbours: Vec<*const Cell>,
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
        //     .copied()
        //     .filter(|ptr| unsafe { (**ptr).alive })
        //     .count()

        // The following is the fastest
        let mut alive_neighbours = 0;
        for ptr in self.neighbours.iter().copied() {
            unsafe {
                if (*ptr).alive {
                    alive_neighbours += 1;
                }
            }
        }
        alive_neighbours

        // The following is about the same speed
        // let mut alive_neighbours = 0;
        // let count = self.neighbours.len();
        // for i in 0..count {
        //     let ptr = self.neighbours[i];
        //     unsafe {
        //         if (*ptr).alive {
        //             alive_neighbours += 1;
        //         }
        //     }
        // }
        // alive_neighbours
    }
}
