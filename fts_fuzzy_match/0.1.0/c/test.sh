#!/bin/bash
cc test.c fts_fuzzy_match.c -o test || exit 1

./test
if [[ $(uname -s) == MINGW* ]]; then
	dos2unix test_results.txt
fi
