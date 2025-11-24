import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';

import 'config.dart';

class QuranSpeechWithAudioPage extends StatefulWidget {
  final Map<String, dynamic> session;

  const QuranSpeechWithAudioPage({super.key, required this.session});

  @override
  QuranSpeechWithAudioPageState createState() =>
      QuranSpeechWithAudioPageState();
}

class QuranSpeechWithAudioPageState extends State<QuranSpeechWithAudioPage> {
  String ayahText = "";
  bool isLoading = true;
  bool _isRecording = false;
  List<bool?> _wordCorrectness = [];
  late final AudioRecorder _audioRecorder;
  bool _recorderInitialized = false;
  String _recordingPath = '';
  List<String> _audioFilePaths = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  int _currentAudioIndex = 0; // To track which audio is playing

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _initRecorder();
    fetchAyahs(widget.session); // First fetch the ayah text
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initRecorder() async {
    try {
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        print('Microphone permission not granted');
        return;
      }
      final isSupported =
          await _audioRecorder.isEncoderSupported(AudioEncoder.aacLc);
      print('AAC recording supported: $isSupported');
      _recorderInitialized = true;
    } catch (e) {
      print('Error initializing recorder: $e');
      _recorderInitialized = false;
    }
  }

  Future<void> fetchAyahs(Map<String, dynamic> session) async {
    const String backendUrl = '${AppConfig.baseUrl}/clickedsessiondetail';

    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(session),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List ayahs = data['ayahs'] as List;

        setState(() {
          ayahText = ayahs.asMap().entries.map((entry) {
            final index = entry.key;
            final ayah = entry.value['text'];
            final ayahNo = entry.value['ayah'];
            return index == ayahs.length - 1 ? ayah : "$ayah ﴿ $ayahNo ﴾";
          }).join(' ');
          _wordCorrectness =
              List<bool?>.filled(ayahText.split(' ').length, null);
        });

        // After getting ayah text, fetch the audio
        await fetchAudioForAyah(ayahText);
        setState(() => isLoading = false);
      } else {
        print('Failed to fetch Ayahs: ${response.body}');
        setState(() => isLoading = false);
      }
    } catch (error) {
      print('Error fetching Ayahs: $error');
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchAudioForAyah(String ayahText) async {
    const String audioUrl = '${AppConfig.baseUrl}/getayahsaudio';

    try {
      final response = await http.post(
        Uri.parse(audioUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'ayah_text': ayahText}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> audioUrls = data['audio_urls'];
        _audioFilePaths = [];
        for (String url in audioUrls) {
          await _downloadAndStoreAudio(url);
        }
      } else {
        print('Failed to fetch audio: ${response.body}');
      }
    } catch (e) {
      print('Error fetching audio: $e');
    }
  }

  Future<void> _downloadAndStoreAudio(String audioUrl) async {
    try {
      final response = await http.get(Uri.parse(audioUrl));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final fileName = audioUrl.split('/').last;
        final audioPath = '${tempDir.path}/$fileName';

        final audioFile = File(audioPath);
        await audioFile.writeAsBytes(response.bodyBytes);
        _audioFilePaths.add(audioPath);
        print('Audio file saved to: $audioPath');
      }
    } catch (e) {
      print('Error downloading audio: $e');
    }
  }

  Future<void> _playAudio() async {
    if (_audioFilePaths.isNotEmpty &&
        !_isPlaying &&
        _currentAudioIndex < _audioFilePaths.length) {
      try {
        await _audioPlayer
            .play(DeviceFileSource(_audioFilePaths[_currentAudioIndex]));
        setState(() => _isPlaying = true);
        _audioPlayer.onPlayerComplete.listen((event) {
          setState(() {
            _isPlaying = false;
            _currentAudioIndex++;
            if (_currentAudioIndex < _audioFilePaths.length) {
              _playAudio(); // Play next audio automatically
            } else {
              _currentAudioIndex = 0; // Reset to beginning
            }
          });
        });
      } catch (e) {
        print('Error playing audio: $e');
      }
    }
  }

  Future<void> _stopAudio() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      setState(() => _isPlaying = false);
    }
  }

  Future<void> _toggleRecording() async {
    if (!_recorderInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Microphone not initialized or permission denied')),
      );
      return;
    }

    if (_isRecording) {
      await _stopRecordingAndSend();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    try {
      final tempDir = await getTemporaryDirectory();
      _recordingPath = '${tempDir.path}/audio_recording.m4a';

      final recordingFile = File(_recordingPath);
      if (recordingFile.existsSync()) {
        await recordingFile.delete();
      }

      if (await _audioRecorder.isRecording()) {
        print('Recorder is already recording');
        return;
      }

      const config = RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
        numChannels: 2,
      );

      await _audioRecorder.start(config, path: _recordingPath);
      setState(() => _isRecording = true);
      print('Recording started, saving to: $_recordingPath');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recording started...')),
        );
      }
    } catch (e) {
      print('Error starting recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting recording: $e')),
        );
      }
    }
  }

  Future<void> _stopRecordingAndSend() async {
    if (!_isRecording) return;

    try {
      setState(() => _isRecording = false);
      final path = await _audioRecorder.stop();

      if (path != null && File(path).existsSync()) {
        final fileSize = await File(path).length();
        print('Recording stopped, saved to: $path');
        print('File size: $fileSize bytes');

        if (fileSize > 1000) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sending recording to server...')),
            );
          }
          await _sendToBackend(path);
        } else {
          print('File too small: $fileSize bytes');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('No audio detected. Please try again.')),
            );
          }
        }
      }
    } catch (e) {
      print('Error stopping recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error stopping recording: $e')),
        );
      }
    }
  }

  Future<void> _sendToBackend(String audioFilePath) async {
    const String url = '${AppConfig.baseUrl}/checkspeech';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['original_text'] = ayahText;
      var audioFile =
          await http.MultipartFile.fromPath('audio_file', audioFilePath);
      request.files.add(audioFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('correctness')) {
          List<bool?> correctness = List<bool?>.from(data['correctness']);
          setState(() {
            _wordCorrectness = correctness;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Speech analyzed successfully')),
            );
          }
        }
      } else {
        print(
            'Failed to send recording: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error sending recording: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending recording: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran Ayahs with Audio'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            isLoading
                ? const Expanded(
                    child: Center(child: CircularProgressIndicator()))
                : ayahText.isNotEmpty
                    ? Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: SingleChildScrollView(
                            child: RichText(
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              text: TextSpan(children: _buildHighlightedText()),
                            ),
                          ),
                        ),
                      )
                    : const Center(
                        child: Text(
                          'No Ayahs Found',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isPlaying ? _stopAudio : _playAudio,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[400],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_isPlaying ? Icons.stop : Icons.play_arrow,
                          color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        _isPlaying ? 'Stop Audio' : 'Play Audio',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            _isRecording
                ? Text(
                    'Recording... ${_isRecording ? '🔴' : ''}',
                    style: TextStyle(
                      color: _isRecording ? Colors.red : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Container(),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _toggleRecording,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isRecording ? Colors.red : Colors.teal[600],
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_isRecording ? Icons.stop : Icons.mic,
                      color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    _isRecording ? 'Stop Recording' : 'Start Recording',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  List<TextSpan> _buildHighlightedText() {
    List<String> words = ayahText.split(' ');
    return List.generate(words.length, (index) {
      Color textColor;
      if (index < _wordCorrectness.length) {
        textColor = _wordCorrectness[index] == null
            ? Colors.black
            : _wordCorrectness[index]!
                ? Colors.green
                : Colors.red;
      } else {
        textColor = Colors.black;
      }
      return TextSpan(
        text: '${words[index]} ',
        style: TextStyle(
          color: textColor,
          fontSize: 23,
          fontWeight: FontWeight.bold,
        ),
      );
    });
  }
}
