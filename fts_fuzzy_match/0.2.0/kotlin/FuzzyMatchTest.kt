import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.InputStreamReader
import java.io.OutputStreamWriter

fun main() {
    val dataset =
        InputStreamReader(FileInputStream("../../../dataset/ue4_filenames.txt"), Charsets.UTF_8).use { reader ->
            reader.readLines()
        }

    val maxMatches = 100
    val pattern = "LLL"

    OutputStreamWriter(FileOutputStream("test_results.txt"), Charsets.UTF_8).use { writer ->
        var cnt = 0
        var matches = 0
        while (matches < maxMatches && cnt < dataset.size) {
            val (match, score) = fuzzyMatch(pattern, dataset[cnt])
            if (match) {
                writer.write("$score|${dataset[cnt]}\n")
                matches += 1
            }
            cnt += 1
        }
    }
}
