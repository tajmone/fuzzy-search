#!/bin/bash
node node-test.js || exit 1
diff -qs ./test_results.txt ../expected_results.txt || (
	echo -e "\e[1;31m*** TEST FAILED!!! ***\e[0m";
	exit 1;
	) && echo -e "\e[1;32m/// TEST PASSED!!! ///\e[0m"
