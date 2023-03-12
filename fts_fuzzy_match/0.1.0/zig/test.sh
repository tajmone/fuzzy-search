#!/bin/bash

# v1.0.0 | 2023/03/12 | by Tristano Ajmone | CC0 1.0 Universal.

resultsF=test_results.txt

## Delete Old Files
###################
rm -f *.exe $resultsF

## Compile and Run Zig Test
###########################

zig build run || {
	echo -e "\n\e[31m**ERROR!** Test file compilation failed!\e[0m"
	exit 1
}

./test.exe > /dev/null 2>&1

if ! [[ -f "$resultsF" ]]; then
	echo -e "\n\e[31m**ERROR!** Generated results file not found: \"$resultsF\"\e[0m"
	exit 2
fi

## Diff-Compare with Expected Results
#####################################

diff -qs $resultsF ../expected_results.txt || {
	echo -e "\n\e[1;31m*** TEST FAILED!!! ***\e[0m"
	exit 3
	} && echo -e "\n\e[1;32m/// TEST PASSED!!! ///\e[0m"
