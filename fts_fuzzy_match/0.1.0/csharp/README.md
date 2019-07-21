# Fuzzy Match v0.1.0 C&num;

C Sharp implementation of the __[fts_fuzzy_match]__ algorithm, ported by [Collin Dillinger]:


- [`FuzzyMatch.cs`](./FuzzyMatch.cs)

Taken from his [public GitHub Gist]  (commit [f596e693], 2016-04-15).

A couple of notes from the code author:

> These are the signatures of the functions included in this code:
>
> ```C#
> public static bool FuzzyMatch(string stringToSearch, string pattern);
> public static bool FuzzyMatch(string stringToSearch, string pattern, out int outScore);
> ```
>
> If you would like to change these methods to extension methods, just add a this keyword before the first parameter:
>
> ```C#
> public static bool FuzzyMatch(this string stringToSearch, string pattern);
> public static bool FuzzyMatch(this string stringToSearch, string pattern, out int outScore);
> ```

# License

[Collin Dillinger] released his source file under the same public domain terms of the original __[fts_fuzzy_match]__ project:

> This software is dual-licensed to the public domain and under the following license: you are granted a perpetual, irrevocable license to copy, modify, publish, and distribute this file as you see fit.



<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

[fts_fuzzy_match]: https://github.com/forrestthewoods/lib_fts

[public GitHub Gist]: https://gist.github.com/CDillinger/2aa02128f840bdca90340ce08ee71bc2 "View original Gist"

[f596e693]: https://gist.github.com/CDillinger/2aa02128f840bdca90340ce08ee71bc2/f596e6931a58ddf7d15e488b70fe20702290d699

<!-- people -->

[Collin Dillinger]: https://github.com/CDillinger "View Collin Dillinger's GitHub profile"

<!-- EOF -->