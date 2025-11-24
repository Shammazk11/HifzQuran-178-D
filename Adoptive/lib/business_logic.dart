import 'dart:math';

class AyahProcessor {
  // Function to calculate if the Ayah can be repeated based on scores
  static bool canRepeat(double errorRate, double flowRate, List<double> previousScores) {
    if (!(0 <= errorRate && errorRate <= 1) || !(0 <= flowRate && flowRate <= 1)) {
      throw ArgumentError("Both errorRate and flowRate must be between 0 and 1.");
    }

    double score = (0.7 * errorRate) + (0.3 * flowRate);
    score = score.clamp(0, 1); // Ensure score is within 0 and 1

    previousScores.add(score);

    if (previousScores.length >= 3) {
      if (previousScores.sublist(previousScores.length - 3).every((s) => s < 0.3)) {
        return score > 0.3;
      }
    }
    return true;
  }

  // Process segments to combine Ayahs
  static List<String> processSegments(Map<String, dynamic> data) {
    List<String> ayahs = [];
    for (var ayahData in data["segments"]) {
      String combinedSegments = "";
      for (var segment in ayahData["segments"]) {
        combinedSegments += "${segment['segment']} ";
      }
      ayahs.add(combinedSegments.trim());
    }
    return ayahs;
  }
}
