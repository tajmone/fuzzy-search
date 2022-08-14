/* ********************************************************************
 * fts_fuzzy_match tester, by Tristano Ajmone, public domain (CC0 1.0).
 * Ported to C by Philip Jones.
 * https://github.com/tajmone/fuzzy-search
 * ********************************************************************
 */
#define DATASETFILE "../../../dataset/ue4_filenames.txt"
#define RESULTSFILE "test_results.txt"
#define PATTERN "LLL"
#define MAXMATCH 100

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "fts_fuzzy_match.h"

int main()
{
	errno = 0;
	FILE *datafile = fopen(DATASETFILE, "rb");
	if (datafile == NULL) {
		perror("Failed to open input file");
		exit(EXIT_FAILURE);
	}

	FILE *testfile = fopen(RESULTSFILE, "wb");
	if (testfile == NULL) {
		perror("Failed to open output file");
		fclose(datafile);
		exit(EXIT_FAILURE);
	}

	char *entry = NULL;
	size_t n = 0;
	char pattern[] = PATTERN;
	int32_t score;
	int matches = 0;
	while(getline(&entry, &n, datafile) != -1) {
		/* Strip newline included by getline. */
		entry[strlen(entry) - 1] = '\0';
		score = fts_fuzzy_match(pattern, entry);
		if (score != INT32_MIN) {
			fprintf(testfile, "%d|%s\n", score, entry);
			matches++;
			if (matches == MAXMATCH) {
				break;
			}
		}
	}
	free(entry);
	fclose(datafile);
	fclose(testfile);
	return EXIT_SUCCESS;
}
