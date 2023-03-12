// v1.0.0 | 2023/03/12 | Zig 0.11.0-dev.1924+5a26d1b42
// ===================================================
// Test the Zig port of fts_fuzzy_match against the
// original algorithm by diff-comparing their results.
// By Tristano Ajmone, CC0 1.0 (public domain).
// ===================================================
const std = @import("std");
const fts = @import("fts_fuzzy_match.zig");

const data_path = "../../../dataset/ue4_filenames.txt";
const out_path = "test_results.txt";
const match_pattern = "LLL";
const max_matches = 100;

pub fn main() !void {
    var out_file = try std.fs.cwd().createFile(out_path, .{});
    defer out_file.close();
    const out_writer = out_file.writer();

    var data_file = try std.fs.cwd().openFile(data_path, .{});
    defer data_file.close();

    var data_buf = std.io.bufferedReader(data_file.reader());
    var data_reader = data_buf.reader();

    var buf: [1024]u8 = undefined;
    var score: i32 = 0;
    var matches: i32 = 0;
    while (try data_reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (fts.fuzzyMatch(match_pattern, line, &score)) {
            try std.fmt.format(out_writer, "{d}|{s}\n", .{ score, line });
            matches += 1;
            if (matches == max_matches)
                break;
        }
    }
}
