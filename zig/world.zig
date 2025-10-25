const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const StringHashMap = std.StringHashMap;

const DIRECTIONS = [8][2]i8{
    .{ -1, 1 }, .{ 0, 1 }, .{ 1, 1 }, // above
    .{ -1, 0 }, .{ 1, 0 }, // sides
    .{ -1, -1 }, .{ 0, -1 }, .{ 1, -1 }, // below
};

pub const LocationOccupied = error{
    LocationOccupied,
};

pub const World = struct {
    allocator: Allocator,
    tick: usize,
    width: usize,
    height: usize,
    cells: StringHashMap(*Cell),

    pub fn init(allocator: Allocator, width: usize, height: usize) !*World {
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
        while (it.next()) |cell| {
            const alive_neighbours = self.alive_neighbours_around(cell.*);
            if (!cell.*.alive and alive_neighbours == 3) {
                cell.*.next_state = true;
            } else if (alive_neighbours < 2 or alive_neighbours > 3) {
                cell.*.next_state = false;
            } else {
                cell.*.next_state = cell.*.alive;
            }
        }

        // Then execute the determined action for all cells
        it = self.cells.valueIterator();
        while (it.next()) |cell| {
            cell.*.alive = cell.*.next_state;
        }

        self.tick += 1;
    }

    // Implement first using string concatenation. Then implement any
    // special string builders, and use whatever runs the fastest
    // Returns a string representation of the world grid
    pub fn render(self: *World) ![]const u8 {
        const total_size = self.width * self.height + self.height;

        // The following works and is the same speed
        // var rendering = ArrayList(u8){};
        // try rendering.ensureTotalCapacity(self.allocator, total_size);
        // for (0..self.height) |y| {
        //     for (0..self.width) |x| {
        //         if (self.cell_at(@intCast(x), @intCast(y))) |cell| {
        //             try rendering.append(self.allocator, cell.to_char());
        //         }
        //     }
        //     try rendering.append(self.allocator, '\n');
        // }
        // return rendering.toOwnedSlice(self.allocator);

        // The following was the fastest method
        const buffer = try self.allocator.alloc(u8, total_size);
        var idx: usize = 0;
        for (0..self.height) |y| {
            for (0..self.width) |x| {
                if (self.cell_at(@intCast(x), @intCast(y))) |cell| {
                    buffer[idx] = cell.to_char();
                }
                idx += 1;
            }
            buffer[idx] = '\n';
            idx += 1;
        }
        return buffer;
    }

    fn cell_at(self: *World, x: isize, y: isize) ?*Cell {
        var key_buf: [32]u8 = undefined;
        const key = std.fmt.bufPrint(&key_buf, "{d}-{d}", .{ x, y }) catch unreachable;
        return self.cells.get(key);
    }

    fn populate_cells(self: *World) !void {
        for (0..self.height) |y| {
            for (0..self.width) |x| {
                const random = std.crypto.random.intRangeAtMost(u8, 0, 100);
                const alive = random <= 20;
                _ = try self.add_cell(x, y, alive);
            }
        }
    }

    fn add_cell(self: *World, x: usize, y: usize, alive: bool) !*Cell {
        const key = try std.fmt.allocPrint(self.allocator, "{d}-{d}", .{ x, y });

        if (self.cells.get(key)) |_| {
            return LocationOccupied.LocationOccupied;
        }

        const cell = try Cell.init(self.allocator, x, y, alive);
        try self.cells.put(key, cell);
        return cell;
    }

    fn prepopulate_neighbours(self: *World) !void {
        var it = self.cells.valueIterator();
        while (it.next()) |cell| {
            for (DIRECTIONS) |direction| {
                const nx = @as(isize, @intCast(cell.*.x)) + direction[0];
                const ny = @as(isize, @intCast(cell.*.y)) + direction[1];
                if (self.cell_at(nx, ny)) |neighbour| {
                    try cell.*.neighbours.append(self.allocator, neighbour);
                }
            }
        }
    }

    // Implement first using filter/lambda if available. Then implement
    // foreach and for. Use whatever implementation runs the fastest
    fn alive_neighbours_around(self: *World, cell: *Cell) usize {
        _ = self; // Silence unused variable warning

        // The following was the fastest method
        var alive_neighbours: usize = 0;
        for (cell.neighbours.items) |neighbour| {
            if (neighbour.alive) {
                alive_neighbours += 1;
            }
        }
        return alive_neighbours;

        // The following works and is the same speed
        // var alive_neighbours: usize = 0;
        // var i: usize = 0;
        // while (i < cell.neighbours.items.len) : (i += 1) {
        //     if (cell.neighbours.items[i].alive) {
        //         alive_neighbours += 1;
        //     }
        // }
        // return alive_neighbours;
    }
};

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
};
