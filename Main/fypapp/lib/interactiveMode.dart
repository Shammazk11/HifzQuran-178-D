import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'dart:core';

class SegmentProcessorScreen extends StatefulWidget {
  final Map<String, dynamic> modelData;

  const SegmentProcessorScreen({super.key, required this.modelData});

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
    print(segments);
    processNextSegment();
  }

  Future<void> _initRecorder() async {
    await _recorder.openRecorder();
    setState(() {});
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
          segments.add(message); // Add the individual segment
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
            segments.add(message); // Add the combined segments
            flag = false;
          }
          previousScores.clear();
          if (ayahData['segments'].indexOf(segment) ==
              ayahData['segments'].length - 1) {
            print(ayatCombine);
            ayatCombine += "$combinedSegments ";
            previousScores.clear();
            flag = true;
            previousScores.clear();
            // Process final ayatCombine
            while (flag) {
              String message = ayatCombine;
              segments.add(message); // Add the final combined segments
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

  void handleVoiceInput(String path) async {
    setState(() {
      currentVoiceInput = path;
    });
    String referenceText = segments[currentSegmentIndex];
    try {
      var request = http.MultipartRequest('POST',
          Uri.parse("https://570c-149-40-228-114.ngrok-free.app/assess"));
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
                height: 350,
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
                      backgroundColor:
                          _isRecording ? Colors.blueGrey : Colors.teal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                    ),
                    child: Text(
                      _isRecording ? "Stop Recording" : "Start Recording",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  )
                : Text(
                    "",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
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
      bool allBelowThreshold = previousScores
          .sublist(previousScores.length - 3)
          .every((s) => s < 0.3);
      if (allBelowThreshold) {
        previousScores.clear();
        return false;
      }
    }
    return true;
  }
}
