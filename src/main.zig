const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var map = std.AutoHashMap(u8, u32).init(allocator);

    var file = try std.fs.cwd().openFile("data.txt", .{});
    defer file.close();

    var buffer: [1]u8 = undefined;

    while (true) {
        const bytes_read = try file.read(buffer[0..1]);
        if (bytes_read == 0) break; // End of file
        const char = buffer[0];

        if (map.get(char)) |value| {
            try map.put(char, value + 1);
        } else {
            try map.put(char, 1);
        }
    }

    var it = map.iterator();
    while (it.next()) |entry| {
        std.debug.print("Key: {c}, Value: {}\n", .{ entry.key_ptr.*, entry.value_ptr.* });
    }
}
