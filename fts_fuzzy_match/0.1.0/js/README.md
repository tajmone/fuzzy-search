# Fuzzy Match v0.1.0 JavaScript

The original JavaScript implementation of the __[fts_fuzzy_match]__ algorithm v0.1.0 by [Forrest Smith], described in the _[Reverse Engineering Sublime Text’s Fuzzy Match]_ article of 2016, and published in the __[lib_fts]__ project.

-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Folder Contents](#folder-contents)
- [Test File](#test-file)
- [License](#license)

<!-- /MarkdownTOC -->

-----

# Folder Contents

- [`fts_fuzzy_match.js`][fts_fuzzy_match.js] — Fuzzy Match v0.1.0 in JavaScript.
- [`test.sh`][test.sh] — test launcher.
- [`node-test.js`][node-test.js] — [Node.js] test code.
- [`test_results.txt`][test_results.txt] — generated test results.

The `fts_fuzzy_match.js` file was taken from [Forrest Smith]'s __[lib_fts]__ repository, commit [08a4bb1][fm1js 08a4bb1], 2017-02-19.

The `test.sh` and `node-test.js` files were created and added by [Tristano Ajmone].

For the original documentation, see [`../../fuzzy_match.md`][fm md].


# Test File

To run the tests, open the Bash shell and type ([Node.js] required):

    ./test.sh

which will produce the [`test_results.txt`][test_results.txt] file and compare it via `diff` to [`../expected_results.txt`][expected_results.txt], reporting whether they're identical (_passed_) or not (_failed_).

Since this is also one of the original implementations of v0.1.0 of the algorithm, the test is carried out just as a formality, to confirm that it behaves just like its C++ counterpart, and to provide an example of how tests should be implemented and carried out.


# License

All source code from [Forrest Smith]'s __[lib_fts]__ project is released under the following license:

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

[fts_fuzzy_match.js]: ./fts_fuzzy_match.js "Original JavaScript implementation of fts_fuzzy_match v0.1.0"
[node-test.js]: ./node-test.js "Test code (Node.js)"
[test.sh]: ./test.sh "Test launcher script"
[test_results.txt]: ./test_results.txt
[expected_results.txt]: ../expected_results.txt "Test validation data"

<!-- people -->

[Forrest Smith]: https://github.com/forrestthewoods "View Forrest Smith's GitHub profile"
[Tristano Ajmone]: https://github.com/tajmone "View Tristano Ajmone's GitHub profile"

<!-- FTS Fuzzy Match  -------------------------------------------------------->

[lib_fts]: https://github.com/forrestthewoods/lib_fts
[fts_fuzzy_match]: https://github.com/forrestthewoods/lib_fts

<!-- upstream sources -->

[fm1js 08a4bb1]: https://github.com/forrestthewoods/lib_fts/blob/08a4bb1883cc70480020bca549894135ae08d8f5/code/fts_fuzzy_match.js "View upstream source of 'fts_fuzzy_match.js' v0.1.0 from commit 08a4bb1"

<!-- EOF -->
