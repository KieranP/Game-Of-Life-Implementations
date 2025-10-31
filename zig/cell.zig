const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

pub const Cell = struct {
    x: usize,
    y: usize,
    alive: bool,
    next_state: bool,
    neighbours: ArrayList(*Cell),

    pub fn init(allocator: Allocator, x: usize, y: usize, alive: bool) !*Cell {
        const cell = try allocator.create(Cell);
        cell.x = x;
        cell.y = y;
        cell.alive = alive;
        cell.next_state = false;
        cell.neighbours = ArrayList(*Cell){};
        return cell;
    }

    pub fn deinit(self: *Cell, allocator: Allocator) void {
        self.neighbours.deinit(allocator);
    }

    pub fn to_char(self: *const Cell) u8 {
        return if (self.alive) 'o' else ' ';
    }

    // Implement first using filter/lambda if available. Then implement
    // foreach and for. Use whatever implementation runs the fastest
    pub fn alive_neighbours(self: *const Cell) usize {
        // The following was the fastest method
        var count: usize = 0;
        for (self.neighbours.items) |neighbour| {
            if (neighbour.alive) {
                count += 1;
            }
        }
        return count;

        // The following works and is the same speed
        // var count: usize = 0;
        // var i: usize = 0;
        // while (i < self.neighbours.items.len) : (i += 1) {
        //     if (self.neighbours.items[i].alive) {
        //         count += 1;
        //     }
        // }
        // return count;
    }
};
