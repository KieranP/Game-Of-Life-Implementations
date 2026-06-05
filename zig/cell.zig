const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

pub const Cell = struct {
    x: u32,
    y: u32,
    alive: bool,
    next_state: ?bool = null,
    neighbours: ArrayList(*Cell),

    pub fn init(allocator: Allocator, x: u32, y: u32, alive: bool) !*Cell {
        const cell = try allocator.create(Cell);
        cell.* = .{ .x = x, .y = y, .alive = alive, .neighbours = .empty };
        return cell;
    }

    pub fn deinit(self: *Cell, allocator: Allocator) void {
        self.neighbours.deinit(allocator);
    }

    pub fn toChar(self: *const Cell) u8 {
        return if (self.alive) 'o' else ' ';
    }

    pub fn aliveNeighbours(self: *const Cell) u32 {
        // The following is the fastest
        var alive_count: u32 = 0;
        for (self.neighbours.items) |neighbour| {
            if (neighbour.alive) {
                alive_count += 1;
            }
        }
        return alive_count;

        // The following is about the same speed
        // var alive_count: u32 = 0;
        // const count = self.neighbours.items.len;
        // var i: u32 = 0;
        // while (i < count) : (i += 1) {
        //     if (self.neighbours.items[i].alive) {
        //         alive_count += 1;
        //     }
        // }
        // return alive_count;
    }
};
