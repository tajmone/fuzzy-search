# Fuzzy Match v0.1.0 Zig

[Zig] implementation of [Forrest Smith]'s __[fts_fuzzy_match]__ algorithm v0.1.0, ported by [Tristano Ajmone].

-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Folder Contents](#folder-contents)
- [Port Notes](#port-notes)
- [History](#history)
- [License](#license)

<!-- /MarkdownTOC -->

-----

# Folder Contents

- [`fts_fuzzy_match.zig`][fts_fuzzy_match.zig] — `fts.fuzzyMatch()` module.
- [`fts_fuzzy_match_simple.zig`][fts_fuzzy_match_simple.zig] — `fts.fuzzyMatchSimple()` module.
- [`fuzzy-test.zig`][fuzzy-test.zig] — algorithm test code.
- [`test.sh`][test.sh] — test script.
- [`test_results.txt`][test_results.txt] — test results.
- [`LICENSE`][LICENSE] — CC0 Universal license.


The `fuzzyMatchSimple()` variant found in module [`fts_fuzzy_match_simple.zig`][fts_fuzzy_match_simple.zig] is the Zig port of Smith's `fts::fuzzy_match_simple()`, as found in the [C++ algorithm v0.2.0][fm2 cpp], which I've included here just for reference purposes (it's not used anywhere in the project tests).


# Port Notes

I've ported the algorithm to Zig based on [Forrest Smith]'s original [C++ implementation][fm1 cpp], but there are some differences in the languages which are worth pointing out.

This is the signature of the `fuzzyMatch()` function in Zig:

```zig
pub fn fuzzyMatch(pat: []const u8, str: []const u8, score: *i32) bool
```

As you can see, string parameters `pat` and `str` are coerced to slices (or, in case of comptime-known parameters, to arrays).

In my initial implementation I was coercing them as null-terminated pointers (`[*:0]const u8`) since string literals in Zig are constant single-item pointers to null-terminated byte arrays; but then I noticed that many `std` functions return string slices, and opted for coercion to slices instead.
I don't have enough experience with Zig to tell if that was the best choice or not.

But one thing that I noticed when I switched from null-terminated pointers to slices is that the original code relied on the presence of the null-termination sentinel to establish if the pattern or string had reached its end, whereas using slices I had to check the indexing variable instead to prevent out-of-bound slice-accesses.

I was left wondering if maybe the use of slices and lack of null-terminators might justify refactoring the algorithm to achieve better performance and/or idiomacy — something I'll look into at some point in the future, when I'll be more proficient in Zig.

As for the `score` parameter, I've used a 32-bit signed integer, just to be on the safe side, but I suspect that the possible score outcomes should fit into a 16-bit integer without risk of overflowing (but haven't actually tested it).

I'm pretty sure that there's still plenty of room for improvement in my code, but this was my very first attempt to write a program in Zig, so I pretty much stuck to the original C++ design.

All feedback is welcome.


# History

- **v1.0.0** (2023/03/12)
    + Initial release. Also my first Zig program ever, so probably not particularly idiomatic code.


# License

- [`LICENSE`][LICENSE]

[Tristano Ajmone] has dedicated this code to the public domain via the [CC0 1.0] Universal Public Domain Dedication, waiving all of his rights to the work worldwide under copyright law, including all related and neighbouring rights, to the extent allowed by law:

- https://creativecommons.org/publicdomain/zero/1.0/

You can copy, modify, distribute and perform the work, even for commercial purposes, all without asking permission.

- In no way are the patent or trademark rights of any person affected by CC0, nor are the rights that other persons may have in the work or in how the work is used, such as publicity or privacy rights.
- Tristano Ajmone makes no warranties about the work, and disclaims liability for all uses of the work, to the fullest extent permitted by applicable law.
- When using or citing the work, you should not imply endorsement by Tristano Ajmone.

<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

[CC0 1.0]: https://creativecommons.org/publicdomain/zero/1.0/
[fts_fuzzy_match]: https://github.com/forrestthewoods/lib_fts
[Zig]: https://ziglang.org/ "Visit Zig website"

[fm1 cpp]: ../../0.1.0/cpp/fts_fuzzy_match.h "Navigate to C++ implementation of fts_fuzzy_match v0.1.0"
[fm2 cpp]: ../../0.2.0/cpp/fts_fuzzy_match.h "Navigate to C++ implementation of fts_fuzzy_match v0.2.0"

<!-- project files -->

[fuzzy-test.zig]: ./fuzzy-test.zig "View test file source"
[fts_fuzzy_match.zig]: ./fts_fuzzy_match.zig "View fts.fuzzyMatch() module source"
[fts_fuzzy_match_simple.zig]: ./fts_fuzzy_match_simple.zig "View fts.fuzzyMatchSimple() module source"
[test.sh]: ./test.sh "View test script"
[test_results.txt]: ./test_results.txt "View generated test results"
[LICENSE]: ./LICENSE "View CC0 Universal license"

<!-- people -->

[Forrest Smith]: https://github.com/forrestthewoods "View Forrest Smith's GitHub profile"
[Tristano Ajmone]: https://github.com/tajmone "View Tristano Ajmone's GitHub profile"

<!-- EOF -->
