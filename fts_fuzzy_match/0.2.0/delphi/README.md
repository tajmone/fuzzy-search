# Fuzzy Match v0.2.0 Delphi/FreePascal

Delphi/FreePascal implementation of the __[fts_fuzzy_match]__ algorithm, ported by [j.visser]:

- [`FuzzyScore.dpr`](./FuzzyScore.dpr)
- [`uFuzzyMatching.pas`](./uFuzzyMatching.pas)


Taken from his [public GitHub Gist]  (commit [ebe9842d], 2020-11-02).

Adapted slightly by [j.visser] for his own use, especially:

- Calculation corrected for double byte chars.
- Added a match index offset of 1 to match Delphi/Pascal string indexes.

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

<!-- people -->

[j.visser]: https://github.com/GolezTrol "View j.visser's GitHub profile"

<!-- EOF -->
