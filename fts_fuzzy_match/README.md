# FTS Fuzzy Match

The original __fts_fuzzy_match__ algorithms by [Forrest Smith], organized by version number, along with third parties ports to other languages.


-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Directory Contents](#directory-contents)
- [About FTS Fuzzy Match](#about-fts-fuzzy-match)
    - [The Original Algorithm from 2016](#the-original-algorithm-from-2016)
    - [The 2017 Update](#the-2017-update)
    - [License](#license)
- [FTS Fuzzy Match Implementations](#fts-fuzzy-match-implementations)
- [FTS Fuzzy Match Derivatives](#fts-fuzzy-match-derivatives)
- [FTS Fuzzy Match Wrappers](#fts-fuzzy-match-wrappers)

<!-- /MarkdownTOC -->

-----

# Directory Contents

- [`/0.1.0/`](./0.1.0/) — original algorithm based on the 2016 article.
    + [`/cpp/`][1cpp] — C++ version by [Forrest Smith].
    + [`/csharp/`][1cs] — C# port by [Collin Dillinger].
    + [`/fsharp/`][1fsx] — F# port by [Xavier Zwirtz].
    + [`/js/`][1js] — JavaScript version by [Forrest Smith].
    + [`/lua/`][1lua] — Lua port by [Blake Mealey].
    + [`/php/`][1php] — PHP port by [@detectiveYarmas].
    + [`/purebasic/`][1pb] — PureBasic port by [Tristano Ajmone].
    + [`/python/`][1py] — Python port by [Matt Menzenski].
    + [`expected_results.txt`][expect1] — Test data for validating v0.1.0 implementations.
- [`/0.2.0/`](./0.2.0/) — improved "exhaustive search" version based on Jon Skinner feedback, 2017.
    + [`/cpp/`][2cpp] — C++ version by [Forrest Smith].
    + [`/csharp/`][2cs] — C# port by [@theor].
    + [`/delphi/`][2ex] — Delphi/FreePascal port by [j.visser].
    + [`/elixir/`][2ex] — Elixir port by [@WolfDan].
    + [`/js/`][2js] — JavaScript version, updated by [@nrgwsth].
    + [`/kotlin/`][2kt] — Kotlin port by [Michael Bikovitsky].
    + [`expected_results.txt`][expect2] — Test data for validating v0.2.0 implementations.
- [`fuzzy_match.md`][fm md] — original __fts_fuzzy_match__ documentation.
- [`PORTING.md`][PORTING.md] — Porting and testing guidelines.

# About FTS Fuzzy Match

In March 2016, Forrest Smith published the _[Reverse Engineering Sublime Text’s Fuzzy Match]_ article where he provided a detailed description on how he managed to create an algorithm that emulated [Sublime Text] fuzzy search functionality.

He generously made his __fts_fuzzy_match__ algorithm available to the general public by publishing its code on GitHub, both in C++ and JavaScript.
Since the publication of the article and __fts_fuzzy_match__, there have been numerous users feedback that lead to various updates and improvements to the original algorithm, which is currently circulating in two distinct versions: v0.1.0, and v0.2.0.

The importance of Forrest algorithm lies in the fact that it was written as a proof of concept for educational purposes. This means that both his article and code are easily accessible to anyone, the code is well commented and neither require academical understanding of the subject.
As a result, there are many areas in which the algorithm might (and can) be improved, but it's a precious starting point for anyone wishing to approach the subject.

Fuzzy matching, and its application to fuzzy searching, is a wide and complex subject area where many different approaches and algorithms are available — but usually presented as academic papers that are inaccessible to the wider audience.
To Forrest Smith goes merit of having opened up the subject to public discussion, for before his 2016 article there weren't many non-specialistic resources on this topic — at least, none that I managed to find via extensive googling.
Definitely, both his article and __fts_fuzzy_match__ code have been game changers in this respect, and had ripple effect in the open source community, especially on GitHub.

Since there have been ports of both versions of the algorithm to other languages, I'll now summarize its history and the main differences between v0.1.0 and v0.2.0, to provide a better picture of its evolution and diffusion.

## The Original Algorithm from 2016

__fts_fuzzy_match__ is an algorithm for "fuzzy string matching inspired by Sublime Text" written by [Forrest Smith] and published in 2016 as part of his __[lib_fts]__ project of "single-file public domain libraries" (where "FTS" stands for Forrest Thomas Smith):

- https://github.com/forrestthewoods/lib_fts

The latest version of the original algorithms v0.1.0 implementations, by Forrest, can be found here:

- [`./0.1.0/cpp/fts_fuzzy_match.h`][fm1 cpp] — C++, v0.1.0, taken from commit [cb72472][fm1cpp cb72472] (2016-10-28).
- [`./0.1.0/js/fts_fuzzy_match.js`][fm1 js] — JavaScript, v0.1.0, taken from commit [08a4bb1][fm1js 08a4bb1] (2017-02-19).

Although there have been various updates and tweaks to v0.1.0 algorithms, the bump to v0.2.0 introduced a significant quality improvement to its functionality — as well as some complexity to its code, and a slight performance overhead.
Those wishing to study the algorithms, should start by looking at the code of v0.1.0 first, and then move on to study v0.2.0, to better understand its core features via the former, and appreciate the improvements introduced by the latter.

## The 2017 Update

In February 2017 — i.e. a year after the original article — [Sublime Text] author [Jon Skinner posted on reddit] a comment on Forrest article, confirming the soundness of the overall approach and also providing insights on how to improve the algorithm:

> __[jskinner]__: Sublime Text author here. Nice writeup! The actual algorithm that Sublime Text uses is similar in principle, but the implementation is rather different in the name of speed.
>
> There are a couple of things you may want to tweak for better quality matching: you likely want to search more exhaustively for a better match, e.g., searching for "lll" in the UE4 filename list matches "SVisualLoggerLogsList.h", but not as well as it should, as it doesn't pickup all the upper case Ls. If you don't mind sacrificing a little speed, then it's also nice to handle transpositions, so that "sta" can still match against "SpawnActorTimer", just with a lower score - Sublime Text 3 does this.

Skinner's feedback was a major breakthrough that prompted Forrest to update the __fts_fuzzy_match__ C++ algorithm to v0.2.0, in order to include the "exhaustive search" suggested by Skinner:

- [`./0.2.0/cpp/fts_fuzzy_match.h`][fm2 cpp] — C++, v0.2.0, taken from commit [d541eb4][fm2cpp d541eb4] (2017-02-19).

It's worth noting that Forrest never updated his JavaScript implementation to v0.2.0 ([@nrgwsth] did, in [PR #10]), and that many of the third party ports of __fts_fuzzy_match__ to other languages are still based on v0.1.0 of the algorithm.

For this reason, I decided to separate all implementations of __fts_fuzzy_match__ into different folders, according to their algorithm version, to avoid confusion and simplify things to anyone wishing to study the sources or port them to other languages.

## License

All source code from [Forrest Smith]'s __[lib_fts]__ project is released under the following license:

> This software is dual-licensed to the public domain and under the following license: you are granted a perpetual, irrevocable license to copy, modify, publish, and distribute this file as you see fit.

The source files also embed the above license in their comments.

The __[lib_fts]__ repository doesn't explicitly mention if this license also applies to documentation files; so I can't vouch that the [`fuzzy_match.md`][fm md] document is also into the public domain.
I've nevertheless decided to include it (_as is_) in this project for completion and fairness sake, and to shield the original author from any inaccuracies I might have introduced in my own documentation of his algorithms and projects.

# FTS Fuzzy Match Implementations

Forrest's algorithm has inspired a number of third party ports to other languages.
The following table lists all the implementations available in this repository, of both versions of the algorithm, sorted by language.

| language                  | ver              | test               | author               | src link                 | license       |
| :------------------------ | :--------------: | :----------------: | :-----------------   | :----------------------- | :------------ |
| [C#][1cs]                 | [0.1.0][fm1 cs]  | _n/a_              | [Collin Dillinger]   | [Gist][fm c#]            | public domain |
| [C#][2cs]                 | [0.2.0][fm2 cs]  | _n/a_              | [@theor]             | [PR #13]                 | CC0 1.0       |
| [C++][1cpp]               | [0.1.0][fm1 cpp] | :dart:             | [Forrest Smith]      | [GitHub][fm1cpp cb72472] | public domain |
| [C++][2cpp]               | [0.2.0][fm2 cpp] | :dart:             | [Forrest Smith]      | [GitHub][fm2cpp d541eb4] | public domain |
| [Delphi/FreePascal][2pas] | [0.2.0][fm2 pas] | :heavy_check_mark: | [j.visser]           | [Gist][fm pas]           | CC0 1.0       |
| [Elixir][2ex]             | [0.2.0][fm2 ex]  | _n/a_              | [@WolfDan]           | [Gist][fm ex]            | MIT           |
| [F#][1fsx]                | [0.1.0][fm1 fs]  | _n/a_              | [Xavier Zwirtz]      | [GitHub][fm f#]          | MIT           |
| [JavaScript][1js]         | [0.1.0][fm1 js]  | :heavy_check_mark: | [Forrest Smith]      | [GitHub][fm1js 08a4bb1]  | public domain |
| [JavaScript][2js]         | [0.2.0][fm2 js]  | :heavy_check_mark: | [@nrgwsth]           | [PR #10]                 | public domain |
| [Kotlin][2kt]             | [0.2.0][fm2 kt]  | :heavy_check_mark: | [Michael Bikovitsky] | [PR #20]                 | CC0 1.0       |
| [Lua][1lua]               | [0.1.0][fm1 lua] | _n/a_              | [Blake Mealey]       | [GitHub][fm lua]         | public domain |
| [PHP][1php]               | [0.1.0][fm1 php] | _n/a_              | [@detectiveYarmas]   | [GitHub][fm php]         | CC0 1.0       |
| [PureBasic][1pb]          | [0.1.0][fm1 pb]  | :heavy_check_mark: | [Tristano Ajmone]    | n/a                      | CC0 1.0       |
| [Python][1py]             | [0.1.0][fm1 py]  | _n/a_              | [Matt Menzenski]     | [Gist][fm py]            | MIT           |

The __test__ column indicates whether a given implementation of the algorithm has been tested against the original C++ target :dart: implementation of the same version for identical behaviour.
A :heavy_check_mark: indicates that the test succeeds, a :x: that it fails, and _n/a_ that currently there is no test code for that implementation (see [Issue #17]).

> __HELP NEEDED!__ — I need help to create the missing tests for the various languages ports (see [Issue #17]).

I've started out by including in this project the code of all the licensed ports that I've come across, and contacting the authors of those ports that don't have a clear or explicit license to ask them permission to include them here.

If you know of any other __fts_fuzzy_match__ implementation which is not listed here, please [open an Issue] and let me know.

> __DISCLAIMER__ — I haven't had a chance to fully test all these ports, so I cannot guarantee for their quality and accuracy, not until we'll have a test in place for each implementation.
> But I've studied their source enough to establish that they are indeed implementation of the algorithm, and not malicious code.

For guidelines on how to port and test the algorithms to a new language, see the [`PORTING.md`][PORTING.md] document.


# FTS Fuzzy Match Derivatives

Here are some links to adaptations of Forrest's algorithm.

| language | version |     author     |        link        | license |
|----------|---------|----------------|--------------------|---------|
| Go       | 0.1.0   | [Sahil Muthoo] | [GitHub][fuzzy go] | MIT     |

Due to the presence of custom tweaks, they diverge from the original algorithm and don't qualify as __fts_fuzzy_match__ ports (although they might still closely resemble it).

# FTS Fuzzy Match Wrappers

Here's a list of wrappers to [`fts_fuzzy_match.h`][fm1 cpp] in various languages.

|    name    | language |     author    | license |
|------------|----------|---------------|---------|
| [nimfuzzy] | Nim      | [@genotrance] | MIT     |


<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

[Jon Skinner posted on reddit]: https://www.reddit.com/r/programming/comments/4cfz8r/reverse_engineering_sublime_texts_fuzzy_match/d1i7unr/ "Read Jon Skinner's feedback on Forrest article, on reddit"

<!-- editors -->

[Sublime Text]: https://www.sublimetext.com/ "Visit Sublime Text website"
[VS Code]: https://code.visualstudio.com/ "Visit Visual Studio Code website"

<!-- libraries -->

[lib_fts]: https://github.com/forrestthewoods/lib_fts
[fts_fuzzy_match]: https://github.com/forrestthewoods/lib_fts
[nimfuzzy]: https://github.com/genotrance/nimfuzzy

<!-- articles -->

[Reverse Engineering Sublime Text’s Fuzzy Match]: https://www.forrestthewoods.com/blog/reverse_engineering_sublime_texts_fuzzy_match/ "Read Forrest Smith's article"

<!-- people -->

[@detectiveYarmas]: https://github.com/detectiveYarmas "View @detectiveYarmas's GitHub profile"
[@genotrance]: https://github.com/genotrance "View @genotrance's GitHub profile"
[@nrgwsth]: https://github.com/nrgwsth "View @nrgwsth's GitHub profile"
[@theor]: https://github.com/theor "View @theor's GitHub profile"
[@WolfDan]: https://github.com/WolfDan "View @WolfDan's GitHub profile"
[Blake Mealey]: https://github.com/blake-mealey "View Blake Mealey's GitHub profile"
[Collin Dillinger]: https://github.com/CDillinger "View Collin Dillinger's GitHub profile"
[Forrest Smith]: https://github.com/forrestthewoods "View Forrest Smith's GitHub profile"
[j.visser]: https://github.com/GolezTrol "View j.visser's GitHub profile"
[jskinner]: https://www.reddit.com/user/jskinner/ "View Jon Skinner Reddit profile"
[Matt Menzenski]: https://github.com/menzenski "View Matt Menzenski's GitHub profile"
[Michael Bikovitsky]: https://github.com/mbikovitsky "View Michael Bikovitsky's GitHub profile"
[Sahil Muthoo]: https://github.com/sahilm "View Sahil Muthoo's GitHub profile"
[Tristano Ajmone]: https://github.com/tajmone "View Tristano Ajmone's GitHub profile"
[Xavier Zwirtz]: https://github.com/xavierzwirtz "View Xavier Zwirtz's GitHub profile"


<!-- FTS Fuzzy Match  -------------------------------------------------------->

<!-- PRs & commits  -->

[PR #10]: https://github.com/tajmone/fuzzy-search/pull/10 "View original pull request"
[PR #13]: https://github.com/tajmone/fuzzy-search/pull/13 "View original pull request"
[PR #20]: https://github.com/tajmone/fuzzy-search/pull/20 "View original pull request"

<!-- upstream sources -->

[fm1cpp cb72472]: https://github.com/forrestthewoods/lib_fts/blob/cb72472b92dfa4242af55763f9cfd254ab66d423/code/fts_fuzzy_match.h "View upstream source of 'fts_fuzzy_match.h' v0.1.0 from commit cb72472"
[fm1js 08a4bb1]: https://github.com/forrestthewoods/lib_fts/blob/08a4bb1883cc70480020bca549894135ae08d8f5/code/fts_fuzzy_match.js "View upstream source of 'fts_fuzzy_match.js' v0.1.0 from commit 08a4bb1"
[fm2cpp d541eb4]: https://github.com/forrestthewoods/lib_fts/blob/d541eb49b289a03320fb62150b8fd01364e22403/code/fts_fuzzy_match.h "View upstream source of 'fts_fuzzy_match.h' v0.2.0 from commit d541eb4"

<!-- upstream ports -->

[fm c#]: https://gist.github.com/CDillinger/2aa02128f840bdca90340ce08ee71bc2 "View the C# port of fts_fuzzy_match v0.1.0, by Collin Dillinger"
[fm ex]: https://gist.github.com/WolfDan/7cef2973d1fcae8f8e84c00b0a959fc8 "View the Elixir port of fts_fuzzy_match v0.2.0, by @WolfDan"
[fm f#]: https://github.com/xavierzwirtz/lib_fts/blob/939fc8730334a97156ca1e0791ae11250154a1f4/code/fts_fuzzy_match.fsx "View the F# port of fts_fuzzy_match v0.1.0, by Xavier Zwirtz"
[fm lua]: https://gist.github.com/blake-mealey/f7752f95aed71fe23428abb0ffba2c96 "View the Lua port of fts_fuzzy_match v0.1.0, by Blake Mealey"
[fm pas]: https://gist.github.com/GolezTrol/ebe9842df38b8b641c2a044d8b6dbd1e "View the Delphi/FreePascal port of fts_fuzzy_match v0.2.0, by j.visser"
[fm php]: https://github.com/detectiveYarmas/lib_fts/blob/master/code/fts_fuzzy_match.php "View the PHP port of fts_fuzzy_match v0.1.0, by @detectiveYarmas"
[fm py]: https://gist.github.com/menzenski/f0f846a254d269bd567e2160485f4b89 "View the Python port of fts_fuzzy_match v0.1.0, by Matt Menzenski"

<!-- upstream derivatives -->

[fuzzy go]: https://github.com/sahilm/fuzzy/blob/master/fuzzy.go "View the Go adaptation of fts_fuzzy_match v0.1.0, by Sahil Muthoo"

<!-- project links ----------------------------------------------------------->

[open an Issue]: https://github.com/tajmone/fuzzy-search/issues/new "Open an Issue at tajmone/fuzzy-search"

<!-- project folders -->

[1cpp]: ./0.1.0/cpp/       "Navigate to C++ algorithm v0.1.0"
[1cs]:  ./0.1.0/csharp/    "Navigate to C# algorithm v0.1.0"
[1fsx]: ./0.1.0/fsharp/    "Navigate to F# algorithm v0.1.0"
[1js]:  ./0.1.0/js/        "Navigate to JavaScript algorithm v0.1.0"
[1lua]: ./0.1.0/lua/       "Navigate to Lua algorithm v0.1.0"
[1pb]:  ./0.1.0/purebasic/ "Navigate to PureBasic algorithm v0.1.0"
[1php]: ./0.1.0/php/       "Navigate to PHP algorithm v0.1.0"
[1py]:  ./0.1.0/python/    "Navigate to Python algorithm v0.1.0"
[2cpp]: ./0.2.0/cpp/       "Navigate to C++ algorithm v0.2.0"
[2cs]:  ./0.2.0/csharp/    "Navigate to C# algorithm v0.2.0"
[2ex]:  ./0.2.0/elixir/    "Navigate to Elixir algorithm v0.2.0"
[2js]:  ./0.2.0/js/        "Navigate to JavaScript algorithm v0.2.0"
[2kt]:  ./0.2.0/kotlin/    "Navigate to Kotlin algorithm v0.2.0"
[2pas]: ./0.2.0/delphi/    "Navigate to Delphi/FreePascal algorithm v0.2.0"

<!-- project files -->

[expect1]: ./0.1.0/expected_results.txt "Expected test results for v0.1.0"
[expect2]: ./0.2.0/expected_results.txt "Expected test results for v0.2.0"
[PORTING.md]: ./PORTING.md "Porting and testing guidelines"
[fm md]: ./fuzzy_match.md "View the original documentation of fts_fuzzy_match"

[fm1 cpp]: ./0.1.0/cpp/fts_fuzzy_match.h        "C++ implementation of 'fts_fuzzy_match' v0.1.0"
[fm1 cs]:  ./0.1.0/csharp/FuzzyMatch.cs         "C# implementation of 'fts_fuzzy_match' v0.1.0"
[fm1 fs]:  ./0.1.0/fsharp/fts_fuzzy_match.fsx   "F# implementation of 'fts_fuzzy_match' v0.1.0"
[fm1 js]:  ./0.1.0/js/fts_fuzzy_match.js        "JavaScript implementation of 'fts_fuzzy_match' v0.1.0"
[fm1 lua]: ./0.1.0/lua/fts_fuzzy_match.lua      "Lua implementation of 'fts_fuzzy_match' v0.1.0"
[fm1 pb]:  ./0.1.0/purebasic/mod_FuzzyMatch.pbi "PureBasic implementation of 'fts_fuzzy_match' v0.1.0"
[fm1 php]: ./0.1.0/php/fts_fuzzy_match.php      "PHP implementation of 'fts_fuzzy_match' v0.1.0"
[fm1 py]:  ./0.1.0/python/fts_fuzzy_match.py    "Python implementation of 'fts_fuzzy_match' v0.1.0"
[fm2 cpp]: ./0.2.0/cpp/fts_fuzzy_match.h        "C++ implementation of 'fts_fuzzy_match' v0.1.0"
[fm2 cs]:  ./0.2.0/csharp/FuzzyMatch.cs         "C# implementation of 'fts_fuzzy_match' v0.2.0"
[fm2 ex]:  ./0.2.0/elixir/fts_fuzzy_match.ex    "Elixir implementation of 'fts_fuzzy_match' v0.2.0"
[fm2 js]:  ./0.2.0/js/fts_fuzzy_match.js        "JavaScript implementation of 'fts_fuzzy_match' v0.2.0"
[fm2 kt]:  ./0.2.0/kotlin/FuzzyMatch.kt         "Kotlin implementation of 'fts_fuzzy_match' v0.2.0"
[fm2 pas]: ./0.2.0/delphi/uFuzzyMatching.pas    "Delphi/FreePascal implementation of 'fts_fuzzy_match' v0.2.0"

<!-- Issues -->

[Issue #17]: https://github.com/tajmone/fuzzy-search/issues/17 "Issue #17 — Help: Fuzzy Match Ports with Missing Tests"

<!-- EOF -->
