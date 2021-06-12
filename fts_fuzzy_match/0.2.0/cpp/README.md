# Fuzzy Match v0.2.0 C++

The improved __[fts_fuzzy_match]__ algorithm by [Forrest Smith] described in the 2017 update to his _[Reverse Engineering Sublime Text's Fuzzy Match]_ article, and published in the __[lib_fts]__ project.


-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Folder Contents](#folder-contents)
- [About v0.2.0](#about-v020)
- [License](#license)

<!-- /MarkdownTOC -->

-----

# Folder Contents

- [`fts_fuzzy_match.h`](./fts_fuzzy_match.h) — Fuzzy Match v0.2.0 in C++.

The above file was taken from [Forrest Smith]'s __[lib_fts]__ repository, commit [d541eb4][fm2cpp d541eb4], 2017-02-19.

For the original documentation, see [`../../fuzzy_match.md`][fm md].

For the original v0.1.0 algorithm, see: [`../../0.1.0/cpp/fts_fuzzy_match.h`][fm1cpp].

# About v0.2.0

After one year from the pubblication of Forrest's _[Reverse Engineering Sublime Text's Fuzzy Match]_ article, [Sublime Text] author [Jon Skinner posted on reddit] a comment on Forrest article, confirming the soundness of the overall approach and also providing insights on how to improve the algorithm:

> __[jskinner]__: Sublime Text author here. Nice writeup! The actual algorithm that Sublime Text uses is similar in principle, but the implementation is rather different in the name of speed.
>
> There are a couple of things you may want to tweak for better quality matching: you likely want to search more exhaustively for a better match, e.g., searching for "lll" in the UE4 filename list matches "SVisualLoggerLogsList.h", but not as well as it should, as it doesn't pickup all the upper case Ls. If you don't mind sacrificing a little speed, then it's also nice to handle transpositions, so that "sta" can still match against "SpawnActorTimer", just with a lower score - Sublime Text 3 does this.

Skinner's feedback was a major breakthrough that prompted Forrest to update the __fts_fuzzy_match__ C++ algorithm to v0.2.0 to include the "exhaustive search" suggested by Skinner, and to add the following update note to the original article:


> This project has been updated based on [feedback] from Sublime Text's Jon Skinner. The algorithm now performs an exhaustive search to find all possible matches and returns the match with the highest score.
>
> Consider the string "`SVisualLoggerLogsList.h`" and the search pattern "`LLL`". There are four L's so they can be matched several different ways. The naive approach might match the first three L's. A higher scoring match would skip the first L and match the three CamelCase L's.
>
> ```
> String: SVisualLoggerLogsList.h
>     Pattern: LLL
>
> Possible Matches (in bold):
>     SVisualLoggerLogsList.h
>     SVisualLoggerLogsList.h
>     SVisualLoggerLogsList.h
>     SVisualLoggerLogsList.h
> ```
>
> The new exhaustive method finds all matches and returns the one with the highest score. Performing an exhaustive search is slower than finding just the first match. However the small decrease in speed is more than made up for by the increase in result quality.

# License

All source code from [Forrest Smith]'s __[lib_fts]__ project is released under the following license:

> This software is dual-licensed to the public domain and under the following license: you are granted a perpetual, irrevocable license to copy, modify, publish, and distribute this file as you see fit.


<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

[feedback]: https://www.reddit.com/r/programming/comments/4cfz8r/reverse_engineering_sublime_texts_fuzzy_match/d1i7unr/ "Read Jon Skinner's feedback on Forrest article, on reddit"
[Jon Skinner posted on reddit]: https://www.reddit.com/r/programming/comments/4cfz8r/reverse_engineering_sublime_texts_fuzzy_match/d1i7unr/ "Read Jon Skinner's feedback on Forrest article, on reddit"


<!-- libraries -->

[lib_fts]: https://github.com/forrestthewoods/lib_fts
[fts_fuzzy_match]: https://github.com/forrestthewoods/lib_fts

<!-- articles -->

[Reverse Engineering Sublime Text's Fuzzy Match]: https://www.forrestthewoods.com/blog/reverse_engineering_sublime_texts_fuzzy_match/ "Read Forrest Smith's article"

<!-- people -->

[Forrest Smith]: https://github.com/forrestthewoods "View Forrest Smith's GitHub profile"
[jskinner]: https://www.reddit.com/user/jskinner/ "View Jon Skinner Reddit profile"

<!-- FTS Fuzzy Match  -------------------------------------------------------->

<!-- upstream sources -->

[fm2cpp d541eb4]: https://github.com/forrestthewoods/lib_fts/blob/d541eb49b289a03320fb62150b8fd01364e22403/code/fts_fuzzy_match.h "View upstream source of 'fts_fuzzy_match.h' v0.2.0 from commit d541eb4"

<!-- project files -->

[fm1cpp]: ../../0.1.0/cpp/fts_fuzzy_match.h
[fm md]: ../../fuzzy_match.md "View the original documentation of fts_fuzzy_match"



<!-- EOF -->
