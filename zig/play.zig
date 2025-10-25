const std = @import("std");
const Allocator = std.mem.Allocator;
const World = @import("world.zig").World;

const stdout = std.fs.File.stdout();

pub const Play = struct {
    const WORLD_WIDTH = 150;
    const WORLD_HEIGHT = 40;

    pub fn run(allocator: Allocator) !void {
        const world = try World.init(
            allocator,
            WORLD_WIDTH,
            WORLD_HEIGHT,
        );
        defer allocator.destroy(world);
        defer world.deinit();

        const minimal = std.process.hasEnvVarConstant("MINIMAL");

        if (!minimal) {
            const rendered = try world.render();
            defer allocator.free(rendered);
            try stdout.writeAll(rendered);
        }

        var total_tick: usize = 0;
        var lowest_tick: usize = std.math.maxInt(usize);
        var total_render: usize = 0;
        var lowest_render: usize = std.math.maxInt(usize);

        while (true) {
            const tick_start = std.time.nanoTimestamp();
            world._tick();
            const tick_finish = std.time.nanoTimestamp();
            const tick_time: usize = @intCast(tick_finish - tick_start);
            total_tick += tick_time;
            lowest_tick = @min(lowest_tick, tick_time);
            const avg_tick = total_tick / world.tick;

            const render_start = std.time.nanoTimestamp();
            const rendered = try world.render();
            defer allocator.free(rendered);
            const render_finish = std.time.nanoTimestamp();
            const render_time: usize = @intCast(render_finish - render_start);
            total_render += render_time;
            lowest_render = @min(lowest_render, render_time);
            const avg_render = total_render / world.tick;

            if (!minimal) {
                try stdout.writeAll("\x1b[H\x1b[2J");
            }

            const output = try std.fmt.allocPrint(
                allocator,
                "#{d} - World Tick (L: {d:.3}; A: {d:.3}) - Rendering (L: {d:.3}; A: {d:.3})\n",
                .{
                    world.tick,
                    _f(lowest_tick),
                    _f(avg_tick),
                    _f(lowest_render),
                    _f(avg_render),
                },
            );
            defer allocator.free(output);
            try stdout.writeAll(output);

            if (!minimal) {
                try stdout.writeAll(rendered);
            }
        }
    }

    fn _f(value: usize) f64 {
        // value is in nanoseconds, convert to milliseconds
        return @as(f64, @floatFromInt(value)) / 1_000_000.0;
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    try Play.run(allocator);
}
