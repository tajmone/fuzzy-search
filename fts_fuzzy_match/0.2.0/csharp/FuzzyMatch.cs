using System;

namespace FuzzyMatch
{
    public class Fts
    {
        public static bool FuzzyMatchSimple(string pattern, string str)
        {
            var patternIdx = 0;
            var strIdx = 0;
            var patternLength = pattern.Length;
            var strLength = str.Length;

            while (patternIdx != patternLength && strIdx != strLength)
            {
                var patternChar = char.ToLowerInvariant(pattern[patternIdx]);
                var strChar = char.ToLowerInvariant(str[strIdx]);
                if (patternChar == strChar) ++patternIdx;
                ++strIdx;
            }

            return patternLength != 0 && strLength != 0 && patternIdx == patternLength;
        }
        
        public static bool FuzzyMatch(string pattern, string str, out int outScore)
        {
            byte[] matches = new byte[256];
            return FuzzyMatch(pattern, str, out outScore, matches, matches.Length);
        }

        public static bool FuzzyMatch(string pattern, string str, out int outScore, byte[] matches, int maxMatches)
        {
            int recursionCount = 0;
            int recursionLimit = 10;

            return FuzzyMatchRecursive(pattern, str, 0, 0, out outScore, null, matches, maxMatches, 0,
                ref recursionCount, recursionLimit);
        }

        // Private implementation
        static bool FuzzyMatchRecursive(string pattern, string str,
            int patternCurIndex,
            int strCurrIndex, out int outScore,
            byte[] srcMatches, byte[] matches, int maxMatches,
            int nextMatch, ref int recursionCount, int recursionLimit)
        {
            outScore = 0;
            // Count recursions
            ++recursionCount;
            if (recursionCount >= recursionLimit)
                return false;

            // Detect end of strings
            if (patternCurIndex == pattern.Length || strCurrIndex == str.Length)
                return false;

            // Recursion params
            bool recursiveMatch = false;
            byte[] bestRecursiveMatches = new byte[256];
            int bestRecursiveScore = 0;

            // Loop through pattern and str looking for a match
            bool firstMatch = true;
            while (patternCurIndex < pattern.Length && strCurrIndex < str.Length)
            {
                // Found match
                if (Char.ToLowerInvariant(pattern[patternCurIndex]) == Char.ToLowerInvariant(str[strCurrIndex]))
                {
                    // Supplied matches buffer was too short
                    if (nextMatch >= maxMatches)
                        return false;

                    // "Copy-on-Write" srcMatches into matches
                    if (firstMatch && srcMatches != null)
                    {
                        Buffer.BlockCopy(srcMatches, 0, matches, 0, nextMatch);
                        // memcpy(matches, srcMatches, nextMatch);
                        firstMatch = false;
                    }

                    // Recursive call that "skips" this match
                    byte[] recursiveMatches = new byte[256];
                    if (FuzzyMatchRecursive(pattern, str, patternCurIndex, strCurrIndex + 1, out int recursiveScore,
                        matches, recursiveMatches, recursiveMatches.Length, nextMatch, ref recursionCount,
                        recursionLimit))
                    {
                        // Pick best recursive score
                        if (!recursiveMatch || recursiveScore > bestRecursiveScore)
                        {
                            Buffer.BlockCopy(recursiveMatches, 0, bestRecursiveMatches, 0, 256);
                            // memcpy(bestRecursiveMatches, recursiveMatches, 256);
                            bestRecursiveScore = recursiveScore;
                        }

                        recursiveMatch = true;
                    }

                    // Advance
                    matches[nextMatch++] = (byte) strCurrIndex;
                    ++patternCurIndex;
                }

                ++strCurrIndex;
            }

            // Determine if full pattern was matched
            bool matched = patternCurIndex == pattern.Length;

            // Calculate score
            if (matched)
            {
                const int sequentialBonus = 15; // bonus for adjacent matches
                const int separatorBonus = 30; // bonus if match occurs after a separator
                const int camelBonus = 30; // bonus if match is uppercase and prev is lower
                const int firstLetterBonus = 15; // bonus if the first letter is matched

                const int leadingLetterPenalty = -5; // penalty applied for every letter in str before the first match
                const int maxLeadingLetterPenalty = -15; // maximum penalty for leading letters
                const int unmatchedLetterPenalty = -1; // penalty for every letter that doesn't matter

                // Iterate str to end
                strCurrIndex = str.Length;

                // Initialize score
                outScore = 100;

                // Apply leading letter penalty
                int penalty = leadingLetterPenalty * matches[0];
                if (penalty < maxLeadingLetterPenalty)
                    penalty = maxLeadingLetterPenalty;
                outScore += penalty;
                // Apply unmatched penalty
                int unmatched = strCurrIndex - nextMatch;
                outScore += unmatchedLetterPenalty * unmatched;
                // Apply ordering bonuses
                for (int i = 0; i < nextMatch; ++i)
                {
                    byte currIdx = matches[i];

                    if (i > 0)
                    {
                        byte prevIdx = matches[i - 1];

                        // Sequential
                        if (currIdx == (prevIdx + 1))
                            outScore += sequentialBonus;
                    }

                    // Check for bonuses based on neighbor character value
                    if (currIdx > 0)
                    {
                        // Camel case
                        char neighbor = str[currIdx - 1];
                        char curr = str[currIdx];
                        // the js impl does neighbor === neighbor.toLowerCase() && curr === curr.toUpperCase()
                        // as lowering/upping a digit returns the same digit, it counts as a camel bonus
                        if (Char.IsLower(neighbor) && Char.IsUpper(curr))
                            outScore += camelBonus;

                        // Separator
                        bool neighborSeparator = neighbor == '_' || neighbor == ' ' || char.IsDigit(neighbor);
                        if (neighborSeparator)
                            outScore += separatorBonus;
                    }
                    else
                    {
                        // First letter
                        outScore += firstLetterBonus;
                    }
                }
            }

            // Return best result
            if (recursiveMatch && (!matched || bestRecursiveScore > outScore))
            {
                // Recursive score is better than "this"
                Buffer.BlockCopy(bestRecursiveMatches, 0, matches, 0, maxMatches);
                // memcpy(matches, bestRecursiveMatches, maxMatches);
                outScore = bestRecursiveScore;
                return true;
            }
            else if (matched)
            {
                // "this" score is better than recursive
                return true;
            }
            else
            {
                // no match
                return false;
            }
        }
    }
}
