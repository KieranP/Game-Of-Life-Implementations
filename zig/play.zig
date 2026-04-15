const std = @import("std");
const Allocator = std.mem.Allocator;
const Io = std.Io;
const World = @import("world.zig").World;

pub const Play = struct {
    const WORLD_WIDTH = 150;
    const WORLD_HEIGHT = 40;

    pub fn run(allocator: Allocator, io: Io, minimal: bool) !void {
        const world = try World.init(allocator, io, WORLD_WIDTH, WORLD_HEIGHT);
        defer allocator.destroy(world);
        defer world.deinit();

        const stdout = Io.File.stdout();

        if (!minimal) {
            const rendered = try world.render();
            defer allocator.free(rendered);
            try stdout.writeStreamingAll(io, rendered);
        }

        var total_tick: f64 = 0;
        var lowest_tick = std.math.floatMax(f64);
        var total_render: f64 = 0;
        var lowest_render = std.math.floatMax(f64);

        while (true) {
            const tick_start = Io.Timestamp.now(io, .awake);
            world.dotick();
            const tick_finish = Io.Timestamp.now(io, .awake);
            const tick_time: f64 = @floatFromInt(tick_finish.nanoseconds - tick_start.nanoseconds);
            total_tick += tick_time;
            lowest_tick = @min(lowest_tick, tick_time);
            const avg_tick = total_tick / @as(f64, @floatFromInt(world.tick));

            const render_start = Io.Timestamp.now(io, .awake);
            const rendered = try world.render();
            defer allocator.free(rendered);
            const render_finish = Io.Timestamp.now(io, .awake);
            const render_time: f64 = @floatFromInt(render_finish.nanoseconds - render_start.nanoseconds);
            total_render += render_time;
            lowest_render = @min(lowest_render, render_time);
            const avg_render = total_render / @as(f64, @floatFromInt(world.tick));

            if (!minimal) {
                try stdout.writeStreamingAll(io, "\x1b[H\x1b[2J");
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
            try stdout.writeStreamingAll(io, output);

            if (!minimal) {
                try stdout.writeStreamingAll(io, rendered);
            }
        }
    }

    fn _f(value: f64) f64 {
        // nanoseconds -> milliseconds
        return value / 1_000_000.0;
    }
};

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;
    const io = init.io;
    const minimal = init.environ_map.contains("MINIMAL");

    try Play.run(allocator, io, minimal);
}
