/* ********************************************************************
 * fts_fuzzy_match tester, by Tristano Ajmone, public domain (CC0 1.0).
 * https://github.com/tajmone/fuzzy-search
 * ********************************************************************
 */
#define DATASETFILE "../../../dataset/ue4_filenames.txt"
#define RESULTSFILE "./test_results.txt"
#define PATTERN "LLL"
#define MAXMATCH 100

#include <iostream>
#include <fstream>
#include <string>
using namespace std;

#define FTS_FUZZY_MATCH_IMPLEMENTATION
#include "fts_fuzzy_match.h"

int main(){
    fstream datafile, testfile;
    datafile.open(DATASETFILE, ios::in);
    testfile.open(RESULTSFILE, ios::out);
    if(!testfile.is_open()) {
        cout << "Failed to create output file!\n";
        return 1;
    }
    if (datafile.is_open()) {
        string entry;
        char pattern[] = PATTERN;
        int score, matches;
        while(getline(datafile, entry)) {
            if (fts::fuzzy_match(pattern, entry.c_str(), score)) {
                testfile << score << "|" << entry << "\n";
                ++matches;
                if (matches == MAXMATCH)
                    break;
            }
        }
    datafile.close();
    }
testfile.close();
}
