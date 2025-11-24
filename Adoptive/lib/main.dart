// import 'dart:math';
//
// class SegmentProcessor {
//   final List<double> previousScores = [];
//
//   // Function to check if a segment can repeat
//   bool canRepeat(double errorRate, double flowRate) {
//     if (errorRate < 0 || errorRate > 1 || flowRate < 0 || flowRate > 1) {
//       throw ArgumentError("Both errorRate and flowRate must be between 0 and 1.");
//     }
//
//     // Calculate the score
//     double score = (0.7 * errorRate) + (0.3 * flowRate);
//     score = score.clamp(0, 1);
//
//     // Add the new score to previousScores
//     previousScores.add(score);
//
//     // Check the last 3 scores
//     if (previousScores.length >= 3) {
//       bool allScoresBelowThreshold =
//       previousScores.sublist(previousScores.length - 3).every((s) => s < 0.3);
//       if (allScoresBelowThreshold) {
//         if (score > 0.3) {
//           return true;
//         }
//         return false;
//       }
//     }
//     return true;
//   }
//
//   // Function to process segments
//   void processSegments(Map<String, dynamic> data) {
//     String ayatCombine = "";
//
//     for (var ayahData in data['segments']) {
//       String combinedSegments = "";
//
//       for (var segment in ayahData['segments']) {
//         bool flag = true;
//         previousScores.clear();
//         // Process each individual segment
//         while (flag) {
//           print("Segment: ${segment['segment']}");
//           double errorRate = Random().nextDouble() * 0.4;
//           double flowRate = Random().nextDouble() * 0.4;
//           bool result = canRepeat(errorRate, flowRate);
//           print(
//               "Error Rate = ${errorRate.toStringAsFixed(2)}, Flow Rate = ${flowRate.toStringAsFixed(2)}, "
//                   "Score = ${previousScores.last.toStringAsFixed(2)}, Can Repeat: $result");
//           flag = result;
//         }
//
//         combinedSegments += "${segment['segment']} ";
//         if (ayahData['segments'].length == 1) {
//           ayatCombine += "$combinedSegments ";
//         }
//
//         if (ayahData['segments'].indexOf(segment) != 0) {
//           previousScores.clear();
//           flag = true;
//
//           // Process combined segments
//           while (flag) {
//             print("Combined Segments: $combinedSegments");
//             double errorRate = Random().nextDouble() * 0.4+0.1;
//             double flowRate = Random().nextDouble() * 0.4+0.1;
//             bool result = canRepeat(errorRate, flowRate);
//             print(
//                 "Error Rate = ${errorRate.toStringAsFixed(2)}, Flow Rate = ${flowRate.toStringAsFixed(2)}, "
//                     "Score = ${previousScores.last.toStringAsFixed(2)}, Can Repeat: $result");
//             flag = result;
//           }
//           previousScores.clear();
//           if (ayahData['segments'].indexOf(segment) == ayahData['segments'].length - 1) {
//             ayatCombine += "$combinedSegments ";
//             previousScores.clear();
//             flag = true;
//             previousScores.clear();
//             // Process final ayatCombine
//             while (flag) {
//               print("Ayat: $ayatCombine");
//               double errorRate = Random().nextDouble() * 0.4;
//               double flowRate = Random().nextDouble() * 0.4;
//               bool result = canRepeat(errorRate, flowRate);
//               print(
//                   "Error Rate = ${errorRate.toStringAsFixed(2)}, Flow Rate = ${flowRate.toStringAsFixed(2)}, "
//                       "Score = ${previousScores.last.toStringAsFixed(2)}, Can Repeat: $result");
//               flag = result;
//             }
//             previousScores.clear();
//           }
//         }
//       }
//     }
//   }
// }
//
// void main() {
//   // Example input data
//   Map<String, dynamic> data = {
//     "segments": [
//       {
//         "ayah": 1,
//         "segments": [
//           {
//             "id": 0,
//             "segment": "الم۝"
//           }
//         ],
//         "surah": 2
//       },
//       {
//         "ayah": 2,
//         "segments": [
//           {
//             "id": 1,
//             "segment": "ذَٰلِكَ الْكِتَابُ لَا رَيْبۛ"
//           },
//           {
//             "id": 2,
//             "segment": "فِيهۛ هُدًى لِّلْمُتَّقِينَ۝"
//           }
//         ],
//         "surah": 2
//       },
//       {
//         "ayah": 3,
//         "segments": [
//           {
//             "id": 3,
//             "segment": "الَّذِينَ يُؤْمِنُونَ بِالْغَيْبِ وَيُقِيمُونَ الصَّلَاةَ"
//           },
//           {
//             "id": 4,
//             "segment": "وَمِمَّا رَزَقْنَاهُمْ يُنفِقُونَ۝"
//           }
//         ],
//         "surah": 2
//       },
//       {
//         "ayah": 4,
//         "segments": [
//           {
//             "id": 5,
//             "segment": "وَالَّذِينَ يُؤْمِنُونَ بِمَا أُنزِلَ"
//           },
//           {
//             "id": 6,
//             "segment": "إِلَيْكَ وَمَا أُنزِلَ مِن"
//           },
//           {
//             "id": 7,
//             "segment": "قَبْلِكَ وَبِالْآخِرَةِ هُمْ يُوقِنُونَ۝"
//           }
//         ],
//         "surah": 2
//       },
//       {
//         "ayah": 5,
//         "segments": [
//           {
//             "id": 8,
//             "segment": "أُولَـٰئِكَ عَلَىٰ هُدًى مِّن رَّبِّهِمۖ"
//           },
//           {
//             "id": 9,
//             "segment": "وَأُولَـٰئِكَ هُمُ الْمُفْلِحُونَ۝"
//           }
//         ],
//         "surah": 2
//       },
//       {
//         "ayah": 6,
//         "segments": [
//           {
//             "id": 10,
//             "segment": "إِنَّ الَّذِينَ كَفَرُوا سَوَاءٌ"
//           },
//           {
//             "id": 11,
//             "segment": "عَلَيْهِمْ أَأَنذَرْتَهُمْ أَمْ لَمْ"
//           },
//           {
//             "id": 12,
//             "segment": "تُنذِرْهُمْ لَا يُؤْمِنُونَ۝"
//           }
//         ],
//         "surah": 2
//       },
//       {
//         "ayah": 7,
//         "segments": [
//           {
//             "id": 13,
//             "segment": "خَتَمَ اللَّهُ عَلَىٰ قُلُوبِهِمْ"
//           },
//           {
//             "id": 14,
//             "segment": "وَعَلَىٰ سَمْعِهِمۖ وَعَلَىٰ أَبْصَارِهِمْ"
//           },
//           {
//             "id": 15,
//             "segment": "غِشَاوَةۖ وَلَهُمْ عَذَابٌ عَظِيمٌ۝"
//           }
//         ],
//         "surah": 2
//       },
//       {
//         "ayah": 8,
//         "segments": [
//           {
//             "id": 16,
//             "segment": "وَمِنَ النَّاسِ مَن يَقُولُ"
//           },
//           {
//             "id": 17,
//             "segment": "آمَنَّا بِاللَّهِ وَبِالْيَوْمِ الْآخِرِ"
//           },
//           {
//             "id": 18,
//             "segment": "وَمَا هُم بِمُؤْمِنِينَ۝"
//           }
//         ],
//         "surah": 2
//       },
//       {
//         "ayah": 9,
//         "segments": [
//           {
//             "id": 19,
//             "segment": "يُخَادِعُونَ اللَّهَ وَالَّذِينَ آمَنُوا"
//           },
//           {
//             "id": 20,
//             "segment": "وَمَا يَخْدَعُونَ إِلَّا أَنفُسَهُمْ"
//           },
//           {
//             "id": 21,
//             "segment": "وَمَا يَشْعُرُونَ۝"
//           }
//         ],
//         "surah": 2
//       },
//       {
//         "ayah": 10,
//         "segments": [
//           {
//             "id": 22,
//             "segment": "فِي قُلُوبِهِم مَّرَضٌ فَزَادَهُمُ اللَّهُ"
//           },
//           {
//             "id": 23,
//             "segment": "مَرَضًۖ وَلَهُمْ عَذَابٌ أَلِيمٌ"
//           },
//           {
//             "id": 24,
//             "segment": "بِمَا كَانُوا يَكْذِبُونَ"
//           }
//         ],
//         "surah": 2
//       }
//     ]
//   };
//
//   // Process segments
//   SegmentProcessor processor = SegmentProcessor();
//   processor.processSegments(data);
// }


import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SegmentProcessorScreen(),
    );
  }
}

class SegmentProcessorScreen extends StatefulWidget {
  @override
  _SegmentProcessorScreenState createState() =>
      _SegmentProcessorScreenState();
}

class _SegmentProcessorScreenState extends State<SegmentProcessorScreen> {
  List<String> logs = [];
  SegmentProcessor processor = SegmentProcessor();

  @override
  void initState() {
    super.initState();
    // Example input data (same as provided in the original code)
    Map<String, dynamic> data = {
      "segments": [
        {
          "ayah": 1,
          "segments": [
            {
              "id": 0,
              "segment": "الم۝"
            }
          ],
          "surah": 2
        },
        {
          "ayah": 2,
          "segments": [
            {
              "id": 1,
              "segment": "ذَٰلِكَ الْكِتَابُ لَا رَيْبۛ"
            },
            {
              "id": 2,
              "segment": "فِيهۛ هُدًى لِّلْمُتَّقِينَ۝"
            }
          ],
          "surah": 2
        },
        // Add other segments here
      ]
    };

    // Process segments
    processor.processSegments(data, updateLog);
  }

  void updateLog(String message) {
    setState(() {
      logs.add(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Segment Processor")),
      body: ListView.builder(
        itemCount: logs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(logs[index]),
          );
        },
      ),
    );
  }
}

class SegmentProcessor {
  final List<double> previousScores = [];

  // Function to check if a segment can repeat
  bool canRepeat(double errorRate, double flowRate) {
    if (errorRate < 0 || errorRate > 1 || flowRate < 0 || flowRate > 1) {
      throw ArgumentError("Both errorRate and flowRate must be between 0 and 1.");
    }

    // Calculate the score
    double score = (0.7 * errorRate) + (0.3 * flowRate);
    score = score.clamp(0, 1);

    // Add the new score to previousScores
    previousScores.add(score);

    // Check the last 3 scores
    if (previousScores.length >= 3) {
      bool allScoresBelowThreshold =
      previousScores.sublist(previousScores.length - 3).every((s) => s < 0.3);
      if (allScoresBelowThreshold) {
        if (score > 0.3) {
          return true;
        }
        return false;
      }
    }
    return true;
  }

  // Function to process segments
  void processSegments(Map<String, dynamic> data, Function(String) updateLog) {
    String ayatCombine = "";

    for (var ayahData in data['segments']) {
      String combinedSegments = "";

      for (var segment in ayahData['segments']) {
        bool flag = true;
        previousScores.clear();

        // Process each individual segment
        while (flag) {
          String message = "Segment: ${segment['segment']}";
          double errorRate = Random().nextDouble() * 0.4;
          double flowRate = Random().nextDouble() * 0.4;
          bool result = canRepeat(errorRate, flowRate);
          message += "\nError Rate = ${errorRate.toStringAsFixed(2)}, Flow Rate = ${flowRate.toStringAsFixed(2)}, "
              "Score = ${previousScores.last.toStringAsFixed(2)}, Can Repeat: $result";
          updateLog(message);
          flag = result;
        }

        combinedSegments += "${segment['segment']} ";
        if (ayahData['segments'].length == 1) {
          ayatCombine += "$combinedSegments ";
        }

        if (ayahData['segments'].indexOf(segment) != 0) {
          previousScores.clear();
          flag = true;

          // Process combined segments
          while (flag) {
            String message = "Combined Segments: $combinedSegments";
            double errorRate = Random().nextDouble() * 0.4 + 0.1;
            double flowRate = Random().nextDouble() * 0.4 + 0.1;
            bool result = canRepeat(errorRate, flowRate);
            message += "\nError Rate = ${errorRate.toStringAsFixed(2)}, Flow Rate = ${flowRate.toStringAsFixed(2)}, "
                "Score = ${previousScores.last.toStringAsFixed(2)}, Can Repeat: $result";
            updateLog(message);
            flag = result;
          }
          previousScores.clear();
          if (ayahData['segments'].indexOf(segment) == ayahData['segments'].length - 1) {
            ayatCombine += "$combinedSegments ";
            previousScores.clear();
            flag = true;
            previousScores.clear();
            // Process final ayatCombine
            while (flag) {
              String message = "Ayat: $ayatCombine";
              double errorRate = Random().nextDouble() * 0.4;
              double flowRate = Random().nextDouble() * 0.4;
              bool result = canRepeat(errorRate, flowRate);
              message += "\nError Rate = ${errorRate.toStringAsFixed(2)}, Flow Rate = ${flowRate.toStringAsFixed(2)}, "
                  "Score = ${previousScores.last.toStringAsFixed(2)}, Can Repeat: $result";
              updateLog(message);
              flag = result;
            }
            previousScores.clear();
          }
        }
      }
    }
  }
}

