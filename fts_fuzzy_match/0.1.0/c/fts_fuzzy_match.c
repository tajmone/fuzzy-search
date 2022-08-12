#include <ctype.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "fts_fuzzy_match.h"

/*
 * Returns score if each character in pattern is found sequentially within str.
 * Returns INT32_MIN otherwise.
 *
 * Score value has no intrinsic meaning. Range varies with pattern.
 * Score comparisons only make sense with the same search pattern.
 */
int32_t fts_fuzzy_match(const char *restrict pattern, const char *restrict str)
{
	/*
	 * Score consts.
	 */

	/* Bonus for adjacent matches. */
	const int adjacency_bonus = 5;

	/* Bonus if match occurs after a separator. */
	const int separator_bonus = 10;

	/* Bonus if match is uppercase and prev is lower. */
	const int camel_bonus = 10;

	/* Penalty applied for every letter in str before the first match. */
	const int leading_letter_penalty = -3;

	/* Maximum penalty for leading letters. */
	const int max_leading_letter_penalty = -9;

	/* Penalty for every letter that doesn't matter. */
	const int unmatched_letter_penalty = -1;


	/*
	 * Loop variables.
	 */

	int32_t score = 0;
	const char *pattern_iter = pattern;
	const char *str_iter = str;
	bool prev_matched = false;
	bool prev_lower = false;

	/*
	 * Initialise to true so that if the first letter matches, it gets the
	 * separator bonus.
	 */
	bool prev_separator = true;

	/*
	 * Use "best" matched letter if multiple string letters match the
	 * pattern.
	 */
	const char *best_letter = NULL;
	int best_letter_score = 0;


	/* Loop over substrings. */
	while (*str_iter != '\0') {
		const char pattern_letter = *pattern_iter;
		const char str_letter = *str_iter;

		bool next_match = pattern_letter != '\0'
			&& tolower(pattern_letter) == tolower(str_letter);

		bool rematch = best_letter
			&& tolower(*best_letter) == tolower(str_letter);

		bool advanced = next_match && best_letter;
		bool pattern_repeat = best_letter
			&& pattern_letter != '\0'
			&& tolower(*best_letter) == tolower(pattern_letter);

		if (advanced || pattern_repeat) {
			score += best_letter_score;
			best_letter = NULL;
			best_letter_score = 0;
		}

		if (next_match || rematch) {
			int new_score = 0;

			/*
			 * Apply penalty for each letter before the first
			 * pattern match.
			 *
			 * Note: use max because penalties are negative values,
			 * so max value is the smallest penalty.
			 */
			if (pattern_iter == pattern) {
				int count = str_iter - str;
				int penalty = leading_letter_penalty * count;
				if (penalty < max_leading_letter_penalty) {
					penalty = max_leading_letter_penalty;
				}

				score += penalty;
			}

			/* Apply bonus for consecutive bonuses. */
			if (prev_matched) {
				new_score += adjacency_bonus;
			}

			/* Apply bonus for matches after a separator. */
			if (prev_separator) {
				new_score += separator_bonus;
			}

			/* Apply bonus across camel case boundaries. */
			if (prev_lower && isupper(str_letter)) {
				new_score += camel_bonus;
			}

			/*
			 * Update pattern iter IFF the next pattern letter was
			 * matched.
			 */
			if (next_match) {
				pattern_iter++;
			}

			/*
			 * Update best letter in str which may be for a "next"
			 * letter or a rematch.
			 */
			if (new_score >= best_letter_score) {
				/* Apply penalty for the now skipped letter. */
				if (best_letter != NULL) {
					score += unmatched_letter_penalty;
				}

				best_letter = str_iter;
				best_letter_score = new_score;
			}

			prev_matched = true;
		} else {
			score += unmatched_letter_penalty;
			prev_matched = false;
		}

		/* Separators should be more easily defined. */
		prev_lower = islower(str_letter) != 0;
		prev_separator = str_letter == '_' || str_letter == ' ';

		str_iter++;
	}

	/* Apply score for last match. */
	if (best_letter) {
		score += best_letter_score;
	}

	/* Did not match full pattern. */
	if (*pattern_iter != '\0') {
		return INT32_MIN;
	}

	return score;
}
