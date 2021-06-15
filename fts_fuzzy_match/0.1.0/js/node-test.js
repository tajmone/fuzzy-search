/*  ====================================================================
    fts_fuzzy_match tester, by Tristano Ajmone, public domain (CC0 1.0).
    https://github.com/tajmone/fuzzy-search
    ====================================================================
*/
const datasetFile = '../../../dataset/ue4_filenames.txt';
const resultsFile = './test_results.txt';
const pattern = 'LLL';
const maxMatches = 100;

const fs = require('fs');
eval(fs.readFileSync('./fts_fuzzy_match.js')+'');
const outFile = fs.createWriteStream(resultsFile);

try {
    const dataset = fs.readFileSync(datasetFile, 'UTF-8');
    const lines = dataset.split(/\r?\n/);

    let cnt = matches = 0;
    while (matches < maxMatches && cnt < lines.length) {
        let matchRes = fuzzy_match(pattern, lines[cnt]);
        if (matchRes[0]) {
            outFile.write(matchRes[1] + "|" + lines[cnt] + '\n');
            matches += 1;
        }
        cnt += 1;
    }
} catch (err) {
    console.error(err);
}
outFile.end();
