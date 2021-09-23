private const val SEQUENTIAL_BONUS = 15     // bonus for adjacent matches
private const val SEPARATOR_BONUS = 30      // bonus if match occurs after a separator
private const val CAMEL_BONUS = 30          // bonus if match is uppercase and prev is lower
private const val FIRST_LETTER_BONUS = 15   // bonus if the first letter is matched

private const val LEADING_LETTER_PENALTY =
    -5 // penalty applied for every letter in str before the first match
private const val MAX_LEADING_LETTER_PENALTY = -15 // maximum penalty for leading letters
private const val UNMATCHED_LETTER_PENALTY = -1 // penalty for every letter that doesn't matter

/**
 * Holds the results of a fuzzy match.
 *
 * @property match  Whether each character in the pattern appears in the test string in order.
 * @property score  The match score. Higher is better.
 */
data class FuzzyMatchResult(val match: Boolean, val score: Int)

/**
 * Returns `true` if each character in [pattern] is found sequentially within [str].
 *
 * @param pattern   The pattern to search for.
 * @param str       The string to search inside.
 */
fun fuzzyMatchSimple(pattern: String, str: String): Boolean {
    var patternIdx = 0
    var strIdx = 0

    while (patternIdx != pattern.length && strIdx != str.length) {
        val patternChar = pattern[patternIdx].lowercaseChar()
        val strChar = str[strIdx].lowercaseChar()
        if (patternChar == strChar) ++patternIdx
        ++strIdx
    }

    return pattern.isNotEmpty() && str.isNotEmpty() && patternIdx == pattern.length
}

/**
 * Performs a fuzzy match.
 *
 * @param pattern   The pattern to search for.
 * @param str       The string to search inside.
 */
fun fuzzyMatch(pattern: String, str: String): FuzzyMatchResult {
    val matches = ByteArray(256)
    return fuzzyMatchRecursive(
        pattern,
        str,
        0,
        0,
        null,
        matches,
        matches.size,
        0,
        0,
        10
    )
}

private fun fuzzyMatchRecursive(
    pattern: String,
    str: String,
    patternCurIndex: Int,
    strCurrIndex: Int,
    srcMatches: ByteArray?,
    matches: ByteArray,
    maxMatches: Int,
    nextMatch: Int,
    recursionCount: Int,
    recursionLimit: Int
): FuzzyMatchResult {
    var outScore = 0

    // Count recursions
    @Suppress("NAME_SHADOWING") val recursionCount = recursionCount + 1
    if (recursionCount >= recursionLimit) {
        return FuzzyMatchResult(false, outScore)
    }

    // Detect end of strings
    if (patternCurIndex == pattern.length || strCurrIndex == str.length) {
        return FuzzyMatchResult(false, outScore)
    }

    // Recursion params
    var recursiveMatch = false
    val bestRecursiveMatches = ByteArray(256)
    var bestRecursiveScore = 0

    @Suppress("NAME_SHADOWING") var patternCurIndex = patternCurIndex
    @Suppress("NAME_SHADOWING") var strCurrIndex = strCurrIndex
    @Suppress("NAME_SHADOWING") var nextMatch = nextMatch

    // Loop through pattern and str looking for a match
    var firstMatch = true
    while (patternCurIndex < pattern.length && strCurrIndex < str.length) {
        // Found match
        if (pattern[patternCurIndex].lowercaseChar() == str[strCurrIndex].lowercaseChar()) {
            // Supplied matches buffer was too short
            if (nextMatch >= maxMatches) {
                return FuzzyMatchResult(false, outScore)
            }

            // "Copy-on-Write" srcMatches into matches
            if (firstMatch && srcMatches != null) {
                srcMatches.copyInto(matches, 0, 0, nextMatch)
                firstMatch = false
            }

            // Recursive call that "skips" this match
            val recursiveMatches = ByteArray(256)
            val (matched, recursiveScore) = fuzzyMatchRecursive(
                pattern,
                str,
                patternCurIndex,
                strCurrIndex + 1,
                matches,
                recursiveMatches,
                recursiveMatches.size,
                nextMatch,
                recursionCount,
                recursionLimit
            )
            if (matched) {
                // Pick best recursive score
                if (!recursiveMatch || recursiveScore > bestRecursiveScore) {
                    recursiveMatches.copyInto(bestRecursiveMatches, 0, 0, 256)
                    bestRecursiveScore = recursiveScore
                }

                recursiveMatch = true
            }

            // Advance
            matches[nextMatch++] = strCurrIndex.toByte()
            ++patternCurIndex
        }

        ++strCurrIndex
    }

    // Determine if full pattern was matched
    val matched = patternCurIndex == pattern.length

    // Calculate score
    if (matched) {
        // Iterate str to end
        strCurrIndex = str.length

        // Initialize score
        outScore = 100

        // Apply leading letter penalty
        var penalty = LEADING_LETTER_PENALTY * matches[0]
        if (penalty < MAX_LEADING_LETTER_PENALTY) {
            penalty = MAX_LEADING_LETTER_PENALTY
        }
        outScore += penalty

        // Apply unmatched penalty
        val unmatched = strCurrIndex - nextMatch
        outScore += UNMATCHED_LETTER_PENALTY * unmatched

        // Apply ordering bonuses
        for (i in 0 until nextMatch) {
            val currIdx = matches[i].toUByte().toInt()

            if (i > 0) {
                val prevIdx = matches[i - 1].toUByte().toInt()

                // Sequential
                if (currIdx == prevIdx + 1) {
                    outScore += SEQUENTIAL_BONUS
                }
            }

            // Check for bonuses based on neighbor character value
            if (currIdx > 0) {
                // Camel case
                val neighbor = str[currIdx - 1]
                val curr = str[currIdx]
                if (neighbor.isLowerCase() && curr.isUpperCase()) {
                    outScore += CAMEL_BONUS
                }

                // Separator
                val neighborSeparator = neighbor == '_' || neighbor == ' ' || neighbor.isDigit()
                if (neighborSeparator) {
                    outScore += SEPARATOR_BONUS
                }
            } else {
                // First letter
                outScore += FIRST_LETTER_BONUS
            }
        }
    }

    // Return best result
    return if (recursiveMatch && (!matched || bestRecursiveScore > outScore)) {
        // Recursive score is better than "this"
        bestRecursiveMatches.copyInto(matches, 0, 0, maxMatches)
        outScore = bestRecursiveScore
        FuzzyMatchResult(true, outScore)
    } else if (matched) {
        // "this" score is better than recursive
        FuzzyMatchResult(true, outScore)
    } else {
        // no match
        FuzzyMatchResult(false, outScore)
    }
}
