use std::env;
use std::time::Instant;

use crate::world::World;

pub struct Play;

impl Play {
    const WORLD_WIDTH: u32 = 150;
    const WORLD_HEIGHT: u32 = 40;

    const CLEAR_SCREEN: &str = "\x1b[?2026h\x1b[H\x1b[2J";
    const SHOW_SCREEN: &str = "\x1b[?2026l";

    pub fn run() {
        let mut world = World::new(Self::WORLD_WIDTH, Self::WORLD_HEIGHT);

        let minimal = env::var("MINIMAL").is_ok_and(|value| value == "1");

        if !minimal {
            println!("{}", world.render());
        }

        let mut total_tick: f64 = 0.0;
        let mut lowest_tick: f64 = f64::INFINITY;
        let mut total_render: f64 = 0.0;
        let mut lowest_render: f64 = f64::INFINITY;

        loop {
            let tick_start = Instant::now();
            world.tick();
            let tick_time = tick_start.elapsed().as_nanos() as f64;
            total_tick += tick_time;
            lowest_tick = lowest_tick.min(tick_time);
            let avg_tick = total_tick / world.tick as f64;

            let render_start = Instant::now();
            let rendered = world.render();
            let render_time = render_start.elapsed().as_nanos() as f64;
            total_render += render_time;
            lowest_render = lowest_render.min(render_time);
            let avg_render = total_render / world.tick as f64;

            if !minimal {
                print!("{}", Self::CLEAR_SCREEN);
            }

            println!(
                "#{} - World Tick (L: {:.3}; A: {:.3}) - Rendering (L: {:.3}; A: {:.3})",
                world.tick,
                Self::_f(lowest_tick),
                Self::_f(avg_tick),
                Self::_f(lowest_render),
                Self::_f(avg_render),
            );

            if !minimal {
                println!("{rendered}{}", Self::SHOW_SCREEN);
            }
        }
    }

    fn _f(value: f64) -> f64 {
        // nanoseconds -> milliseconds
        value / 1_000_000.0
    }
}
