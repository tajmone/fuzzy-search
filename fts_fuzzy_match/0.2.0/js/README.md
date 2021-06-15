# Fuzzy Match v0.2.0 JavaScript

The JavaScript implementation of version v0.2.0 of the __[fts_fuzzy_match]__ algorithm by [Forrest Smith], updated by [@nrgwsth], to include the "exhaustive search" functionality described in the 2017 update to the _[Reverse Engineering Sublime Text’s Fuzzy Match]_ article.



-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Folder Contents](#folder-contents)
- [Test File](#test-file)
- [License](#license)

<!-- /MarkdownTOC -->

-----

# Folder Contents

- [`fts_fuzzy_match.js`](./fts_fuzzy_match.js) — Fuzzy Match v0.2.0 in JavaScript.
- [`test.sh`][test.sh] — test launcher.
- [`node-test.js`][node-test.js] — [Node.js] test code.
- [`test_results.txt`][test_results.txt] — generated test results.

The `fts_fuzzy_match.js` file was submitted by [@nrgwsth] via [PR #10] (merge commit: [cbce81f]) on 2017-02-21.

The `test.sh` and `node-test.js` files were created and added by [Tristano Ajmone].

For the original documentation, see [`../../fuzzy_match.md`][fm md].


# Test File

To run the tests, open the Bash shell and type ([Node.js] required):

    ./test.sh

which will produce the [`test_results.txt`][test_results.txt] file and compare it via `diff` to [`../expected_results.txt`][expected_results.txt], reporting whether they're identical (_passed_) or not (_failed_).


# License

[@nrgwsth] published his source file under the same public domain terms of the original __[fts_fuzzy_match]__ project:

> This software is dual-licensed to the public domain and under the following license: you are granted a perpetual, irrevocable license to copy, modify, publish, and distribute this file as you see fit.

The [`test.sh`][test.sh] and [`node-test.js`][node-test.js] test files were written by [Tristano Ajmone] and released into the public domain via the [CC0 license].

<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

[Node.js]: https://nodejs.org "Visit Node.js website"
[CC0 license]: ../../../LICENSE "Read the Creative Commons Zero v1.0 Universal license"

<!-- articles -->

[Reverse Engineering Sublime Text’s Fuzzy Match]: https://www.forrestthewoods.com/blog/reverse_engineering_sublime_texts_fuzzy_match/ "Read Forrest Smith's article"

<!-- project files -->

[fm md]: ../../fuzzy_match.md "View the original documentation of fts_fuzzy_match"

[fts_fuzzy_match.js]: ./fts_fuzzy_match.js "Third party JavaScript implementation of fts_fuzzy_match v0.2.0"
[node-test.js]: ./node-test.js "Test code (Node.js)"
[test.sh]: ./test.sh "Test launcher script"
[test_results.txt]: ./test_results.txt
[expected_results.txt]: ../expected_results.txt "Test validation data"

<!-- people -->

[@nrgwsth]: https://github.com/nrgwsth "View @nrgwsth's GitHub profile"
[Forrest Smith]: https://github.com/forrestthewoods "View Forrest Smith's GitHub profile"
[Tristano Ajmone]: https://github.com/tajmone "View Tristano Ajmone's GitHub profile"

<!-- FTS Fuzzy Match  -------------------------------------------------------->

[lib_fts]: https://github.com/forrestthewoods/lib_fts
[fts_fuzzy_match]: https://github.com/forrestthewoods/lib_fts

<!-- PRs & commits  -->

[cbce81f]: https://github.com/tajmone/fuzzy-search/commit/cbce81fd4ba6cb54dc888c54da78c9558e5df022
[PR #10]: https://github.com/tajmone/fuzzy-search/pull/10 "View original pull request"


<!-- EOF -->
