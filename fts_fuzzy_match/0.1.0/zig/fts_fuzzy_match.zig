// v1.0.0 | 2023/03/12 | Zig 0.11.0-dev.1924+5a26d1b42
// =======================================================
// Zig port of Forrest Smith's "fts_fuzzy_match.h" v0.1.0.
// by Tristano Ajmone, CC0 1.0 (public domain).
// =======================================================

const std = @import("std");
const ascii = @import("std").ascii;

pub fn fuzzyMatch(pat: []const u8, str: []const u8, score: *i32) bool {
    // Score consts
    const adjacency_bonus: i32 = 5; // bonus for adjacent matches
    const separator_bonus: i32 = 10; // bonus if match occurs after a separator
    const camel_bonus: i32 = 10; // bonus if match is uppercase and prev is lower

    const leading_letter_penalty: i32 = -3; // penalty applied for every letter in str before the first match
    const max_leading_letter_penalty: i32 = -9; // maximum penalty for leading letters
    const unmatched_letter_penalty: i32 = -1; // penalty for every letter that doesn't matter

    // Loop variables
    var pat_consumed: bool = false;
    var p_idx: u8 = 0;
    var s_idx: u8 = 0;
    var prev_matched: bool = false;
    var prev_lower: bool = false;
    var prev_separator: bool = true; // true so if first letter match gets separator bonus

    // Use "best" matched letter if multiple string letters match the pattern
    var best_letter: ?u8 = null;
    var best_letter_score: i32 = 0;

    score.* = 0;
    // Loop over string
    while (s_idx < str.len) {
        pat_consumed = if (p_idx < pat.len) false else true;
        var pat_chr = if (!pat_consumed) pat[p_idx] else 0; // because 0-terminator was lost!
        var str_chr = str[s_idx];
        var pat_chr_low = ascii.toLower(pat_chr);
        var str_chr_low = ascii.toLower(str_chr);

        var next_match: bool = !pat_consumed and pat_chr_low == str_chr_low;
        var rematch: bool = best_letter != null and ascii.toLower(best_letter.?) == str_chr_low;
        var advanced: bool = next_match and best_letter != null;
        var pattern_repeat: bool = best_letter != null and !pat_consumed and ascii.toLower(best_letter.?) == pat_chr_low;

        if (advanced or pattern_repeat) {
            score.* += best_letter_score;
            best_letter = null;
            best_letter_score = 0;
        }

        if (next_match or rematch) {
            var new_score: i32 = 0;

            // Apply penalty for each letter before the first pattern match
            // Note: std.math.max() because penalties are negative values,
            //       therefore max is smallest penalty.
            if (p_idx == 0)
                score.* += std.math.max(s_idx * leading_letter_penalty, max_leading_letter_penalty);

            // Apply bonus for consecutive bonuses
            if (prev_matched)
                new_score += adjacency_bonus;

            // Apply bonus for matches after a separator
            if (prev_separator)
                new_score += separator_bonus;

            // Apply bonus across camel case boundaries
            if (prev_lower and ascii.isUpper(str_chr))
                new_score += camel_bonus;

            // Update pattern index IFF the next pattern letter was matched
            if (next_match)
                p_idx += 1;

            // Update best letter in str which may be for a "next" letter or a rematch
            if (new_score >= best_letter_score) {
                // Apply penalty for now skipped letter
                if (best_letter != null)
                    score.* += unmatched_letter_penalty;

                best_letter = str_chr;
                best_letter_score = new_score;
            }

            prev_matched = true;
        } else {
            score.* += unmatched_letter_penalty;
            prev_matched = false;
        }

        // Separators should be more easily defined
        prev_lower = ascii.isLower(str_chr);
        prev_separator = if (str_chr == '_' or str_chr == ' ') true else false;

        s_idx += 1;
    } // Loop over string ends

    // Apply score for last match
    if (best_letter != null)
        score.* += best_letter_score;

    return pat_consumed;
}
