import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fypapp/provider.dart';
import 'package:fypapp/voice.dart';
import 'package:fypapp/voice1.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import './speech.dart';
import 'config.dart';
import 'interactiveMode.dart';

class UserSessionsPage extends StatefulWidget {
  const UserSessionsPage({super.key});

  @override
  UserSessionsPageState createState() => UserSessionsPageState();
}

class UserSessionsPageState extends State<UserSessionsPage>
    with SingleTickerProviderStateMixin {
  Map<String, List<dynamic>> groupedSessions = {};
  final List<Map<String, String>> surahData = [
    {"surahIndex": "1", "name": "Al-Fatihah"},
    {"surahIndex": "2", "name": "Al-Baqarah"},
    {"surahIndex": "3", "name": "Aal-E-Imran"},
    {"surahIndex": "4", "name": "An-Nisa"},
    {"surahIndex": "5", "name": "Al-Ma'idah"},
    {"surahIndex": "6", "name": "Al-An'am"},
    {"surahIndex": "7", "name": "Al-A'raf"},
    {"surahIndex": "8", "name": "Al-Anfal"},
    {"surahIndex": "9", "name": "At-Tawbah"},
    {"surahIndex": "10", "name": "Yunus"},
    {"surahIndex": "11", "name": "Hud"},
    {"surahIndex": "12", "name": "Yusuf"},
    {"surahIndex": "13", "name": "Ar-Ra'd"},
    {"surahIndex": "14", "name": "Ibrahim"},
    {"surahIndex": "15", "name": "Al-Hijr"},
    {"surahIndex": "16", "name": "An-Nahl"},
    {"surahIndex": "17", "name": "Al-Isra"},
    {"surahIndex": "18", "name": "Al-Kahf"},
    {"surahIndex": "19", "name": "Maryam"},
    {"surahIndex": "20", "name": "Taha"},
    {"surahIndex": "21", "name": "Al-Anbiya"},
    {"surahIndex": "22", "name": "Al-Hajj"},
    {"surahIndex": "23", "name": "Al-Mu’minun"},
    {"surahIndex": "24", "name": "An-Nur"},
    {"surahIndex": "25", "name": "Al-Furqan"},
    {"surahIndex": "26", "name": "Ash-Shu'ara"},
    {"surahIndex": "27", "name": "An-Naml"},
    {"surahIndex": "28", "name": "Al-Qasas"},
    {"surahIndex": "29", "name": "Al-Ankabut"},
    {"surahIndex": "30", "name": "Ar-Rum"},
    {"surahIndex": "31", "name": "Luqman"},
    {"surahIndex": "32", "name": "As-Sajda"},
    {"surahIndex": "33", "name": "Al-Ahzab"},
    {"surahIndex": "34", "name": "Saba"},
    {"surahIndex": "35", "name": "Fatir"},
    {"surahIndex": "36", "name": "Ya-Sin"},
    {"surahIndex": "37", "name": "As-Saffat"},
    {"surahIndex": "38", "name": "Sad"},
    {"surahIndex": "39", "name": "Az-Zumar"},
    {"surahIndex": "40", "name": "Ghafir"},
    {"surahIndex": "41", "name": "Fussilat"},
    {"surahIndex": "42", "name": "Ash-Shura"},
    {"surahIndex": "43", "name": "Az-Zukhruf"},
    {"surahIndex": "44", "name": "Ad-Dukhan"},
    {"surahIndex": "45", "name": "Al-Jathiya"},
    {"surahIndex": "46", "name": "Al-Ahqaf"},
    {"surahIndex": "47", "name": "Muhammad"},
    {"surahIndex": "48", "name": "Al-Fath"},
    {"surahIndex": "49", "name": "Al-Hujurat"},
    {"surahIndex": "50", "name": "Qaf"},
    {"surahIndex": "51", "name": "Adh-Dhariyat"},
    {"surahIndex": "52", "name": "At-Tur"},
    {"surahIndex": "53", "name": "An-Najm"},
    {"surahIndex": "54", "name": "Al-Qamar"},
    {"surahIndex": "55", "name": "Ar-Rahman"},
    {"surahIndex": "56", "name": "Al-Waqi'a"},
    {"surahIndex": "57", "name": "Al-Hadid"},
    {"surahIndex": "58", "name": "Al-Mujadila"},
    {"surahIndex": "59", "name": "Al-Hashr"},
    {"surahIndex": "60", "name": "Al-Mumtahina"},
    {"surahIndex": "61", "name": "As-Saff"},
    {"surahIndex": "62", "name": "Al-Jumu'a"},
    {"surahIndex": "63", "name": "Al-Munafiqun"},
    {"surahIndex": "64", "name": "At-Taghabun"},
    {"surahIndex": "65", "name": "At-Talaq"},
    {"surahIndex": "66", "name": "At-Tahrim"},
    {"surahIndex": "67", "name": "Al-Mulk"},
    {"surahIndex": "68", "name": "Al-Qalam"},
    {"surahIndex": "69", "name": "Al-Haqqah"},
    {"surahIndex": "70", "name": "Al-Ma'arij"},
    {"surahIndex": "71", "name": "Nuh"},
    {"surahIndex": "72", "name": "Al-Jinn"},
    {"surahIndex": "73", "name": "Al-Muzzammil"},
    {"surahIndex": "74", "name": "Al-Muddathir"},
    {"surahIndex": "75", "name": "Al-Qiyamah"},
    {"surahIndex": "76", "name": "Al-Insan"},
    {"surahIndex": "77", "name": "Al-Mursalat"},
    {"surahIndex": "78", "name": "An-Naba"},
    {"surahIndex": "79", "name": "An-Nazi'at"},
    {"surahIndex": "80", "name": "Abasa"},
    {"surahIndex": "81", "name": "At-Takwir"},
    {"surahIndex": "82", "name": "Al-Infitar"},
    {"surahIndex": "83", "name": "Al-Mutaffifin"},
    {"surahIndex": "84", "name": "Al-Inshiqaq"},
    {"surahIndex": "85", "name": "Al-Buruj"},
    {"surahIndex": "86", "name": "At-Tariq"},
    {"surahIndex": "87", "name": "Al-A'la"},
    {"surahIndex": "88", "name": "Al-Ghashiyah"},
    {"surahIndex": "89", "name": "Al-Fajr"},
    {"surahIndex": "90", "name": "Al-Balad"},
    {"surahIndex": "91", "name": "Ash-Shams"},
    {"surahIndex": "92", "name": "Al-Lail"},
    {"surahIndex": "93", "name": "Adh-Duhaa"},
    {"surahIndex": "94", "name": "Ash-Sharh"},
    {"surahIndex": "95", "name": "At-Tin"},
    {"surahIndex": "96", "name": "Al-Alaq"},
    {"surahIndex": "97", "name": "Al-Qadr"},
    {"surahIndex": "98", "name": "Al-Bayyina"},
    {"surahIndex": "99", "name": "Az-Zalzalah"},
    {"surahIndex": "100", "name": "Al-Adiyat"},
    {"surahIndex": "101", "name": "Al-Qari'ah"},
    {"surahIndex": "102", "name": "At-Takathur"},
    {"surahIndex": "103", "name": "Al-Asr"},
    {"surahIndex": "104", "name": "Al-Humazah"},
    {"surahIndex": "105", "name": "Al-Fil"},
    {"surahIndex": "106", "name": "Quraish"},
    {"surahIndex": "107", "name": "Al-Ma'un"},
    {"surahIndex": "108", "name": "Al-Kawthar"},
    {"surahIndex": "109", "name": "Al-Kafirun"},
    {"surahIndex": "110", "name": "An-Nasr"},
    {"surahIndex": "111", "name": "Al-Masad"},
    {"surahIndex": "112", "name": "Al-Ikhlas"},
    {"surahIndex": "113", "name": "Al-Falaq"},
    {"surahIndex": "114", "name": "An-Nas"}
  ];

  bool isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    fetchSessions();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchSessions() async {
    if (!mounted) return; // Early exit if widget is already disposed

    final email = Provider.of<UserProvider>(context, listen: false).email;
    const String apiUrl = "${AppConfig.baseUrl}/user-sessions";

    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Raw session data: $data"); // Debug raw response
        if (mounted) { // Check mounted before updating state
          setState(() {
            groupedSessions = Map<String, List<dynamic>>.from(data);
            isLoading = false;
          });
        }
      } else {
        if (mounted) { // Check mounted before updating state
          setState(() {
            isLoading = false;
          });
        }
        print("Failed to fetch sessions: ${response.body}");
        _showCustomSnackBar("Failed to load sessions", isError: true);
      }
    } catch (e) {
      if (mounted) { // Check mounted before updating state
        setState(() {
          isLoading = false;
        });
      }
      print("Error fetching sessions: $e");
      _showCustomSnackBar("Network error: $e", isError: true);
    }
  }

  String getSurahIndex(String surahName) {
    for (var surah in surahData) {
      if (surah["name"]!.toLowerCase() == surahName.toLowerCase()) {
        return surah["surahIndex"]!;
      }
    }
    return "Surah not found";
  }

  void _showCustomSnackBar(String message, {IconData? icon, bool isError = false, bool isSuccess = false}) {
    if (!mounted) return; // Avoid showing snackbar if widget is disposed

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon ?? (isError ? Icons.error : (isSuccess ? Icons.check_circle : Icons.info)),
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(message, style: const TextStyle(fontWeight: FontWeight.w500))),
          ],
        ),
        backgroundColor: isError ? Colors.red[700] : (isSuccess ? Colors.green[700] : Colors.teal[700]),
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
        title: const Text(
          "User Sessions",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade50, Colors.white],
          ),
        ),
        child: isLoading
            ? const Center(
          child: CircularProgressIndicator(
            color: Colors.teal,
            strokeWidth: 3,
          ),
        )
            : groupedSessions.isEmpty
            ? _buildEmptyState()
            : Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 16, top: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.book_rounded,
                        color: Colors.teal[700],
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Session Groups',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${groupedSessions.length}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  'Your Sessions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: groupedSessions.length,
                  itemBuilder: (context, index) {
                    final entry = groupedSessions.entries.elementAt(index);
                    final goalId = entry.key;
                    final sessions = entry.value;

                    return AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.1),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                (index / groupedSessions.length) * 0.5,
                                0.5 + (index / groupedSessions.length) * 0.5,
                                curve: Curves.easeOut,
                              ),
                            )),
                            child: child,
                          ),
                        );
                      },
                      child: _buildSessionGroupCard(goalId, sessions, index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionGroupCard(String goalId, List<dynamic> sessions, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade400, Colors.teal.shade600],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          goalId.substring(goalId.length - 2).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Goal ID',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          goalId.substring(goalId.length - 8),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.book, size: 18, color: Colors.teal),
                    SizedBox(width: 8),
                    Text(
                      'Sessions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...sessions.asMap().entries.map((entry) {
                  final session = entry.value;
                  final sessionNumber = session['sessionNumber'];
                  final ayahsLeft = session['ayahsLeft'];
                  final quranReferences = session['quranReferences'] as List;

                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            backgroundColor: Colors.white,
                            title: const Text(
                              'Select Mode',
                              style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: const Text(
                              'Which mode would you like to use?',
                              style: TextStyle(color: Colors.black87),
                            ),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: Text('Recite'),
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuranSpeechSessionsPage(session: session),
                                    ),
                                  ).then((value) {
                                    if (mounted) {
                                      fetchSessions();
                                    }
                                  });
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: Text('Learn Recite'),
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuranSpeechSessionsPage1(session: session),
                                    ),
                                  ).then((value) {
                                    if (mounted) {
                                      fetchSessions();
                                    }
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },

                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.teal.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${entry.key + 1}',
                                    style: TextStyle(
                                      color: Colors.teal[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Session: $sessionNumber",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  Text(
                                    "Ayahs Left: $ayahsLeft",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...quranReferences.map((ref) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 32, bottom: 4),
                              child: Text(
                                "Para ${ref['para']}, Surah ${ref['surah']}, Ayah ${ref['ayah']}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.book_outlined,
              size: 60,
              color: Colors.teal.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "No Sessions Found",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "You haven't started any sessions yet. Begin your Quran learning journey now!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}