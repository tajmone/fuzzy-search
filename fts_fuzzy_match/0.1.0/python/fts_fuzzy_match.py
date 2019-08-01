#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
MIT License

Copyright (c) 2016 Matt Menzenski

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""

from __future__ import unicode_literals


def fuzzy_match_simple(pattern, instring):
    """Return True if each character in pattern is found in order in instring.

    :param pattern: the pattern to be matched
    :type pattern: ``str``
    :param instring: the containing string to search against
    :type instring: ``str``

    :return: True if there is a match, False otherwise
    :rtype: ``bool``
    """
    p_idx, s_idx, p_len, s_len = 0, 0, len(pattern), len(instring)
    while (p_idx != p_len) and (s_idx != s_len):
        if pattern[p_idx].lower() == instring[s_idx].lower():
            p_idx += 1
        s_idx += 1
    return p_len != 0 and s_len != 0 and p_idx == p_len


def fuzzy_match(pattern, instring, adj_bonus=5, sep_bonus=10, camel_bonus=10,
                lead_penalty=-3, max_lead_penalty=-9, unmatched_penalty=-1):
    """Return match boolean and match score.

    :param pattern: the pattern to be matched
    :type pattern: ``str``
    :param instring: the containing string to search against
    :type instring: ``str``
    :param int adj_bonus: bonus for adjacent matches
    :param int sep_bonus: bonus if match occurs after a separator
    :param int camel_bonus: bonus if match is uppercase
    :param int lead_penalty: penalty applied for each letter before 1st match
    :param int max_lead_penalty: maximum total ``lead_penalty``
    :param int unmatched_penalty: penalty for each unmatched letter

    :return: 2-tuple with match truthiness at idx 0 and score at idx 1
    :rtype: ``tuple``
    """
    score, p_idx, s_idx, p_len, s_len = 0, 0, 0, len(pattern), len(instring)
    prev_match, prev_lower = False, False
    prev_sep = True  # so that matching first letter gets sep_bonus
    best_letter, best_lower, best_letter_idx = None, None, None
    best_letter_score = 0
    matched_indices = []

    while s_idx != s_len:
        p_char = pattern[p_idx] if (p_idx != p_len) else None
        s_char = instring[s_idx]
        p_lower = p_char.lower() if p_char else None
        s_lower, s_upper = s_char.lower(), s_char.upper()

        next_match = p_char and p_lower == s_lower
        rematch = best_letter and best_lower == s_lower

        advanced = next_match and best_letter
        p_repeat = best_letter and p_char and best_lower == p_lower

        if advanced or p_repeat:
            score += best_letter_score
            matched_indices.append(best_letter_idx)
            best_letter, best_lower, best_letter_idx = None, None, None
            best_letter_score = 0

        if next_match or rematch:
            new_score = 0

            # apply penalty for each letter before the first match
            # using max because penalties are negative (so max = smallest)
            if p_idx == 0:
                score += max(s_idx * lead_penalty, max_lead_penalty)

            # apply bonus for consecutive matches
            if prev_match:
                new_score += adj_bonus

            # apply bonus for matches after a separator
            if prev_sep:
                new_score += sep_bonus

            # apply bonus across camelCase boundaries
            if prev_lower and s_char == s_upper and s_lower != s_upper:
                new_score += camel_bonus

            # update pattern index iff the next pattern letter was matched
            if next_match:
                p_idx += 1

            # update best letter match (may be next or rematch)
            if new_score >= best_letter_score:
                # apply penalty for now-skipped letter
                if best_letter is not None:
                    score += unmatched_penalty
                best_letter = s_char
                best_lower = best_letter.lower()
                best_letter_idx = s_idx
                best_letter_score = new_score

            prev_match = True

        else:
            score += unmatched_penalty
            prev_match = False

        prev_lower = s_char == s_lower and s_lower != s_upper
        prev_sep = s_char in '_ '

        s_idx += 1

    if best_letter:
        score += best_letter_score
        matched_indices.append(best_letter_idx)

    return p_idx == p_len, score