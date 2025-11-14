const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const StringHashMap = std.StringHashMap;
const Cell = @import("cell.zig").Cell;

const DIRECTIONS = [8][2]i8{
    .{ -1, 1 }, .{ 0, 1 }, .{ 1, 1 }, // above
    .{ -1, 0 }, .{ 1, 0 }, // sides
    .{ -1, -1 }, .{ 0, -1 }, .{ 1, -1 }, // below
};

pub const Errors = error{
    LocationOccupied,
};

pub const World = struct {
    allocator: Allocator,
    tick: u32,
    width: u32,
    height: u32,
    cells: StringHashMap(*Cell),

    pub fn init(allocator: Allocator, width: u32, height: u32) !*World {
        const world = try allocator.create(World);
        world.allocator = allocator;
        world.tick = 0;
        world.width = width;
        world.height = height;
        world.cells = StringHashMap(*Cell).init(allocator);

        try world.populate_cells();
        try world.prepopulate_neighbours();

        return world;
    }

    pub fn deinit(self: *World) void {
        var it = self.cells.iterator();
        while (it.next()) |entry| {
            entry.value_ptr.*.deinit(self.allocator);
            self.allocator.free(entry.key_ptr.*);
            self.allocator.destroy(entry.value_ptr.*);
        }
        self.cells.deinit();
    }

    pub fn _tick(self: *World) void {
        // First determine the action for all cells
        var it = self.cells.valueIterator();
        while (it.next()) |val| {
            const cell = val.*;
            const alive_neighbours = cell.alive_neighbours();
            if (!cell.alive and alive_neighbours == 3) {
                cell.next_state = true;
            } else if (alive_neighbours < 2 or alive_neighbours > 3) {
                cell.next_state = false;
            } else {
                cell.next_state = cell.alive;
            }
        }

        // Then execute the determined action for all cells
        it = self.cells.valueIterator();
        while (it.next()) |val| {
            const cell = val.*;
            cell.alive = cell.next_state;
        }

        self.tick += 1;
    }

    pub fn render(self: *World) ![]const u8 {
        const render_size = self.width * self.height + self.height;

        // The following is about the same speed
        // var rendering = ArrayList(u8){};
        // try rendering.ensureTotalCapacity(self.allocator, render_size);
        // var y: u32 = 0;
        // while (y < self.height) : (y += 1) {
        //     var x: u32 = 0;
        //     while (x < self.width) : (x += 1) {
        //         if (self.cell_at(x, y)) |cell| {
        //             try rendering.append(self.allocator, cell.to_char());
        //         }
        //     }
        //     try rendering.append(self.allocator, '\n');
        // }
        // return rendering.toOwnedSlice(self.allocator);

        // The following is the fastest
        const buffer = try self.allocator.alloc(u8, render_size);
        var idx: u32 = 0;
        var y: u32 = 0;
        while (y < self.height) : (y += 1) {
            var x: u32 = 0;
            while (x < self.width) : (x += 1) {
                if (self.cell_at(x, y)) |cell| {
                    buffer[idx] = cell.to_char();
                }
                idx += 1;
            }
            buffer[idx] = '\n';
            idx += 1;
        }
        return buffer;
    }

    fn cell_at(self: *World, x: u32, y: u32) ?*Cell {
        var key_buf: [32]u8 = undefined;
        const key = std.fmt.bufPrint(&key_buf, "{d}-{d}", .{ x, y }) catch unreachable;
        return self.cells.get(key);
    }

    fn populate_cells(self: *World) !void {
        var y: u32 = 0;
        while (y < self.height) : (y += 1) {
            var x: u32 = 0;
            while (x < self.width) : (x += 1) {
                const random = std.crypto.random.intRangeAtMost(u8, 0, 100);
                const alive = random <= 20;
                _ = try self.add_cell(x, y, alive);
            }
        }
    }

    fn add_cell(self: *World, x: u32, y: u32, alive: bool) !bool {
        if (self.cell_at(x, y)) |_| {
            return Errors.LocationOccupied;
        }

        const key = try std.fmt.allocPrint(self.allocator, "{d}-{d}", .{ x, y });
        const cell = try Cell.init(self.allocator, x, y, alive);
        try self.cells.put(key, cell);
        return true;
    }

    fn prepopulate_neighbours(self: *World) !void {
        var it = self.cells.valueIterator();
        while (it.next()) |cell| {
            const x = @as(isize, @intCast(cell.*.x));
            const y = @as(isize, @intCast(cell.*.y));

            for (DIRECTIONS) |direction| {
                const nx = x + direction[0];
                const ny = y + direction[1];
                if (nx < 0 or ny < 0) {
                    continue; // Out of bounds
                }

                const ux = @as(u32, @intCast(nx));
                const uy = @as(u32, @intCast(ny));
                if (ux >= self.width or uy >= self.height) {
                    continue; // Out of bounds
                }

                if (self.cell_at(ux, uy)) |neighbour| {
                    try cell.*.neighbours.append(self.allocator, neighbour);
                }
            }
        }
    }
};
