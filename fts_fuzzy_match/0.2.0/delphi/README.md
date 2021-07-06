# Fuzzy Match v0.2.0 Delphi/FreePascal

Delphi/FreePascal implementation of the __[fts_fuzzy_match]__ algorithm, ported by [j.visser] and tweaked by [@forever-new].

Original code taken from [j.visser]'s [public GitHub Gist]  (commit [ebe9842d], 2020-11-02).

-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3,4" -->

- [Folder Contents](#folder-contents)
- [History](#history)
- [Usage](#usage)
- [License](#license)

<!-- /MarkdownTOC -->

-----

# Folder Contents

- [`FuzzyScore.dpr`](./FuzzyScore.dpr)
- [`uFuzzyMatching.pas`](./uFuzzyMatching.pas)
- [`Test.dpr`](./Test.dpr) — algorithm test code.
- [`test_results.txt`](./test_results.txt) — test results.


# History

The original port of the algorithm was slightly adapted by [j.visser] for his own use, especially:

- Calculation corrected for double byte chars.
- Added a match index offset of 1 to match Delphi/Pascal string indexes.

[@forever-new] tweaked the original code to align it with the needs of this project, enforcing the behaviour of the original algorithm, and added the algorithm validation test code, and contributed the changes in [PR #19]:


1. Added check for non-uppercaseable characters. e.g. numbers — so 'a4' doesn't get camel case bonus.
2, Removed extra Delphi index `pascal_index = 1` — it broke the score calculation in a couple of places.
3. Removed update for double byte chars — it was causing wrong calculation of unmatched count, and other issues.
4. Added initialization for internal static array so the output Matches array is not populated with memory garbage.
5. Set option `first_letter_count` to 1, to align with other ports.
6. Added test algorithm.


# Usage

Can be used in Delphi, or in FreePascal in Delphi or ObjFPC mode.

```
fpc -Mdelphi FuzzyScore.pp
FuzzyScore [search string] [ < input ]
```


# License

CC0, Creative Commons Zero, (public domain).

<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

<!-- upstream -->

[fts_fuzzy_match]: https://github.com/forrestthewoods/lib_fts

[public GitHub Gist]: https://gist.github.com/GolezTrol/ebe9842df38b8b641c2a044d8b6dbd1e "View original Gist"

[ebe9842d]: https://gist.github.com/GolezTrol/ebe9842df38b8b641c2a044d8b6dbd1e/

[PR #19]: https://github.com/tajmone/fuzzy-search/pull/19 "View pull request #19"

<!-- people -->

[j.visser]: https://github.com/GolezTrol "View j.visser's GitHub profile"
[@forever-new]: https://github.com/forever-new "View @forever-new's GitHub profile"

<!-- EOF -->
