const std = @import("std");
const allocator = std.heap.page_allocator;

pub fn openfile(path: []u8) std.fs.File.OpenError!std.fs.File {

    // i am aware this is a single line function, i do not care
    // i did this to play with the type system
    // it will stay this way

    // also I am aware that multiline comments exist

    return std.fs.cwd().openFile(path, .{ .mode = .read_only });
}

// will eventually take args to handle cols+width
pub fn dump_hex(data: []u8) void {

    // TODO: config parameters
    const linelen = 16;
    const chunklen = 2;

    var offset: u8 = 0;

    var lit = std.mem.window(u8, data, linelen, linelen);
    while (lit.next()) |line| {
        // TODO: format this
        std.debug.print("{x:0>8}: ", .{offset});

        // TODO: edgecase when file is not of !%chnklen len
        var cit = std.mem.window(u8, line, chunklen, chunklen);
        while (cit.next()) |chunk| {
            var tempchunk: [chunklen]u8 = undefined;
            std.mem.copyForwards(u8, &tempchunk, chunk);

            const hexchunk = std.fmt.bytesToHex(tempchunk, .lower);
            std.debug.print("{s} ", .{hexchunk});
        }

        std.debug.print(" ", .{});

        // for (0..linelen) |i| {
        //     std.debug.print("{c}", .{line[i]});
        // }

        std.debug.print("\n", .{});

        offset += linelen;
    }

    // iterate over chunks (column length)
}
pub fn main() !void {
    const argv = std.process.argsAlloc(allocator) catch |err| {
        std.debug.print("Alloc failed: {}\n", .{err});
        return;
    };

    defer std.process.argsFree(allocator, argv);

    if (argv.len == 1) {
        std.debug.print("Usage: {s} <filename> <options>\n", .{argv[0]});
        return;
    }

    const filepath = argv[1];
    const f = openfile(filepath) catch |e| switch (e) {
        error.FileNotFound => {
            std.debug.print("File '{s}' does not exists\n", .{filepath});
            return;
        },
        else => {
            std.debug.print("{?}\n", .{e});
            return;
        },
    };

    const fStats = try f.stat();

    // TODO: handle errors here
    const fBuf = try allocator.alloc(u8, fStats.size);
    _ = try f.read(fBuf);
    dump_hex(fBuf);
}
