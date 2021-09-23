# Fuzzy Match v0.2.0 Kotlin

## Folder Contents

- [`FuzzyMatch.kt`](./FuzzyMatch.kt) - Fuzzy Match v0.2.0 in Kotlin.
- [`FuzzyMatchTest.kt`](./FuzzyMatchTest.kt) - Test script.

## Test File

To run the tests, open a shell and run:

    kotlinc FuzzyMatch.kt FuzzyMatchTest.kt -include-runtime -d fuzzy.jar
    java -jar fuzzy.jar

Where [`kotlinc`][kotlinc] is the Kotlin compiler.

## License

This implementation is licensed under [Creative Commons Zero v1.0 Universal][cc].

[kotlinc]: https://kotlinlang.org/docs/command-line.html
    "Kotlin command-line compiler | Kotlin"

[cc]: https://creativecommons.org/publicdomain/zero/1.0/
    "Creative Commons — CC0 1.0 Universal"
