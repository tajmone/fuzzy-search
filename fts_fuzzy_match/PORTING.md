# Porting Guide

Some guidelines on how to create, test and add to the repository a new implementation of the __fts_fuzzy_match__ algorithm in another language.


-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Porting](#porting)
    - [Algorithm Versions](#algorithm-versions)
    - [Original Reference Implementations](#original-reference-implementations)
    - [Other Reference Implementations](#other-reference-implementations)
        - [C Port of v0.2.0](#c-port-of-v020)
    - [Code Guidelines](#code-guidelines)
- [Testing](#testing)

<!-- /MarkdownTOC -->

-----

# Porting

Besides the original algorithm implementations by [Forrest Smith], you'll find in this repository third implementations in various other languages.
Depending on the target language you're porting the algorithm to, and the programming languages you're fluent in, you'll find some of these implementations more useful references to start with.

Before starting to work on your code, you're strongly advised to read the _[Reverse Engineering Sublime Text’s Fuzzy Match]_ article by [Forrest Smith], which inspired the __fts_fuzzy_match__ algorithm in the first place.

Having read that, you are strongly advised to read the [optimization notes][2c notes] provided by [Philip Jones] along with his [C port of __v0.2.0__][2c] (more on his C port further down).

## Algorithm Versions

[Forrest Smith] has created two versions of the algorithm:

- __v0.1.0__ — the original algorithm mentioned in the article.
- __v0.2.0__ — an improved version, based on feedback on the article from Sublime Text author, Jon Skinner.

You should consider implementing __v0.1.0__ of the algorithm first, and then start working on __v0.2.0__, since the latter is an extended version of the former, and it's easier to understand the updated version once you grasped its first incarnation.

If you do so, please add to this repository both version __v0.1.0__ and __v0.2.0__ of your ported algorithm, for they will be helpful references to other porters.


## Original Reference Implementations

The original algorithm implementation by [Forrest Smith] can be found in the following folders:

- [`/0.1.0/cpp/`][1cpp] — C++ algorithm __v0.1.0__
- [`/0.1.0/js/`][1js] — JavaScript algorithm __v0.1.0__
- [`/0.2.0/cpp/`][1cpp] — C++ algorithm __v0.2.0__

If you need the JavaScript implementation of __v0.2.0__, there's the implementation by [@nrgwsth]:

- [`/0.2.0/js/`][2js] — JavaScript algorithm __v0.2.0__


## Other Reference Implementations

Beside the original algorithm by [Forrest Smith], mentioned above, you might also want to study the source code of the following ports:

### C Port of v0.2.0

- [`/0.2.0/c/`][2c] — C algorithm __v0.2.0__ (slender)

The C port of algorithm __v0.2.0__ by [Philip Jones] contains some nice optimizations that render the code shorter and less entangled than the original, therefore easier to understand and port to other languages — especially non OOP languages.

Furthermore, the author kindly [documented his code enhancements][2c notes], explaining in detail how his changes improve upon the original and why his approach is simpler to understand and implement.


## Code Guidelines

While porting the algorithm, try to stay as close to the original implementation as possible, and resist temptations to add your own improvements.
The goal of this project is to present ports of the original algorithms, _as they are_, to various other languages.
That said, any adaptations of the original code in order to adhere to the target language idiomatic approach is desirable, including optimization which come natural due to syntax features specific to the target language.

There's obviously room for a lot of improvements in the original __fts_fuzzy_match__ algorithm, but its beauty and success lie in its simplicity.
It's an entry level algorithm and introduction to fuzzy searching and matching, and it's meant as a starting point to get your feet wet with fuzzy matching, without the complexity of more advanced algorithms.

If you've created improved versions of the base algorithm, I'd love to add them to the project, just not in the `fts_fuzzy_match/` folder, but in a new dedicated section of the project instead, created _ad hoc_ for optimized and improved versions, and some documentation explaining their benefits and implementation details.


# Testing

In order to test that your ported implementation of the algorithm works as expected, I've come up with the following testing strategy.

Every algorithm implementation should provide a test file that:

- Invokes the `fuzzy_match()` scored function against every entry in the [`ue4_filenames.txt`][ue4_filenames.txt] dataset, passing "LLL" as the search pattern.
- For every matching call, write to the `test_results.txt` file a string containing:
    + &lt;match score&gt; + `|` + &lt;matched entry&gt; + `\n`
- The test ends when 100 matches have been written to `test_results.txt`, or the dataset entries are exhausted (if the latter occurs, then there's a problem in your algorithm).

The resulting `test_results.txt` file can then be diffed with the equivalent reference file generated by the original algorithm of the same version, if they are identical the test has passed:


- [`0.1.0/expected_results.txt`][expect1]
- [`0.2.0/expected_results.txt`][expect2]

Both `expected_results.txt` files are copies of the `test_results.txt` files generated by the original C++ algorithms by Forrest.

For examples of test code implementations and results validation, see:

- **JavaScript:**
    + [`0.1.0/js/node-test.js`][node-test] — test code that generates `test_results.txt`.
    + [`0.1.0/js/test.sh`][js-test.sh] — runs the test code then diffs `test_results.txt` against `expected_results.txt`.
- **C++:**
    + [`0.2.0/cpp/test.cpp`][cpp-test] — test code that generates `test_results.txt`.

Note that the test code and execution script for any given language are identical for both v0.1.0 and v0.2.0 of the algorithm, only the internal implementation of the algorithm changes.
If you're implementing an algorithm in a language for which there's already an implementation in either version (v0.1.0 or v0.2.0), you can just copy and reuse its test code and script, if available.

<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

<!-- articles -->

[Reverse Engineering Sublime Text’s Fuzzy Match]: https://www.forrestthewoods.com/blog/reverse_engineering_sublime_texts_fuzzy_match/ "Read Forrest Smith's article"

<!-- project files -->

[ue4_filenames.txt]: ../dataset/ue4_filenames.txt

[node-test]: ./0.1.0/js/node-test.js
[js-test.sh]: ./0.1.0/js/test.sh

[cpp-test]: ./0.2.0/cpp/test.cpp

[expect1]: ./0.1.0/expected_results.txt "Test results from original algorithm v0.1.0"
[expect2]: ./0.2.0/expected_results.txt "Test results from original algorithm v0.2.0"

[1cpp]: ./0.1.0/cpp/ "Navigate to C++ algorithm v0.1.0"
[1js]:  ./0.1.0/js/  "Navigate to JavaScript algorithm v0.1.0"
[2cpp]: ./0.2.0/cpp/ "Navigate to C++ algorithm v0.2.0"
[2js]:  ./0.2.0/js/  "Navigate to JavaScript algorithm v0.2.0"

<!-- C v0.2.0 -->

[2c]: ./0.2.0/c/ "Navigate to C algorithm v0.2.0"
[2c notes]: ./0.2.0/c/NOTES.md "P.Jones' optimization notes"

<!-- Issue -->

[#16]: https://github.com/tajmone/fuzzy-search/issues/16 "Issue #16 — Create Tests Data from Original Algorithms"

<!-- people -->

[@nrgwsth]: https://github.com/nrgwsth "View @nrgwsth's GitHub profile"
[Forrest Smith]: https://github.com/forrestthewoods "View Forrest Smith's GitHub profile"
[Philip Jones]: https://github.com/philj56 "View Philip Jones's GitHub profile"

<!-- EOF -->
