# Fuzzy Search

- https://github.com/tajmone/fuzzy-search

A collection of algorithms to implement fuzzy search like in [Sublime Text], in various languages, based on [Forrest Smith]'s __[fts_fuzzy_match]__ algorithms, as well as an [authorized AsciiDoc reproduction] ([Live HTML Preview]) of the original
_[Reverse Engineering Sublime Text’s Fuzzy Match]_ article by Forrest Smith, 2016.

Project created by [Tristano Ajmone] in July 19, 2019.

-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Project Contents](#project-contents)
- [Introduction](#introduction)
- [About This Project](#about-this-project)
- [License](#license)

<!-- /MarkdownTOC -->

-----

# Project Contents

- [`/article/`](./article/) — _Reverse Engineering Sublime Text’s Fuzzy Match_ article by [Forrest Smith], 2016 ([Live HTML Preview]).
- [`/dataset/`](./dataset/) — sample data sets for testing the algorithms.
- [`/fts_fuzzy_match/`](./fts_fuzzy_match/) — [Forrest Smith]'s fuzzy search algorithm and its ports to various languages:
    + [`/0.1.0/`](./fts_fuzzy_match/0.1.0/) — original algorithm based on the 2016 article.
    + [`/0.2.0/`](./fts_fuzzy_match/0.2.0/) — improved "exhaustive search" version based on Jon Skinner feedback, 2017.
- [`LICENSE`][LICENSE] — CC0 license (might not apply to third party assets).

# Introduction

In March 2016, Forrest Smith published an inspiring article entitled _[Reverse Engineering Sublime Text’s Fuzzy Match]_, with the following premise:

> One of my favorite features of Sublime Text is it’s [_sic_] fuzzy search algorithm. It’s blistering fast at navigating to files and functions. Many people on the internet have asked how it works. None of the answers were satisfying. So I decided to figure it out myself.

Along with the article, Forrest also published __[fts_fuzzy_match]__, a sample implementation of the algorithm (in C++ and JavaScript) in his __[lib_fts]__ collection of single-file public domain libraries.

The article and __fts_fuzzy_match__ sparkled a wave of interest on the topic, which led to numerous improvement suggestions from various authors — [including Sublime Text author Jon Skinner] — and a number of ports of __fts_fuzzy_match__ to other languages.

In June, 2021, Forrest Smith kindly granted me permission to reproduce in this repository his _[Reverse Engineering Sublime Text’s Fuzzy Match]_ article, in AsciiDoc format, which you'll now find inside the [`/article/`](./article/) folder.

# About This Project

The goal of this project is to gather resources and sample implementations of fuzzy search algorithms aimed at building fuzzy search controls like those found in [Sublime Text], [VS Code] and other modern editors — hence the choice of the more colloquial "fuzzy search" term, instead of "fuzzy matching" or "approximate string matching", in an attempt to delimit the scope of a wide field of algorithms which find application in a variety of other contexts, like spell-checking.

I chose to build the project around [Forrest Smith]'s __[fts_fuzzy_match]__ and his article because they offer a good starting point to understand how fuzzy search algorithms work.
Both his article and the code are easy to understand and written for educational purposes, making accessible to anyone what usually belongs to the domain of academia initiates.

Also, because Forrest generously released his __[fts_fuzzy_match]__ code under public domain, third parties have ported the code to various other languages, which further simplifies studying the code and implementing it in new languages — and turning __[fts_fuzzy_match]__into the Rosetta Stone of fuzzy search.

I decided to gather into a single repository the various implementations of __fts_fuzzy_match__ available in different languages, and separating in different folders implementations of v0.1.0 and v0.2.0 of the algorithm — the latter being an improved version, based on the feedback from Sublime Text author Jon Skinner to the _[Reverse Engineering Sublime Text’s Fuzzy Match]_ article.

From here, the next goal is to start looking into how various open source editors have implemented fuzzy search functionality, compare them to Forrest's algorithm and discover how to improve and optimize it, both in general as well as for specific use case scenarios.
Forrest's article was followed by many constructive comments which are worth exploring, to optimize the code or discover alternative approaches to fuzzy search.

I hope that in the course of time this repository and its Wiki might become a language-agnostic point of reference for anyone wishing to learn fuzzy search algorithms, offering documentation and code examples that range from the simple proof of concept implementation to more advanced techniques and approaches.

# License

Any third party assets included in this project are governed by their original license — which is always indicated in the relevant README file or by a license file inside the asset folder.

As for the various assets created by [Tristano Ajmone]  (the project maintainer), they are released under [Creative Commons Zero v1.0 Universal] license:

- [`LICENSE`][LICENSE]

Unless otherwise specified, the above license applies to all markdown documents, README files, project configuration files and all other assets created by [Tristano Ajmone], including source code.

All third party assets originally published into the public domain are hereby released under the CC0 license governing the project, to ensure permissibility of use in those countries that don't recognize public domain.

Any third party contribution to existing assets shall fall under the same license of the asset being updated or modified.

This project values Copyright status and third party licenses, and strives hard to credit third parties and honour the license terms of their works; so, please, read thoroughly the documentation before reusing any third party asset from this project, to ensure you get its license right, and always double check before submitting to this project resources created by others.


<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

[including Sublime Text author Jon Skinner]: https://www.reddit.com/r/programming/comments/4cfz8r/reverse_engineering_sublime_texts_fuzzy_match/d1i7unr/ "Read Jon Skinner's feedback on Forrest article, on reddit"
[authorized AsciiDoc reproduction]: ./article/forrest2016.asciidoc "AsciiDoc port of 'Reverse Engineering Sublime Text’s Fuzzy Match' by Forrest Smith, 2016"
[Live HTML Preview]: https://htmlpreview.github.io/?https://github.com/tajmone/fuzzy-search/blob/master/article/forrest2016.html "Live HTML Preview of our reproduction of 'Reverse Engineering Sublime Text’s Fuzzy Match' by Forrest Smith, 2016"

<!-- editors -->

[Sublime Text]: https://www.sublimetext.com/ "Visit Sublime Text website"
[VS Code]: https://code.visualstudio.com/ "Visit Visual Studio Code website"

<!-- libraries -->

[lib_fts]: https://github.com/forrestthewoods/lib_fts
[fts_fuzzy_match]: https://github.com/forrestthewoods/lib_fts

<!-- articles -->

[Reverse Engineering Sublime Text’s Fuzzy Match]: https://www.forrestthewoods.com/blog/reverse_engineering_sublime_texts_fuzzy_match/ "Read Forrest Smith's article"

<!-- people -->

[Forrest Smith]: https://github.com/forrestthewoods "View Forrest Smith's GitHub profile"
[Tristano Ajmone]: https://github.com/tajmone "View Tristano Ajmone's GitHub profile"

<!-- licenses -->

[Creative Commons Zero v1.0 Universal]: https://creativecommons.org/publicdomain/zero/1.0/ "Visit the CC0 1.0 Universal license page at CreativeCommons.org"

<!-- project files -->

[LICENSE]: ./LICENSE "Read the Creative Commons Zero v1.0 Universal license"

<!-- EOF -->
