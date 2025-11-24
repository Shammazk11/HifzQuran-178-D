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
//
//
// import 'dart:math';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: SegmentProcessorScreen(),
//     );
//   }
// }
//
// class SegmentProcessorScreen extends StatefulWidget {
//   @override
//   _SegmentProcessorScreenState createState() =>
//       _SegmentProcessorScreenState();
// }
//
// class _SegmentProcessorScreenState extends State<SegmentProcessorScreen> {
//   List<String> logs = [];
//   SegmentProcessor processor = SegmentProcessor();
//
//   @override
//   void initState() {
//     super.initState();
//     // Example input data (same as provided in the original code)
//     Map<String, dynamic> data = {
//       "segments": [
//         {
//           "ayah": 1,
//           "segments": [
//             {
//               "id": 0,
//               "segment": "الم۝"
//             }
//           ],
//           "surah": 2
//         },
//         {
//           "ayah": 2,
//           "segments": [
//             {
//               "id": 1,
//               "segment": "ذَٰلِكَ الْكِتَابُ لَا رَيْبۛ"
//             },
//             {
//               "id": 2,
//               "segment": "فِيهۛ هُدًى لِّلْمُتَّقِينَ۝"
//             }
//           ],
//           "surah": 2
//         },
//         // Add other segments here
//       ]
//     };
//
//     // Process segments
//     processor.processSegments(data, updateLog);
//   }
//
//   void updateLog(String message) {
//     setState(() {
//       logs.add(message);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Segment Processor")),
//       body: ListView.builder(
//         itemCount: logs.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(logs[index]),
//           );
//         },
//       ),
//     );
//   }
// }
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
//   void processSegments(Map<String, dynamic> data, Function(String) updateLog) {
//     String ayatCombine = "";
//
//     for (var ayahData in data['segments']) {
//       String combinedSegments = "";
//
//       for (var segment in ayahData['segments']) {
//         bool flag = true;
//         previousScores.clear();
//
//         // Process each individual segment
//         while (flag) {
//           String message = "Segment: ${segment['segment']}";
//           double errorRate = Random().nextDouble() * 0.4;
//           double flowRate = Random().nextDouble() * 0.4;
//           bool result = canRepeat(errorRate, flowRate);
//           message += "\nError Rate = ${errorRate.toStringAsFixed(2)}, Flow Rate = ${flowRate.toStringAsFixed(2)}, "
//               "Score = ${previousScores.last.toStringAsFixed(2)}, Can Repeat: $result";
//           updateLog(message);
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
//             String message = "Combined Segments: $combinedSegments";
//             double errorRate = Random().nextDouble() * 0.4 + 0.1;
//             double flowRate = Random().nextDouble() * 0.4 + 0.1;
//             bool result = canRepeat(errorRate, flowRate);
//             message += "\nError Rate = ${errorRate.toStringAsFixed(2)}, Flow Rate = ${flowRate.toStringAsFixed(2)}, "
//                 "Score = ${previousScores.last.toStringAsFixed(2)}, Can Repeat: $result";
//             updateLog(message);
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
//               String message = "Ayat: $ayatCombine";
//               double errorRate = Random().nextDouble() * 0.4;
//               double flowRate = Random().nextDouble() * 0.4;
//               bool result = canRepeat(errorRate, flowRate);
//               message += "\nError Rate = ${errorRate.toStringAsFixed(2)}, Flow Rate = ${flowRate.toStringAsFixed(2)}, "
//                   "Score = ${previousScores.last.toStringAsFixed(2)}, Can Repeat: $result";
//               updateLog(message);
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

//
//
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: SegmentProcessorScreen(),
//     );
//   }
// }
//
// class SegmentProcessorScreen extends StatefulWidget {
//   @override
//   _SegmentProcessorScreenState createState() =>
//       _SegmentProcessorScreenState();
// }
//
// class _SegmentProcessorScreenState extends State<SegmentProcessorScreen> {
//   List<String> logs = [];
//   SegmentProcessor processor = SegmentProcessor();
//   late stt.SpeechToText _speech;
//   bool _isListening = false;
//   String _voiceInput = "";
//
//   @override
//   void initState() {
//     super.initState();
//     _speech = stt.SpeechToText();
//   }
//
//   void updateLog(String message) {
//     setState(() {
//       logs.add(message);
//     });
//   }
//
//   Future<void> _startListening() async {
//     bool available = await _speech.initialize(
//       onStatus: (status) => print("Status: $status"),
//       onError: (error) => print("Error: $error"),
//     );
//     if (available) {
//       setState(() => _isListening = true);
//       _speech.listen(
//         onResult: (result) {
//           setState(() {
//             _voiceInput = result.recognizedWords;
//           });
//         },
//       );
//     } else {
//       setState(() => _isListening = false);
//     }
//   }
//
//   void _stopListening() {
//     _speech.stop();
//     setState(() => _isListening = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Segment Processor")),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: _isListening ? _stopListening : _startListening,
//             child: Text(_isListening ? "Stop Listening" : "Start Listening"),
//           ),
//           if (_voiceInput.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text("Voice Input: $_voiceInput"),
//             ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: logs.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(logs[index]),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           if (_voiceInput.isNotEmpty) {
//             Map<String, dynamic> data = {
//               "segments": [
//                 {
//                   "ayah": 1,
//                   "segments": [
//                     {"id": 0, "segment": _voiceInput}
//                   ],
//                   "surah": 2
//                 },
//               ]
//             };
//             processor.processSegments(data, updateLog);
//           }
//         },
//         child: Icon(Icons.send),
//       ),
//     );
//   }
// }
//
// class SegmentProcessor {
//   final List<double> previousScores = [];
//
//   bool canRepeat(double errorRate, double flowRate) {
//     if (errorRate < 0 || errorRate > 1 || flowRate < 0 || flowRate > 1) {
//       throw ArgumentError("Both errorRate and flowRate must be between 0 and 1.");
//     }
//
//     double score = (0.7 * errorRate) + (0.3 * flowRate);
//     score = score.clamp(0, 1);
//
//     previousScores.add(score);
//
//     if (previousScores.length >= 3) {
//       bool allScoresBelowThreshold =
//       previousScores.sublist(previousScores.length - 3).every((s) => s < 0.3);
//       if (allScoresBelowThreshold) {
//         return score > 0.3;
//       }
//     }
//     return true;
//   }
//
//   Map<String, double> findErrorOrFlow(String voiceInput) {
//     print("Processing voice input: $voiceInput");
//     double errorRate = Random().nextDouble();
//     double flowRate = Random().nextDouble();
//     return {"errorRate": errorRate, "flowRate": flowRate};
//   }
//
//   void processSegments(Map<String, dynamic> data, Function(String) updateLog) {
//     String ayatCombine = "";
//
//     for (var ayahData in data['segments']) {
//       String combinedSegments = "";
//
//       for (var segment in ayahData['segments']) {
//         bool flag = true;
//         previousScores.clear();
//
//         while (flag) {
//           String message = "Segment: ${segment['segment']}";
//           var rates = findErrorOrFlow(segment['segment']);
//           double errorRate = rates['errorRate']!;
//           double flowRate = rates['flowRate']!;
//           bool result = canRepeat(errorRate, flowRate);
//           message +=
//           "\nError Rate = ${errorRate.toStringAsFixed(2)}, Flow Rate = ${flowRate.toStringAsFixed(2)}, "
//               "Score = ${previousScores.last.toStringAsFixed(2)}, Can Repeat: $result";
//           updateLog(message);
//           flag = result;
//         }
//
//         combinedSegments += "${segment['segment']} ";
//         ayatCombine += "$combinedSegments ";
//       }
//     }
//   }
// }

//
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: SegmentProcessorScreen(),
//     );
//   }
// }
//
// class SegmentProcessorScreen extends StatefulWidget {
//   @override
//   _SegmentProcessorScreenState createState() =>
//       _SegmentProcessorScreenState();
// }
//
// class _SegmentProcessorScreenState extends State<SegmentProcessorScreen> {
//   List<String> logs = [];
//   SegmentProcessor processor = SegmentProcessor();
//   int currentSegmentIndex = 0;
//   String? currentVoiceInput;
//
//   List<dynamic> segments = [];
//   String ayatCombine = "";
//
//   late stt.SpeechToText _speech;
//   bool _isListening = false;
//   String _speechText = "";
//
//   @override
//   void initState() {
//     super.initState();
//     _speech = stt.SpeechToText();
//
//     // Your sample data with segments
//     Map<String, dynamic> data = {
//       "segments": [
//         {
//           "ayah": 1,
//           "segments": [
//             {"id": 0, "segment": "الم۝"}
//           ],
//           "surah": 2
//         },
//         {
//           "ayah": 2,
//           "segments": [
//             {"id": 1, "segment": "ذَٰلِكَ الْكِتَابُ لَا رَيْبۛ"},
//             {"id": 2, "segment": "فِيهۛ هُدًى لِّلْمُتَّقِينَ۝"}
//           ],
//           "surah": 2
//         },
//       ]
//     };
//
//     // Process the segments
//     processSegments(data);
//     print(segments);  // For debugging
//     processNextSegment();
//   }
//
//   final List<double> previousScores = [];
//
//   // Function to process segments
//   void processSegments(Map<String, dynamic> data) {
//     String ayatCombine = "";
//     for (var ayahData in data['segments']) {
//       String combinedSegments = "";
//       for (var segment in ayahData['segments']) {
//         bool flag = true;
//         previousScores.clear();
//         // Process each individual segment
//         while (flag) {
//           String message = segment['segment'];
//           segments.add(message);  // Add the individual segment
//           flag = false;
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
//             String message = combinedSegments;
//             segments.add(message);  // Add the combined segments
//             flag = false;
//           }
//           previousScores.clear();
//           if (ayahData['segments'].indexOf(segment) == ayahData['segments'].length - 1) {
//             ayatCombine += "$combinedSegments ";
//             previousScores.clear();
//             flag = true;
//             previousScores.clear();
//             // Process final ayatCombine
//             while (flag) {
//               String message = ayatCombine;
//               segments.add(message);  // Add the final combined segments
//               flag = false;
//             }
//             previousScores.clear();
//           }
//         }
//       }
//     }
//   }
//
//   void processNextSegment() {
//     if (currentSegmentIndex < segments.length) {
//       setState(() {
//         logs.add("Processing segment: ${segments[currentSegmentIndex]}");
//       });
//     } else {
//       setState(() {
//         logs.add("All segments processed.");
//       });
//     }
//   }
//
//   void startListening() async {
//     bool available = await _speech.initialize(
//       onStatus: (status) => print("onStatus: $status"),
//       onError: (error) => print("onError: $error"),
//     );
//     if (available) {
//       setState(() => _isListening = true);
//       _speech.listen(onResult: (result) {
//         setState(() {
//           _speechText = result.recognizedWords;
//         });
//       });
//     } else {
//       setState(() => _isListening = false);
//       logs.add("Speech recognition not available.");
//     }
//   }
//
//   void stopListening() {
//     setState(() => _isListening = false);
//     _speech.stop();
//     handleVoiceInput(_speechText);
//   }
//
//   void handleVoiceInput(String input) {
//     setState(() {
//       currentVoiceInput = input;
//     });
//     print("Voice input: $currentVoiceInput");
//
//     double errorRate = Random().nextDouble() * 0.4;
//     double flowRate = Random().nextDouble() * 0.4;
//
//     double score = processor.errorFlow(errorRate, flowRate);
//
//     logs.add(
//         "Input: $input, Error Rate: ${errorRate.toStringAsFixed(2)}, Flow Rate: ${flowRate.toStringAsFixed(2)}, Score: ${score.toStringAsFixed(2)}");
//
//     if (!processor.canRepeat(score)) {
//       logs.add(
//           "Segment '${segments[currentSegmentIndex]}' completed.");
//       currentSegmentIndex++;
//       processNextSegment();
//     } else {
//       logs.add("Repeating segment: ${segments[currentSegmentIndex]}");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Segment Processor")),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: logs.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(logs[index]),
//                 );
//               },
//             ),
//           ),
//           if (currentSegmentIndex < segments.length)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _isListening ? stopListening : startListening,
//                       child: Text(_isListening ? "Stop Listening" : "Start Listening"),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
//
// class SegmentProcessor {
//   final List<double> previousScores = [];
//
//   double errorFlow(double errorRate, double flowRate) {
//     double score = (0.7 * errorRate) + (0.3 * flowRate);
//     return score.clamp(0, 1);
//   }
//
//   bool canRepeat(double score) {
//     previousScores.add(score);
//
//     if (previousScores.length >= 3) {
//       bool allBelowThreshold =
//       previousScores.sublist(previousScores.length - 3).every((s) => s < 0.3);
//       if (allBelowThreshold) {
//         previousScores.clear();
//         return false;
//       }
//     }
//
//     return true;
//   }
// }
//
//
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: SegmentProcessorScreen(),
//     );
//   }
// }
//
// class SegmentProcessorScreen extends StatefulWidget {
//   @override
//   _SegmentProcessorScreenState createState() =>
//       _SegmentProcessorScreenState();
// }
//
// class _SegmentProcessorScreenState extends State<SegmentProcessorScreen> {
//   List<String> logs = [];
//   SegmentProcessor processor = SegmentProcessor();
//   int currentSegmentIndex = 0;
//   String? currentVoiceInput;
//
//   List<dynamic> segments = [];
//   String ayatCombine = "";
//
//   late stt.SpeechToText _speech;
//   bool _isListening = false;
//   String _speechText = "";
//
//   // List to store the recognized voice inputs
//   List<String> voiceInputArray = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _speech = stt.SpeechToText();
//
//     // Your sample data with segments
//     Map<String, dynamic> data = {
//       "segments": [
//         {
//           "ayah": 1,
//           "segments": [
//             {"id": 0, "segment": "الم۝"}
//           ],
//           "surah": 2
//         },
//         {
//           "ayah": 2,
//           "segments": [
//             {"id": 1, "segment": "ذَٰلِكَ الْكِتَابُ لَا رَيْبۛ"},
//             {"id": 2, "segment": "فِيهۛ هُدًى لِّلْمُتَّقِينَ۝"}
//           ],
//           "surah": 2
//         },
//       ]
//     };
//
//     // Process the segments
//     processSegments(data);
//     print(segments);  // For debugging
//     processNextSegment();
//   }
//
//   final List<double> previousScores = [];
//
//   // Function to process segments
//   void processSegments(Map<String, dynamic> data) {
//     String ayatCombine = "";
//     for (var ayahData in data['segments']) {
//       String combinedSegments = "";
//       for (var segment in ayahData['segments']) {
//         bool flag = true;
//         previousScores.clear();
//         // Process each individual segment
//         while (flag) {
//           String message = segment['segment'];
//           segments.add(message);  // Add the individual segment
//           flag = false;
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
//             String message = combinedSegments;
//             segments.add(message);  // Add the combined segments
//             flag = false;
//           }
//           previousScores.clear();
//           if (ayahData['segments'].indexOf(segment) == ayahData['segments'].length - 1) {
//             ayatCombine += "$combinedSegments ";
//             previousScores.clear();
//             flag = true;
//             previousScores.clear();
//             // Process final ayatCombine
//             while (flag) {
//               String message = ayatCombine;
//               segments.add(message);  // Add the final combined segments
//               flag = false;
//             }
//             previousScores.clear();
//           }
//         }
//       }
//     }
//   }
//
//   void processNextSegment() {
//     if (currentSegmentIndex < segments.length) {
//       setState(() {
//         logs.add("Processing segment: ${segments[currentSegmentIndex]}");
//       });
//     } else {
//       setState(() {
//         logs.add("All segments processed.");
//       });
//     }
//   }
//
//   void startListening() async {
//     bool available = await _speech.initialize(
//       onStatus: (status) => print("onStatus: $status"),
//       onError: (error) => print("onError: $error"),
//     );
//     if (available) {
//       setState(() => _isListening = true);
//       _speech.listen(onResult: (result) {
//         setState(() {
//           _speechText = result.recognizedWords;
//         });
//       });
//     } else {
//       setState(() => _isListening = false);
//       logs.add("Speech recognition not available.");
//     }
//   }
//
//   void stopListening() {
//     setState(() => _isListening = false);
//     _speech.stop();
//     handleVoiceInput(_speechText);
//   }
//
//   void handleVoiceInput(String input) {
//     setState(() {
//       currentVoiceInput = input;
//     });
//     print("Voice input: $currentVoiceInput");
//
//     // Add the recognized voice input to the array
//     voiceInputArray.add(input);
//
//     // Print the entire array of voice inputs (in any language)
//     print("All voice inputs: $voiceInputArray");
//
//     double errorRate = Random().nextDouble() * 0.4;
//     double flowRate = Random().nextDouble() * 0.4;
//
//     double score = processor.errorFlow(errorRate, flowRate);
//
//     logs.add(
//         "Input: $input, Error Rate: ${errorRate.toStringAsFixed(2)}, Flow Rate: ${flowRate.toStringAsFixed(2)}, Score: ${score.toStringAsFixed(2)}");
//
//     if (!processor.canRepeat(score)) {
//       logs.add(
//           "Segment '${segments[currentSegmentIndex]}' completed.");
//       currentSegmentIndex++;
//       processNextSegment();
//     } else {
//       logs.add("Repeating segment: ${segments[currentSegmentIndex]}");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Segment Processor")),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: logs.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(logs[index]),
//                 );
//               },
//             ),
//           ),
//           if (currentSegmentIndex < segments.length)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _isListening ? stopListening : startListening,
//                       child: Text(_isListening ? "Stop Listening" : "Start Listening"),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
//
// class SegmentProcessor {
//   final List<double> previousScores = [];
//
//   double errorFlow(double errorRate, double flowRate) {
//     double score = (0.7 * errorRate) + (0.3 * flowRate);
//     return score.clamp(0, 1);
//   }
//
//   bool canRepeat(double score) {
//     previousScores.add(score);
//
//     if (previousScores.length >= 3) {
//       bool allBelowThreshold =
//       previousScores.sublist(previousScores.length - 3).every((s) => s < 0.3);
//       if (allBelowThreshold) {
//         previousScores.clear();
//         return false;
//       }
//     }
//
//     return true;
//   }
// }

























//
//
//
//
//
//
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:record/record.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: SegmentProcessorScreen(),
//     );
//   }
// }
//
// class SegmentProcessorScreen extends StatefulWidget {
//   @override
//   _SegmentProcessorScreenState createState() =>
//       _SegmentProcessorScreenState();
// }
//
// class _SegmentProcessorScreenState extends State<SegmentProcessorScreen> {
//   List<String> logs = [];
//   SegmentProcessor processor = SegmentProcessor();
//   int currentSegmentIndex = 0;
//   String? currentVoiceInput;
//   final record = AudioRecorder();
//
//   List<dynamic> segments = [];
//   String ayatCombine = "";
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Your sample data with segments
//     Map<String, dynamic> data = {
//       "segments": [
//         {
//           "ayah": 1,
//           "segments": [
//             {"id": 0, "segment": "\u0627\u0644\u0645\u06dd"}
//           ],
//           "surah": 2
//         },
//         {
//           "ayah": 2,
//           "segments": [
//             {"id": 1, "segment": "\u0630\u064e\u0644\u0650\u0643\u064e \u0627\u0644\u0652\u0643\u0650\u062a\u064e\u0627\u0628\u064f \u0644\u0627 \u0631\u064e\u064a\u0652\u0628\u064c"},
//             {"id": 2, "segment": "\u0641\u0650\u064a\u0652\u0647\u0650 \u0647\u064f\u062f\u064b\u0649 \u0644\u0650\u0644\u0652\u0645\u064f\u062a\u064e\u0651\u0642\u0650\u064a\u0646\u064e\u06dd"}
//           ],
//           "surah": 2
//         },
//       ]
//     };
//
//     // Process the segments
//     processSegments(data);
//     processNextSegment();
//   }
//
//   // Function to process segments
//   void processSegments(Map<String, dynamic> data) {
//     String ayatCombine = "";
//     for (var ayahData in data['segments']) {
//       String combinedSegments = "";
//       for (var segment in ayahData['segments']) {
//         combinedSegments += "${segment['segment']} ";
//         segments.add(segment['segment']);
//       }
//       ayatCombine += "$combinedSegments ";
//     }
//   }
//
//   void processNextSegment() {
//     if (currentSegmentIndex < segments.length) {
//       setState(() {
//         logs.add("Processing segment: ${segments[currentSegmentIndex]}");
//       });
//     } else {
//       setState(() {
//         logs.add("All segments processed.");
//       });
//     }
//   }
//
//   Future<void> startRecording() async {
//     if (await record.hasPermission()) {
//       final stream = await record.startStream(
//         const RecordConfig(encoder: AudioEncoder.pcm16bits),
//       );
//       logs.add("Recording stream started.");
//     } else {
//       logs.add("Permission to record audio denied.");
//     }
//   }
//
//   Future<void> stopRecording() async {
//     String? path = await record.stop();
//     if (path != null) {
//       logs.add("Recording stopped. File saved at: $path");
//       handleVoiceInput(path);
//     } else {
//       logs.add("Recording not completed.");
//     }
//   }
//
//   void handleVoiceInput(String path) {
//     setState(() {
//       currentVoiceInput = path;
//     });
//     logs.add("Voice input recorded at: $path");
//
//     double errorRate = Random().nextDouble() * 0.4;
//     double flowRate = Random().nextDouble() * 0.4;
//     double score = processor.errorFlow(errorRate, flowRate);
//
//     logs.add(
//         "Error Rate: ${errorRate.toStringAsFixed(2)}, Flow Rate: ${flowRate.toStringAsFixed(2)}, Score: ${score.toStringAsFixed(2)}");
//
//     if (!processor.canRepeat(score)) {
//       logs.add("Segment '${segments[currentSegmentIndex]}' completed.");
//       currentSegmentIndex++;
//       processNextSegment();
//     } else {
//       logs.add("Repeating segment: ${segments[currentSegmentIndex]}");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Segment Processor")),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: logs.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(logs[index]),
//                 );
//               },
//             ),
//           ),
//           if (currentSegmentIndex < segments.length)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         if (await record.isRecording()) {
//                           await stopRecording();
//                         } else {
//                           await startRecording();
//                         }
//                       },
//                       child: Text("Record / Stop"),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     record.dispose();
//     super.dispose();
//   }
// }
//
// class SegmentProcessor {
//   final List<double> previousScores = [];
//
//   double errorFlow(double errorRate, double flowRate) {
//     double score = (0.7 * errorRate) + (0.3 * flowRate);
//     return score.clamp(0, 1);
//   }
//
//   bool canRepeat(double score) {
//     previousScores.add(score);
//
//     if (previousScores.length >= 3) {
//       bool allBelowThreshold =
//       previousScores.sublist(previousScores.length - 3).every((s) => s < 0.3);
//       if (allBelowThreshold) {
//         previousScores.clear();
//         return false;
//       }
//     }
//
//     return true;
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Audio Recorder',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: AudioRecordingPage(),
//     );
//   }
// }
//
// class AudioRecordingPage extends StatefulWidget {
//   @override
//   _AudioRecordingPageState createState() => _AudioRecordingPageState();
// }
//
// class _AudioRecordingPageState extends State<AudioRecordingPage> {
//   FlutterSoundRecorder _recorder = FlutterSoundRecorder();
//   bool _isRecording = false;
//   String _recordingPath = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _initRecorder();
//   }
//
//   Future<void> _initRecorder() async {
//     await _recorder.openRecorder();
//   }
//
//   Future<void> _startRecording() async {
//     String path = '/storage/emulated/0/Download/audio_record.aac';  // Path where the recording will be saved
//     await _recorder.startRecorder(toFile: path);
//     setState(() {
//       _isRecording = true;
//       _recordingPath = path;
//     });
//   }
//
//   Future<void> _stopRecording() async {
//     await _recorder.stopRecorder();
//     setState(() {
//       _isRecording = false;
//     });
//     print("Recording saved to: $_recordingPath");
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _recorder.closeRecorder();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Audio Recorder'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             if (_isRecording)
//               CircularProgressIndicator()
//             else
//               Icon(Icons.mic, size: 100, color: Colors.blue),
//             SizedBox(height: 20),
//             Text(
//               _isRecording ? 'Recording in Progress...' : 'Press to Record',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _isRecording ? _stopRecording : _startRecording,
//               child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
//             ),
//             if (_recordingPath.isNotEmpty && !_isRecording)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text('Recording saved at: $_recordingPath'),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'dart:core';
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   Map<String, dynamic>modal={
//     "segments": [
//     {
//     "ayah": 1,
//     "segments": [
//     {"id": 0, "segment": "\u0627\u0644\u0645\u06dd"}
//     ],
//     "surah": 2
//     },
//     {
//     "ayah": 2,
//     "segments": [
//     {"id": 1, "segment": "\u0632\u064e\u0644\u0650\u0643\u064e \u0627\u0644\u0652\u0643\u0650\u062a\u064e\u0627\u0628\u064f \u0644\u0627 \u0631\u064e\u064a\u0652\u0628\u064c"},
//     {"id": 2, "segment": "\u0641\u0650\u064a\u0652\u0647\u0650 \u0647\u064f\u062f\u064b\u0649 \u0644\u0650\u0644\u0652\u0645\u064f\u062a\u064e\u0651\u0642\u0650\u064a\u0646\u064e\u06dd"}
//     ],
//     "surah": 2
//     },
//     ]
//   };
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: SegmentProcessorScreen(modelData: modal),
//     );
//   }
// }
//
// class SegmentProcessorScreen extends StatefulWidget {
//   final Map<String, dynamic> modelData;
//
//   SegmentProcessorScreen({required this.modelData});
//   @override
//   _SegmentProcessorScreenState createState() => _SegmentProcessorScreenState();
// }
//
// class _SegmentProcessorScreenState extends State<SegmentProcessorScreen> {
//   List<String> logs = [];
//   SegmentProcessor processor = SegmentProcessor();
//   int currentSegmentIndex = 0;
//   String? currentVoiceInput;
//   FlutterSoundRecorder _recorder = FlutterSoundRecorder();
//   bool _isRecording = false;
//
//   List<dynamic> segments = [];
//   String ayatCombine = "";
//
//   @override
//   void initState() {
//     super.initState();
//     _initRecorder();
//     // Your sample data with segments
//     Map<String, dynamic> data = widget.modelData;
//
//     // Process the segments
//     processSegments(data);
//     processNextSegment();
//   }
//
//   Future<void> _initRecorder() async {
//     await _recorder.openRecorder();
//     print(_recorder);
//     logs.add("Recorder initialized.");
//   }
//
//   final List<double> previousScores = [];
//
//   // Function to process segments
//   void processSegments(Map<String, dynamic> data) {
//     String ayatCombine = "";
//     for (var ayahData in data['segments']) {
//       String combinedSegments = "";
//       for (var segment in ayahData['segments']) {
//         bool flag = true;
//         previousScores.clear();
//         // Process each individual segment
//         while (flag) {
//           String message = segment['segment'];
//           segments.add(message);  // Add the individual segment
//           flag = false;
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
//             String message = combinedSegments;
//             segments.add(message);  // Add the combined segments
//             flag = false;
//           }
//           previousScores.clear();
//           if (ayahData['segments'].indexOf(segment) == ayahData['segments'].length - 1) {
//             ayatCombine += "$combinedSegments ";
//             previousScores.clear();
//             flag = true;
//             previousScores.clear();
//             // Process final ayatCombine
//             while (flag) {
//               String message = ayatCombine;
//               segments.add(message);  // Add the final combined segments
//               flag = false;
//             }
//             previousScores.clear();
//           }
//         }
//       }
//     }
//   }
//
//   void processNextSegment() {
//     if (currentSegmentIndex < segments.length) {
//       setState(() {
//         logs.add("Processing segment: ${segments[currentSegmentIndex]}");
//       });
//     } else {
//       setState(() {
//         logs.add("All segments processed.");
//       });
//     }
//   }
//
//   Future<void> startRecording() async {
//     if (!_isRecording) {
//       String path = 'storage/emulated/0/Download/audio_record.aac';  // Path where the recording will be saved
//       await _recorder.startRecorder(toFile: path);
//       setState(() {
//         _isRecording = true;
//       });
//       logs.add("Recording started.");
//     }
//   }
//
//   Future<void> stopRecording() async {
//     if (_isRecording) {
//       String? path = await _recorder.stopRecorder();
//       if (path != null) {
//         logs.add("Recording stopped. File saved at: $path");
//         handleVoiceInput(path);
//       } else {
//         logs.add("Recording not completed.");
//       }
//       setState(() {
//         _isRecording = false;
//       });
//     }
//   }
//
//   void handleVoiceInput(String path) async{
//     setState(() {
//       currentVoiceInput = path;
//     });
//     // logs.add("Voice input recorded at: $path");
//     // // try {
//     // //   // Load the file and read it as bytes
//     // //   File audioFile = File(path);
//     // //   if (await audioFile.exists()) {
//     // //     List<int> fileBytes = await audioFile.readAsBytes();
//     // //      } else {
//     // //      }
//     // // } catch (e) {
//     // //   logs.add("Error loading file: $e");
//     // // }
//     // double errorRate = Random().nextDouble() * 0.4;
//     // double flowRate = Random().nextDouble() * 0.4;
//     // double score = processor.errorFlow(errorRate, flowRate);
//     //
//     // logs.add(
//     //     "Error Rate: ${errorRate.toStringAsFixed(2)}, Flow Rate: ${flowRate.toStringAsFixed(2)}, Score: ${score.toStringAsFixed(2)}");
//     //
//     // if (!processor.canRepeat(score)) {
//     //   logs.add("Segment '${segments[currentSegmentIndex]}' completed.");
//     //   currentSegmentIndex++;
//     //   processNextSegment();
//     // } else {
//     //   logs.add("Repeating segment: ${segments[currentSegmentIndex]}");
//     // }
//     String referenceText = segments[currentSegmentIndex];
//     try {
//       var request = http.MultipartRequest(
//           'POST',
//           Uri.parse(
//               "https://1696-2407-d000-d-e515-69e8-157b-7ff1-542c.ngrok-free.app/assess"));
//       request.fields['reference_text'] = referenceText;
//       request.files.add(await http.MultipartFile.fromPath('audio', path));
//       print(request);
//       var response = await request.send();
//
//       if (response.statusCode == 200) {
//         var responseData = await response.stream.bytesToString();
//         var decodedData = jsonDecode(responseData);
//         double errorRate = decodedData['error_rate'];
//         double flowRate = decodedData['flow_rate'];
//         double score = processor.errorFlow(errorRate, flowRate);
//         processScore(score);
//       } else {
//         throw Exception("Failed to get a response");
//       }
//     } catch (e) {
//       logs.add("Error: $e");
//       double errorRate = Random().nextDouble() * 0.4;
//       double flowRate = Random().nextDouble() * 0.4;
//       double score = processor.errorFlow(errorRate, flowRate);
//       processScore(score);
//     }
//   }
//   void processScore(double score) {
//     logs.add("Score: ${score.toStringAsFixed(2)}");
//     if (!processor.canRepeat(score)) {
//       logs.add("Segment '${segments[currentSegmentIndex]}' completed.");
//       currentSegmentIndex++;
//       processNextSegment();
//     } else {
//       logs.add("Repeating segment: ${segments[currentSegmentIndex]}");
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Segment Processor")),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: logs.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(logs[index]),
//                 );
//               },
//             ),
//           ),
//           if (currentSegmentIndex < segments.length)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         if (_isRecording) {
//                           await stopRecording();
//                         } else {
//                           await startRecording();
//                         }
//                       },
//                       child: Text(_isRecording ? "Stop" : "Start Recording"),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _recorder.closeRecorder();
//     super.dispose();
//   }
// }
//
// class SegmentProcessor {
//   final List<double> previousScores = [];
//
//   double errorFlow(double errorRate, double flowRate) {
//     double score = (0.7 * errorRate) + (0.3 * flowRate);
//     return score.clamp(0, 1);
//   }
//
//   bool canRepeat(double score) {
//     previousScores.add(score);
//
//     if (previousScores.length >= 3) {
//       bool allBelowThreshold =
//       previousScores.sublist(previousScores.length - 3).every((s) => s < 0.3);
//       if (allBelowThreshold) {
//         previousScores.clear();
//         return false;
//       }
//     }
//
//     return true;
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:core';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Map<String, dynamic> modal = {
    "segments": [
      {
        "ayah": 1,
        "segments": [
          {"id": 0, "segment": "\u0627\u0644\u0645\u06dd"}
        ],
        "surah": 2
      },
      {
        "ayah": 2,
        "segments": [
          {"id": 1, "segment": "\u0632\u064e\u0644\u0650\u0643\u064e \u0627\u0644\u0652\u0643\u0650\u062a\u064e\u0627\u0628\u064f \u0644\u0627 \u0631\u064e\u064a\u0652\u0628\u064c"},
          {"id": 2, "segment": "\u0641\u0650\u064a\u0652\u0647\u0650 \u0647\u064f\u062f\u064b\u0649 \u0644\u0650\u0644\u0652\u0645\u064f\u062a\u064e\u0651\u0642\u0650\u064a\u0646\u064e\u06dd"}
        ],
        "surah": 2
      },
    ]
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SegmentProcessorScreen(modelData: modal),
    );
  }
}
class SegmentProcessorScreen extends StatefulWidget {
  final Map<String, dynamic> modelData;

  SegmentProcessorScreen({required this.modelData});

  @override
  _SegmentProcessorScreenState createState() => _SegmentProcessorScreenState();
}

class _SegmentProcessorScreenState extends State<SegmentProcessorScreen> {
  List<String> logs = [];
  SegmentProcessor processor = SegmentProcessor();
  int currentSegmentIndex = 0;
  String? currentVoiceInput;
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  List<dynamic> segments = [];
  String ayatCombine = "";

  @override
  void initState() {
    super.initState();
    _initRecorder();
    processSegments(widget.modelData);
    processNextSegment();
  }

  Future<void> _initRecorder() async {
    await _recorder.openRecorder();
    setState(() {
    });
  }
  final List<double> previousScores = [];
  // Function to process segments
  void processSegments(Map<String, dynamic> data) {
    String ayatCombine = "";
    for (var ayahData in data['segments']) {
      String combinedSegments = "";
      for (var segment in ayahData['segments']) {
        bool flag = true;
        previousScores.clear();
        // Process each individual segment
        while (flag) {
          String message = segment['segment'];
          segments.add(message);  // Add the individual segment
          flag = false;
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
            String message = combinedSegments;
            segments.add(message);  // Add the combined segments
            flag = false;
          }
          previousScores.clear();
          if (ayahData['segments'].indexOf(segment) == ayahData['segments'].length - 1) {
            ayatCombine += "$combinedSegments ";
            previousScores.clear();
            flag = true;
            previousScores.clear();
            // Process final ayatCombine
            while (flag) {
              String message = ayatCombine;
              segments.add(message);  // Add the final combined segments
              flag = false;
            }
            previousScores.clear();
          }
        }
      }
    }
  }

  void processNextSegment() {
    if (currentSegmentIndex < segments.length) {
      setState(() {
        logs.add("${segments[currentSegmentIndex]}");
      });
    }
  }

  Future<void> startRecording() async {
    if (!_isRecording) {
      await _recorder.startRecorder(toFile: 'audio_record.aac');
      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> stopRecording() async {
    if (_isRecording) {
      String? path = await _recorder.stopRecorder();
      if (path != null) {
        setState(() {
          _isRecording = false;
          // logs.add("Recording saved at: $path");
        });
        handleVoiceInput(path);
      }
    }
  }

  void handleVoiceInput(String path) async{
    setState(() {
      currentVoiceInput = path;
    });
    String referenceText = segments[currentSegmentIndex];
    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              "https://1696-2407-d000-d-e515-69e8-157b-7ff1-542c.ngrok-free.app/assess"));
      request.fields['reference_text'] = referenceText;
      request.files.add(await http.MultipartFile.fromPath('audio', path));
      print(request);
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var decodedData = jsonDecode(responseData);
        double errorRate = double.parse(decodedData['error_rate'].toString());
        double flowRate = double.parse(decodedData['flow_rate'].toString());
        double score = processor.errorFlow(errorRate, flowRate);
        processScore(score);
      } else {
        throw Exception("Failed to get a response");
      }
    } catch (e) {
      double errorRate = Random().nextDouble() * 0.4;
      double flowRate = Random().nextDouble() * 0.4;
      double score = processor.errorFlow(errorRate, flowRate);
      processScore(score);
    }
  }

  void processScore(double score) {
    if (!processor.canRepeat(score)) {
      setState(() {
        logs.add("'${segments[currentSegmentIndex]}' completed.");
        currentSegmentIndex++;
        processNextSegment();
      });
    } else {
      logs.add(segments[currentSegmentIndex]);
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Segment Processor"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Colors.teal],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          logs[index],
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: currentSegmentIndex / segments.length,
              backgroundColor: Colors.grey[300],
              color: Colors.teal,
            ),
            SizedBox(height: 16),
            Text(
              currentSegmentIndex < segments.length
                  ? "${segments[currentSegmentIndex]}"
                  : "All segments processed!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Spacer(),
        currentSegmentIndex < segments.length
            ? ElevatedButton(
          onPressed: _isRecording ? stopRecording : startRecording,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isRecording ? Colors.blueGrey : Colors.teal,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          child: Text(
            _isRecording ? "Stop Recording" : "Start Recording",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
          ),
        )
            : Text(
          "",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black),
        )
          ],
        ),
      ),
    );
  }
}

class SegmentProcessor {
  final List<double> previousScores = [];

  double errorFlow(double errorRate, double flowRate) {
    return (0.7 * errorRate + 0.3 * flowRate).clamp(0.0, 1.0);
  }

  bool canRepeat(double score) {
    previousScores.add(score);
    if (previousScores.length >= 3) {
      bool allBelowThreshold =
      previousScores.sublist(previousScores.length - 3).every((s) => s < 0.3);
      if (allBelowThreshold) {
        previousScores.clear();
        return false;
      }
    }
    return true;
  }
}
