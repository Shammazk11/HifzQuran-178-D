import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:archive/archive.dart';

import 'Mushabihat.dart';
import 'PerformanceDashboardPage.dart';
import 'config.dart';

class QuranSpeechSessionsPage1 extends StatefulWidget {
  final Map<String, dynamic> session;

  const QuranSpeechSessionsPage1({super.key, required this.session});

  @override
  QuranSpeechSessionsPageState createState() => QuranSpeechSessionsPageState();
}

class QuranSpeechSessionsPageState extends State<QuranSpeechSessionsPage1>
    with SingleTickerProviderStateMixin {
  List<String> ayahSegments = [];
  int currentSegmentIndex = 0;
  String combinedAyahs = "";
  bool isLoading = true;
  bool _isRecording = false;
  bool _isPlaying = false;
  List<bool?> _wordCorrectness = [];
  late final AudioRecorder _audioRecorder;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _recorderInitialized = false;
  String _recordingPath = '';
  List<String> _referenceAudioPaths = []; // Changed to List<String>
  List<double> previousScores = [];
  bool isCombinedPhase = false;
  Map<String, dynamic>? fullSessionData;
  bool isSessionCompleted = false;
  int _currentAudioIndex = 0; // Track which audio is playing in combined phase
  List<List<MushabihatAyah>> mushabihatGroups = [];
  List<bool> isMushabihatAyah =
      []; // Tracks if each ayah is in a mushabihat group
  static const Map<String, int> surahNameToNumber = {
    "Al-Fatihah": 1,
    "Al-Baqarah": 2,
    "Aal-E-Imran": 3,
    "An-Nisa": 4,
    "Al-Ma'idah": 5,
    "Al-An'am": 6,
    "Al-A'raf": 7,
    "Al-Anfal": 8,
    "At-Tawbah": 9,
    "Yunus": 10,
    "Hud": 11,
    "Yusuf": 12,
    "Ar-Ra'd": 13,
    "Ibrahim": 14,
    "Al-Hijr": 15,
    "An-Nahl": 16,
    "Al-Isra": 17,
    "Al-Kahf": 18,
    "Maryam": 19,
    "Taha": 20,
    "Al-Anbiya": 21,
    "Al-Hajj": 22,
    "Al-Mu'minun": 23,
    "An-Nur": 24,
    "Al-Furqan": 25,
    "Ash-Shu'ara": 26,
    "An-Naml": 27,
    "Al-Qasas": 28,
    "Al-Ankabut": 29,
    "Ar-Rum": 30,
    "Luqman": 31,
    "As-Sajda": 32,
    "Al-Ahzab": 33,
    "Saba": 34,
    "Fatir": 35,
    "Ya-Sin": 36,
    "As-Saffat": 37,
    "Sad": 38,
    "Az-Zumar": 39,
    "Ghafir": 40,
    "Fussilat": 41,
    "Ash-Shura": 42,
    "Az-Zukhruf": 43,
    "Ad-Dukhan": 44,
    "Al-Jathiya": 45,
    "Al-Ahqaf": 46,
    "Muhammad": 47,
    "Al-Fath": 48,
    "Al-Hujurat": 49,
    "Qaf": 50,
    "Adh-Dhariyat": 51,
    "At-Tur": 52,
    "An-Najm": 53,
    "Al-Qamar": 54,
    "Ar-Rahman": 55,
    "Al-Waqi'a": 56,
    "Al-Hadid": 57,
    "Al-Mujadila": 58,
    "Al-Hashr": 59,
    "Al-Mumtahina": 60,
    "As-Saff": 61,
    "Al-Jumu'a": 62,
    "Al-Munafiqun": 63,
    "At-Taghabun": 64,
    "At-Talaq": 65,
    "At-Tahrim": 66,
    "Al-Mulk": 67,
    "Al-Qalam": 68,
    "Al-Haqqah": 69,
    "Al-Ma'arij": 70,
    "Nuh": 71,
    "Al-Jinn": 72,
    "Al-Muzzammil": 73,
    "Al-Muddathir": 74,
    "Al-Qiyamah": 75,
    "Al-Insan": 76,
    "Al-Mursalat": 77,
    "An-Naba": 78,
    "An-Nazi'at": 79,
    "Abasa": 80,
    "At-Takwir": 81,
    "Al-Infitar": 82,
    "Al-Mutaffifin": 83,
    "Al-Inshiqaq": 84,
    "Al-Buruj": 85,
    "At-Tariq": 86,
    "Al-A'la": 87,
    "Al-Ghashiyah": 88,
    "Al-Fajr": 89,
    "Al-Balad": 90,
    "Ash-Shams": 91,
    "Al-Lail": 92,
    "Adh-Duhaa": 93,
    "Ash-Sharh": 94,
    "At-Tin": 95,
    "Al-Alaq": 96,
    "Al-Qadr": 97,
    "Al-Bayyina": 98,
    "Az-Zalzalah": 99,
    "Al-Adiyat": 100,
    "Al-Qari'ah": 101,
    "At-Takathur": 102,
    "Al-Asr": 103,
    "Al-Humazah": 104,
    "Al-Fil": 105,
    "Quraish": 106,
    "Al-Ma'un": 107,
    "Al-Kawthar": 108,
    "Al-Kafirun": 109,
    "An-Nasr": 110,
    "Al-Masad": 111,
    "Al-Ikhlas": 112,
    "Al-Falaq": 113,
    "An-Nas": 114
  };

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _initRecorder();
    print("Initial session data: ${widget.session}");
    _loadAndFetchData();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation =
        Tween<double>(begin: 1.0, end: 1.2).animate(_animationController);

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    // Handle completion of one audio to play the next in combined phase
    _audioPlayer.onPlayerComplete.listen((event) {
      if (isCombinedPhase &&
          _currentAudioIndex < _referenceAudioPaths.length - 1) {
        setState(() {
          _currentAudioIndex++;
        });
        _audioPlayer
            .play(DeviceFileSource(_referenceAudioPaths[_currentAudioIndex]));
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadAndFetchData() async {
    await _loadMushabihatData();
    await fetchAyahs(widget.session);
  }

  Future<void> _loadMushabihatData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('lib/images/similar.json');
      final List<dynamic> jsonData = jsonDecode(jsonString);
      setState(() {
        mushabihatGroups = jsonData
            .map((group) => (group as List)
                .map((ayah) => MushabihatAyah.fromJson(ayah))
                .toList())
            .toList();
        print("Mushabihat groups loaded: ${mushabihatGroups.length}");
      });
    } catch (e) {
      print('Error loading mushabihat data: $e');
    }
  }

  Future<void> _initRecorder() async {
    try {
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) return;
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
        body: jsonEncode({'_id': session['_id']}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          ayahSegments = (data['ayahs'] as List)
              .map((entry) => "${entry['text']} •")
              .toList();
          _wordCorrectness = List<bool?>.filled(
              ayahSegments.isNotEmpty
                  ? ayahSegments[0]
                      .split(' ')
                      .where((word) => word != '•')
                      .length
                  : 0,
              null);
          fullSessionData = data;
          isLoading = false;
          isSessionCompleted = data['status'] == 'completed';
          isMushabihatAyah = (data['ayahs'] as List).map((ayah) {
            int? surahNumber = surahNameToNumber[ayah['surah']];
            if (surahNumber == null) {
              print("Warning: No surah number found for ${ayah['surah']}");
              return false;
            }
            bool isMushabihat = mushabihatGroups.any((group) => group.any(
                (mAyah) =>
                    mAyah.suraNumber == surahNumber &&
                    mAyah.ayahNumber == ayah['ayah']));
            print(
                "Ayah (Surah: ${ayah['surah']} ($surahNumber), Ayah: ${ayah['ayah']}): isMushabihat = $isMushabihat");
            return isMushabihat;
          }).toList();
          print("isMushabihatAyah: $isMushabihatAyah");
        });
        await _fetchReferenceAudio();
      } else {
        setState(() => isLoading = false);
        _showCustomSnackBar('Failed to load session: ${response.statusCode}',
            isError: true);
      }
    } catch (error) {
      print('Error fetching Ayahs: $error');
      setState(() => isLoading = false);
      _showCustomSnackBar('Error loading session data', isError: true);
    }
  }

  Future<void> _fetchReferenceAudio() async {
    if (currentSegmentIndex >= ayahSegments.length && !isCombinedPhase) return;

    const String audioUrl = '${AppConfig.baseUrl}/getayahsaudio';
    String textToSend = isCombinedPhase
        ? combinedAyahs.trim()
        : ayahSegments[currentSegmentIndex].replaceAll(' •', '');

    List<Map<String, dynamic>> ayahData = [];
    if (fullSessionData != null && fullSessionData!['ayahs'] != null) {
      if (isCombinedPhase) {
        ayahData = (fullSessionData!['ayahs'] as List).map((ayah) {
          return {
            'text': ayah['text'],
            'surah_number': surahNameToNumber[ayah['surah']] ?? 0,
            'ayah_number': ayah['ayah'],
          };
        }).toList();
      } else {
        if (currentSegmentIndex < (fullSessionData!['ayahs'] as List).length) {
          final currentAyah =
              (fullSessionData!['ayahs'] as List)[currentSegmentIndex];
          ayahData = [
            {
              'text': currentAyah['text'],
              'surah_number': surahNameToNumber[currentAyah['surah']] ?? 0,
              'ayah_number': currentAyah['ayah'],
            }
          ];
        }
      }
    }

    try {
      final response = await http.post(
        Uri.parse(audioUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ayah_text': textToSend,
          'ayah_data': ayahData,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final audioUrls = data['audio_urls'] as List<dynamic>;
        if (audioUrls.isNotEmpty) {
          final tempDir = await getTemporaryDirectory();
          _referenceAudioPaths.clear();

          for (int i = 0; i < audioUrls.length; i++) {
            final zipResponse = await http.get(Uri.parse(audioUrls[i]));
            if (zipResponse.statusCode == 200) {
              // Extract ZIP file
              final archive = ZipDecoder().decodeBytes(zipResponse.bodyBytes);
              for (final file in archive) {
                if (file.isFile &&
                    (file.name.endsWith('.mp3') ||
                        file.name.endsWith('.m4a'))) {
                  final audioPath =
                      '${tempDir.path}/reference_${isCombinedPhase ? "combined_$i" : currentSegmentIndex}_${file.name}';
                  final audioFile = File(audioPath);
                  await audioFile.writeAsBytes(file.content as List<int>);
                  _referenceAudioPaths.add(audioPath);
                  print('Extracted audio file: $audioPath');
                }
              }
            } else {
              _showCustomSnackBar('Failed to download ZIP $i', isError: true);
            }
          }

          if (_referenceAudioPaths.isEmpty) {
            _showCustomSnackBar('No audio files extracted from ZIP',
                isError: true);
          }
        } else {
          _showCustomSnackBar('No audio URLs returned', isError: true);
          setState(() => _referenceAudioPaths = []);
        }
      } else {
        _showCustomSnackBar(
            'Failed to fetch audio URLs: ${response.statusCode}',
            isError: true);
        setState(() => _referenceAudioPaths = []);
      }
    } catch (e) {
      print('Error fetching reference audio: $e');
      _showCustomSnackBar('Error loading reference audio: $e', isError: true);
      setState(() => _referenceAudioPaths = []);
    }
  }

  Future<void> _toggleRecording() async {
    if (!_recorderInitialized) {
      _showCustomSnackBar('Microphone not initialized or permission denied',
          isError: true);
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
      if (recordingFile.existsSync()) await recordingFile.delete();
      const config = RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
        numChannels: 2,
      );
      await _audioRecorder.start(config, path: _recordingPath);
      setState(() => _isRecording = true);
    } catch (e) {
      _showCustomSnackBar('Error starting recording: $e', isError: true);
    }
  }

  Future<void> _stopRecordingAndSend() async {
    if (!_isRecording) return;
    try {
      setState(() => _isRecording = false);
      final path = await _audioRecorder.stop();
      if (path != null &&
          await File(path).exists() &&
          await File(path).length() > 1000) {
        await _sendToBackend(path);
      } else {
        _showCustomSnackBar('No audio detected. Please try again.',
            isError: true);
      }
    } catch (e) {
      _showCustomSnackBar('Error stopping recording: $e', isError: true);
    }
  }

  Future<void> _togglePlayback() async {
    if (_referenceAudioPaths.isEmpty) {
      _showCustomSnackBar('No reference audio available', isError: true);
      return;
    }

    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      _currentAudioIndex = 0; // Start from the first audio
      await _audioPlayer
          .play(DeviceFileSource(_referenceAudioPaths[_currentAudioIndex]));
    }
  }

  Future<void> _sendToBackend(String audioFilePath) async {
    const String url = '${AppConfig.baseUrl}/checkspeech';
    String referenceText =
        isCombinedPhase ? combinedAyahs : ayahSegments[currentSegmentIndex];
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['original_text'] = referenceText;
      request.fields['sessionId'] = widget.session['_id'];
      request.fields['segmentIndex'] = currentSegmentIndex.toString();
      request.fields['isCombinedPhase'] = isCombinedPhase.toString();
      request.fields['isSessionCompleted'] = isSessionCompleted.toString();
      request.fields['isMushabihat'] = // Add this line
          (currentSegmentIndex < isMushabihatAyah.length &&
                  isMushabihatAyah[currentSegmentIndex])
              .toString();
      request.files
          .add(await http.MultipartFile.fromPath('audio_file', audioFilePath));
      var response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        double errorRate = double.parse(data['error_rate'].toString());
        List<bool?> correctness = List<bool?>.from(data['correctness']);
        setState(() {
          _wordCorrectness = correctness;
        });
        await processScore(errorRate);
        if (isSessionCompleted) {
          request = http.MultipartRequest('POST', Uri.parse(url));
          request.fields['original_text'] = referenceText;
          request.fields['sessionId'] = widget.session['_id'];
          request.fields['segmentIndex'] = currentSegmentIndex.toString();
          request.fields['isCombinedPhase'] = 'true';
          request.fields['isSessionCompleted'] = isSessionCompleted.toString();
          request.fields['isMushabihat'] =
              'false'; // Combined phase, no mushabihat check
          request.files.add(
              await http.MultipartFile.fromPath('audio_file', audioFilePath));
          await http.Response.fromStream(await request.send());
        }
        await fetchAyahs(widget.session);
        await _fetchReferenceAudio();
      } else {
        _showCustomSnackBar(
            'Failed to analyze speech: ${response.reasonPhrase}',
            isError: true);
      }
    } catch (e) {
      _showCustomSnackBar('Error sending recording: $e', isError: true);
    }
  }

  Future<void> processScore(double errorRate) async {
    previousScores.add(errorRate);

    // Determine the required number of successful attempts based on mushabihat status
    int requiredSuccesses = (currentSegmentIndex < isMushabihatAyah.length &&
            isMushabihatAyah[currentSegmentIndex])
        ? 4
        : 3;

    if (previousScores.length >= requiredSuccesses &&
        previousScores
            .sublist(previousScores.length - requiredSuccesses)
            .every((s) => s < 0.3)) {
      previousScores.clear();
      setState(() {
        if (!isCombinedPhase) {
          combinedAyahs += "${ayahSegments[currentSegmentIndex]} ";
          currentSegmentIndex++;
          if (currentSegmentIndex % 3 == 0 &&
              currentSegmentIndex < ayahSegments.length) {
            isCombinedPhase = true;
            _wordCorrectness =
                List<bool?>.filled(combinedAyahs.split(' ').length, null);
            _showCustomSnackBar('3 Ayahs mastered! Now practice them together.',
                icon: Icons.auto_awesome);
          } else if (currentSegmentIndex < ayahSegments.length) {
            _wordCorrectness = List<bool?>.filled(
                ayahSegments[currentSegmentIndex].split(' ').length, null);
            _showCustomSnackBar('Great job! Moving to next ayah.',
                icon: Icons.arrow_forward);
          } else {
            isCombinedPhase = true;
            combinedAyahs = ayahSegments.join(' ');
            _wordCorrectness =
                List<bool?>.filled(combinedAyahs.split(' ').length, null);
            _showCustomSnackBar(
                'All individual ayahs mastered! Now practice all together.',
                icon: Icons.auto_awesome);
          }
        } else {
          if (currentSegmentIndex < ayahSegments.length) {
            isCombinedPhase = false;
            combinedAyahs = "";
            _wordCorrectness = List<bool?>.filled(
                ayahSegments[currentSegmentIndex].split(' ').length, null);
            _showCustomSnackBar('Group mastered! Moving to next ayah.',
                icon: Icons.arrow_forward);
          } else {
            isSessionCompleted = true; // Mark session as complete
            _showCustomSnackBar(
                'Congratulations! You have completed all ayahs.',
                icon: Icons.celebration);
            print("Congratulations! You have completed all ayahs.");
            print(isSessionCompleted);
            combinedAyahs = "";
            currentSegmentIndex = 0;
            isCombinedPhase = false;
            _wordCorrectness =
                List<bool?>.filled(ayahSegments[0].split(' ').length, null);
          }
        }
      });
    }
  }

  void _showCustomSnackBar(String message,
      {IconData? icon, bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon ?? (isError ? Icons.error : Icons.info),
                color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
                child: Text(message,
                    style: const TextStyle(fontWeight: FontWeight.w500))),
          ],
        ),
        backgroundColor: isError ? Colors.red[700] : Colors.teal[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quranic Recitation',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('How to Use',
                      style: TextStyle(color: Colors.teal)),
                  content: const Text(
                    'Listen to the reference audio, then recite the ayah and tap the recording button. '
                    'Green words indicate correct pronunciation, red indicates errors, blue indicates Mushabihat'
                    'Master individual ayahs before progressing to combined practice. '
                    'Mushabihat ayahs (in blue) require 4 successful attempts, others need 3.',
                    style: TextStyle(fontSize: 15),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Got it',
                          style: TextStyle(color: Colors.teal)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              if (fullSessionData != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PerformanceDashboardPage(session: fullSessionData!),
                  ),
                );
              } else {
                _showCustomSnackBar('Session data not loaded yet',
                    isError: true);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.teal.shade50, Colors.white],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (!isSessionCompleted) ...[
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isCombinedPhase
                                  ? 'Combined Practice'
                                  : 'Ayah ${currentSegmentIndex + 1}/${ayahSegments.length}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            Text(
                              isCombinedPhase
                                  ? '100%'
                                  : '${((currentSegmentIndex / ayahSegments.length) * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: isCombinedPhase
                                ? 1.0
                                : ayahSegments.isEmpty
                                    ? 0
                                    : currentSegmentIndex / ayahSegments.length,
                            backgroundColor: Colors.grey[200],
                            color: Colors.teal,
                            minHeight: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.teal,
                              strokeWidth: 3,
                            ),
                          )
                        : isSessionCompleted
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.celebration,
                                        size: 80, color: Colors.teal[700]),
                                    const SizedBox(height: 20),
                                    const Text(
                                      'Congratulations!',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'You have completed this session.',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ayahSegments.isNotEmpty
                                ? Stack(
                                    children: [
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.teal.withOpacity(0.1),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(15),
                                              bottomLeft: Radius.circular(50),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 16),
                                              decoration: BoxDecoration(
                                                color: Colors.teal
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                isCombinedPhase
                                                    ? 'Combined Practice'
                                                    : 'Individual Ayah Practice',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.teal[700],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.teal
                                                          .withOpacity(0.2),
                                                      width: 1.5),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 10),
                                                        child: Image.asset(
                                                          'lib/images/logo.png',
                                                          height: 40,
                                                          errorBuilder: (context,
                                                                  error,
                                                                  stackTrace) =>
                                                              Icon(
                                                                  Icons
                                                                      .menu_book,
                                                                  size: 40,
                                                                  color: Colors
                                                                      .teal
                                                                      .withOpacity(
                                                                          0.5)),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      RichText(
                                                        textAlign:
                                                            TextAlign.center,
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        text: TextSpan(
                                                            children:
                                                                _buildHighlightedText()),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.warning_amber_rounded,
                                            size: 60, color: Colors.amber[700]),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'No Ayahs Found',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Please check your connection and try again',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ),
                  ),
                ),
                if (!isSessionCompleted)
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_isRecording)
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _animation.value,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            },
                          ),
                        const SizedBox(height: 8),
                        Text(
                          _isRecording
                              ? 'Recording your recitation...'
                              : 'Ready to record',
                          style: TextStyle(
                            color: _isRecording ? Colors.red : Colors.teal[700],
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: _togglePlayback,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.4),
                                      spreadRadius: 2,
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    _isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: _toggleRecording,
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      _isRecording ? Colors.red : Colors.teal,
                                  boxShadow: [
                                    BoxShadow(
                                      color: (_isRecording
                                              ? Colors.red
                                              : Colors.teal)
                                          .withOpacity(0.4),
                                      spreadRadius: 2,
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    _isRecording ? Icons.stop : Icons.mic,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<TextSpan> _buildHighlightedText() {
    String currentText = isCombinedPhase
        ? combinedAyahs
        : (currentSegmentIndex < ayahSegments.length
            ? ayahSegments[currentSegmentIndex]
            : "");
    List<String> words = currentText.split(' ');

    return List.generate(words.length, (index) {
      Color textColor;
      FontWeight fontWeight = FontWeight.bold;

      if (index < _wordCorrectness.length) {
        if (_wordCorrectness[index] == null) {
          bool isCurrentAyahMushabihat =
              currentSegmentIndex < isMushabihatAyah.length &&
                  isMushabihatAyah[currentSegmentIndex];
          textColor = isCombinedPhase
              ? Colors.black
              : (isCurrentAyahMushabihat ? Colors.blue[700]! : Colors.black);
          print(
              "Word $index: isMushabihat = $isCurrentAyahMushabihat, Color = $textColor");
        } else if (_wordCorrectness[index]!) {
          textColor = Colors.green[700]!;
          fontWeight = FontWeight.w900;
        } else {
          textColor = Colors.red[700]!;
          fontWeight = FontWeight.w900;
        }
      } else {
        textColor = Colors.black;
      }

      return TextSpan(
        text: '${words[index]} ',
        style: TextStyle(
          color: textColor,
          fontSize: 26,
          fontWeight: fontWeight,
          height: 1.6,
          fontFamily: 'Amiri',
        ),
      );
    });
  }
}
