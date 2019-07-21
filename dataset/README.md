# Test Data Set

Sample files for testing the fuzzy search algorithms.

# Folder Contents

The following `.txt` files contain sample data set, one entry for line (`LF` EOL):

| file                                      | data set name                       | entries  |
| :---------------------------------------- | :---------------------------------- | -------: |
| [`english_wordlist_2k.txt`][en 2k]        | English words list 2k               | 1,510    |
| [`english_wordlist_355k.txt`][en 355k]    | English words list 355k             | 354,986  |
| [`english_wordlist_58k.txt`][en 58k]      | English words list 58k              | 58,110   |
| [`hearthstone_cardlist.txt`][hearth]      | _[Hearthstone]_ cards list          | 743      |
| [`magicthegathering_cardlist.txt`][magic] | _[Magic: The Gathering]_ cards list | 15,893   |
| [`ue4_filenames.txt`][ue4]                | _[Unreal Engine 4]_ filenames       | 13,164   |

For JavaScript testing, the following file defines all data sets (except the 355k Wordlist) as arrays in the `dataSets` object:

- [`fuzzy_match_data.js`][fm js]

All files were taken from [Forrest Smith]'s __[lib_fts]__ project:

- https://github.com/forrestthewoods/lib_fts/tree/master/tests/fuzzy_match/data/

The original sources of the files are unknown.

<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

[lib_fts]: https://github.com/forrestthewoods/lib_fts

<!-- 3rd parties -->

[Hearthstone]: https://playhearthstone.com "Visit Hearthstone website"
[Magic: The Gathering]: https://en.wikipedia.org/wiki/Magic:_The_Gathering "See Wikipedia page on Magic: The Gathering"
[Unreal Engine 4]: https://www.unrealengine.com "Visit Unreal Engine website"

<!-- dataset files -->

[en 2k]: ./english_wordlist_2k.txt
[en 355k]: ./english_wordlist_355k.txt
[en 58k]: ./english_wordlist_58k.txt
[fm js]: ./fuzzy_match_data.js
[hearth]: ./hearthstone_cardlist.txt
[magic]: ./magicthegathering_cardlist.txt
[ue4]: ./ue4_filenames.txt

<!-- people -->

[Forrest Smith]: https://github.com/forrestthewoods "View Forrest Smith's GitHub profile"

<!-- EOF -->
