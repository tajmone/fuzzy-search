// v1.0.0 | 2023/03/12 | Zig 0.11.0-dev.1924+5a26d1b42
// =====================================================
// Zig port of Forrest Smith's fts::fuzzy_match_simple()
// by Tristano Ajmone, CC0 1.0 (public domain).
// =====================================================

const std = @import("std");
const ascii = @import("std").ascii;

pub fn fuzzyMatchSimple(pat: [*:0]const u8, str: [*:0]const u8) bool {
    // Returns true if each character in pattern 'pat' is
    // found sequentially  within target string 'str'.
    var p_idx: u8 = 0;
    var s_idx: u8 = 0;
    while (pat[p_idx] != 0 and str[s_idx] != 0) {
        if (ascii.toLower(pat[p_idx]) == ascii.toLower(str[s_idx])) {
            p_idx += 1;
        }
        s_idx += 1;
    }
    return if (pat[p_idx] == 0) true else false;
}

test "fuzzyMatchSimple test" {
    try std.testing.expect(fuzzyMatchSimple("AA", "Amanda") == true);
    try std.testing.expect(fuzzyMatchSimple("AZ", "Amanda") == false);
}
