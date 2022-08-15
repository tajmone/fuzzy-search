# Programming Notes

This document is a short write-up on the changes I made to the original when
porting it to C, and the rationale for those changes. Hopefully you'll find it
educational or interesting.


## Rationale

The original v0.2.0 algorithm felt like it was a little bit more complex than
necessary to solve the given problem (I didn't really understand what was going
on with the matches[256] array), and I didn't really fancy doing a naïve
translation. I therefore approached this rewrite by starting again from v0.1.0,
with the v0.2.0 goal of finding the best possible match.


### Score dependencies

The first step is to separate out the scoring code into its own function. Doing
so makes it clear exactly what the requirements to calculate a letter's score
are. Consider the prototype for the `compute_score` function below:

```c
int32_t compute_score(int32_t jump, bool first_char, const char *restrict match);
```

- `jump` is how many characters we've had to skip to get to the current
  matching letter.
- `first_char` tells us if this is the first pattern character to be matched
  (and could be eliminated by special-casing the first character)
- `match` is our current location in the string (rather than the current
  character, as we need to check the previous character as well for CamelCasing
  and separators).

Basically, we only need to know information about the current and the previous
matching character. There's also the unused character penalty to consider, but
that's simply `strlen(str) - strlen(pattern)` - it's independent of where the
matches occur.


### Finding the best match

It's fairly clear that the simplest way to find the best possible match is to
find every match, then choose the best one. To find every match, think about
what happens when you're just looking for a single character in the target
string, and you find one. You have two choices:

- Match this character, and start looking from here for the next pattern
  character.
- Skip this character, and keep looking.

Applying this repeatedly, and charting the decisions made (with their
corresponding scores), a tree structure quickly becomes apparent:

![tree](tree-light.svg#gh-light-mode-only)
![tree](tree-dark.svg#gh-dark-mode-only)

(Not shown above are failed submatches, such as if the last t in `that` were to
be matched - there's no subsequent h's to match. Such nodes are flagged as
failures by giving them a score of `INT32_MIN`).

My first attempt actually constructed this tree, then searched through it for
the best submatch. The problem with this is that to store every branch, the
required amount of memory is exponential(!) in the length of the pattern and
very quickly becomes untenable.

However, with the relative independence of the score calculation in mind, a
better solution presents itself. We're already "walking" this tree in order to
construct it - in the diagram above, we visit every branch from left to right.
We can also calculate scores while we're doing this walk, at which point
there's no need to actually store the whole tree. Every node just takes the
best score of its subtrees (if any were found), adds its own score, and returns
that to the node above. Effectively, we're doing a depth-first search of the
whole tree, without ever constructing it.


### Problems and further considerations

There's still one obvious problem with this improved algorithm, namely the
unbounded recursion depth. With this example code, in a language like C, this
is unlikely to matter - the maximum recursion depth is equal to
`strlen(pattern) + 1`, and each call only takes ~100 bytes of stack space. For
a 1MB stack, that's around 10000 levels of recursion before there's a problem,
which is extremely unlikely to occur in the sorts of programs fuzzy matching is
used in. Still, there are ways round it if required:

- Track the recursion depth and cap it.
- For a given pattern length, the maximum required stack usage is known, so you
  could `malloc` a stack and "fake" the recursive function call with some for
  loops.
- Look into more advanced algorithms, like [non-deterministic finite
  automata](https://swtch.com/%7Ersc/regexp/regexp1.html).


Another problem is that while we always find the best match, we don't know what
that match was. This might be good information to have so we can e.g. highlight
the matching characters. I think it should be possible to track this, however,
with some extra buffers - something like `strlen(pattern)` buffers, of lengths
`1,2,...,strlen(pattern)`. Implementing this is left as an exercise for the
reader (for now).
