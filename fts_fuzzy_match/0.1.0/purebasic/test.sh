#!/bin/bash

# v1.0.0 | 2021/07/07 | by Tristano Ajmone | CC0 1.0 Universal.

resultsF=test_results.txt

if ! [[ $(uname -s) == MINGW* ]];then
	echo -e "\e[31m**ERROR!** This script only support Windows OS!\e[0m"
	exit 1
fi

## Get Absolute Path to PureBasic Compiler
##########################################
PBCompiler="$PROGRAMFILES/PureBasic/Compilers/pbcompiler.exe"
PBCompiler="${PBCompiler/:/}"	 # Remove the ':'
PBCompiler="${PBCompiler/\\/\/}" # Replace '\' with '/'
PBCompiler="/${PBCompiler,}"	 # Drive unit to lowercase

if ! [[ -f "$PBCompiler" ]]; then
	echo -e "\e[31m**ERROR!** PureBasic compiler not found at:\n$PBCompiler\e[0m"
	exit 2
fi

## Delete Old Files
###################
rm -f *.exe test_results.txt

## Compile and Run PB Test
##########################

"$PBCompiler" -e "test.exe" //CONSOLE //USER ./test.pb || {
	echo -e "\n\e[31m**ERROR!** Test file compilation failed!\e[0m"
	exit 3
}

./test.exe > /dev/null 2>&1

if ! [[ -f "$resultsF" ]]; then
	echo -e "\n\e[31m**ERROR!** Generated results file not found: \"$resultsF\"\e[0m"
	exit 4
fi

## Diff-Compare with Expected Results
#####################################

diff -qs $resultsF ../expected_results.txt || {
	echo -e "\n\e[1;31m*** TEST FAILED!!! ***\e[0m"
	exit 5
	} && echo -e "\n\e[1;32m/// TEST PASSED!!! ///\e[0m"
