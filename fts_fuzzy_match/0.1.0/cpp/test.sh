#!/bin/bash
gcc test.cpp -lstdc++ -o test || exit 1

./test
if [[ $(uname -s) == MINGW* ]]; then
	dos2unix test_results.txt
fi
