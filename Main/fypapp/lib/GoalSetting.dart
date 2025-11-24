import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import './provider.dart';
import 'config.dart';

class GoalSettingPage extends StatefulWidget {
  const GoalSettingPage({super.key});

  @override
  GoalSettingPageState createState() => GoalSettingPageState();
}

class GoalSettingPageState extends State<GoalSettingPage> {
  // Para-Surah mapping data
  List<Map<String, dynamic>> goalReferences = [];

  final Map<String, List<Map<String, String>>> paraData = {
    "Para 1": [
      {"Surah": "Al-Fatihah", "Range": "1:1 - 1:7"},
      {"Surah": "Al-Baqarah", "Range": "2:1 - 2:141"}
    ],
    "Para 2": [
      {"Surah": "Al-Baqarah", "Range": "2:142 - 2:252"}
    ],
    "Para 3": [
      {"Surah": "Al-Baqarah", "Range": "2:253 - 2:286"},
      {"Surah": "Al-Imran", "Range": "3:1 - 3:92"}
    ],
    "Para 4": [
      {"Surah": "Al-Imran", "Range": "3:93 - 3:200"},
      {"Surah": "An-Nisa", "Range": "4:1 - 4:23"}
    ],
    "Para 5": [
      {"Surah": "An-Nisa", "Range": "4:24 - 4:147"}
    ],
    "Para 6": [
      {"Surah": "An-Nisa", "Range": "4:148 - 4:176"},
      {"Surah": "Al-Ma'idah", "Range": "5:1 - 5:81"}
    ],
    "Para 7": [
      {"Surah": "Al-Ma'idah", "Range": "5:82 - 5:120"},
      {"Surah": "Al-An'am", "Range": "6:1 - 6:110"}
    ],
    "Para 8": [
      {"Surah": "Al-An'am", "Range": "6:111 - 6:165"},
      {"Surah": "Al-A'raf", "Range": "7:1 - 7:87"}
    ],
    "Para 9": [
      {"Surah": "Al-A'raf", "Range": "7:88 - 7:206"},
      {"Surah": "Al-Anfal", "Range": "8:1 - 8:40"}
    ],
    "Para 10": [
      {"Surah": "Al-Anfal", "Range": "8:41 - 8:75"},
      {"Surah": "At-Tawbah", "Range": "9:1 - 9:92"}
    ],
    "Para 11": [
      {"Surah": "At-Tawbah", "Range": "9:93 - 9:129"},
      {"Surah": "Yunus", "Range": "10:1 - 10:109"},
      {"Surah": "Hud", "Range": "11:1 - 11:5"}
    ],
    "Para 12": [
      {"Surah": "Hud", "Range": "11:6 - 11:123"},
      {"Surah": "Yusuf", "Range": "12:1 - 12:52"}
    ],
    "Para 13": [
      {"Surah": "Yusuf", "Range": "12:53 - 12:111"},
      {"Surah": "Ar-Ra'd", "Range": "13:1 - 13:43"},
      {"Surah": "Ibrahim", "Range": "14:1 - 14:52"}
    ],
    "Para 14": [
      {"Surah": "Al-Hijr", "Range": "15:1 - 15:99"},
      {"Surah": "An-Nahl", "Range": "16:1 - 16:128"}
    ],
    "Para 15": [
      {"Surah": "Al-Isra", "Range": "17:1 - 17:111"},
      {"Surah": "Al-Kahf", "Range": "18:1 - 18:74"}
    ],
    "Para 16": [
      {"Surah": "Al-Kahf", "Range": "18:75 - 18:110"},
      {"Surah": "Maryam", "Range": "19:1 - 19:98"},
      {"Surah": "Ta-Ha", "Range": "20:1 - 20:135"}
    ],
    "Para 17": [
      {"Surah": "Al-Anbiya", "Range": "21:1 - 21:112"},
      {"Surah": "Al-Hajj", "Range": "22:1 - 22:78"}
    ],
    "Para 18": [
      {"Surah": "Al-Mu'minun", "Range": "23:1 - 23:118"},
      {"Surah": "An-Nur", "Range": "24:1 - 24:64"},
      {"Surah": "Al-Furqan", "Range": "25:1 - 25:20"}
    ],
    "Para 19": [
      {"Surah": "Al-Furqan", "Range": "25:21 - 25:77"},
      {"Surah": "Ash-Shu'ara", "Range": "26:1 - 26:227"},
      {"Surah": "An-Naml", "Range": "27:1 - 27:55"}
    ],
    "Para 20": [
      {"Surah": "An-Naml", "Range": "27:56 - 27:93"},
      {"Surah": "Al-Qasas", "Range": "28:1 - 28:88"},
      {"Surah": "Al-Ankabut", "Range": "29:1 - 29:45"}
    ],
    "Para 21": [
      {"Surah": "Al-Ankabut", "Range": "29:46 - 29:69"},
      {"Surah": "Ar-Rum", "Range": "30:1 - 30:60"},
      {"Surah": "Luqman", "Range": "31:1 - 31:34"},
      {"Surah": "As-Sajda", "Range": "32:1 - 32:30"},
      {"Surah": "Al-Azhab", "Range": "33:1 - 33:30"}
    ],
    "Para 22": [
      {"Surah": "Al-Azhab", "Range": "33:31 - 33:73"},
      {"Surah": "Saba", "Range": "34:1 - 34:54"},
      {"Surah": "Fatir", "Range": "35:1 - 35:45"},
      {"Surah": "Ya-Sin", "Range": "36:1 - 36:27"}
    ],
    "Para 23": [
      {"Surah": "Ya-Sin", "Range": "36:28 - 36:83"},
      {"Surah": "As-Saffat", "Range": "37:1 - 37:182"},
      {"Surah": "Sad", "Range": "38:1 - 38:88"},
      {"Surah": "Az-Zumar", "Range": "39:1 - 39:31"}
    ],
    "Para 24": [
      {"Surah": "Az-Zumar", "Range": "39:32 - 39:75"},
      {"Surah": "Ghafir", "Range": "40:1 - 40:85"},
      {"Surah": "Fussilat", "Range": "41:1 - 41:46"}
    ],
    "Para 25": [
      {"Surah": "Fussilat", "Range": "41:47 - 41:54"},
      {"Surah": "Ash-Shura", "Range": "42:1 - 42:53"},
      {"Surah": "Az-Zukhruf", "Range": "43:1 - 43:89"},
      {"Surah": "Ad-Dukhan", "Range": "44:1 - 44:59"},
      {"Surah": "Al-Jathiyah", "Range": "45:1 - 45:37"}
    ],
    "Para 26": [
      {"Surah": "Al-Ahqaf", "Range": "46:1 - 46:35"},
      {"Surah": "Muhammad", "Range": "47:1 - 47:38"},
      {"Surah": "Al-Fath", "Range": "48:1 - 48:29"},
      {"Surah": "Al-Hujurat", "Range": "49:1 - 49:18"},
      {"Surah": "Qaf", "Range": "50:1 - 50:45"},
      {"Surah": "Az-Zariyat", "Range": "51:1 - 51:30"}
    ],
    "Para 27": [
      {"Surah": "Az-Zariyat", "Range": "51:31 - 51:60"},
      {"Surah": "At-Tur", "Range": "52:1 - 52:49"},
      {"Surah": "An-Najm", "Range": "53:1 - 53:62"},
      {"Surah": "Al-Qamar", "Range": "54:1 - 54:55"},
      {"Surah": "Ar-Rahman", "Range": "55:1 - 55:78"},
      {"Surah": "Al-Waqi'a", "Range": "56:1 - 56:96"},
      {"Surah": "Al-Hadid", "Range": "57:1 - 57:29"}
    ],
    "Para 28": [
      {"Surah": "Al-Mujadila", "Range": "58:1 - 58:22"},
      {"Surah": "Al-Hashr", "Range": "59:1 - 59:24"},
      {"Surah": "Al-Mumtahina", "Range": "60:1 - 60:13"},
      {"Surah": "As-Saff", "Range": "61:1 - 61:14"},
      {"Surah": "Al-Jumu'a", "Range": "62:1 - 62:11"},
      {"Surah": "Al-Munafiqun", "Range": "63:1 - 63:11"},
      {"Surah": "At-Taghabun", "Range": "64:1 - 64:18"},
      {"Surah": "At-Talaq", "Range": "65:1 - 65:12"},
      {"Surah": "At-Tahrim", "Range": "66:1 - 66:12"}
    ],
    "Para 29": [
      {"Surah": "Al-Mulk", "Range": "67:1 - 67:30"},
      {"Surah": "Al-Qalam", "Range": "68:1 - 68:52"},
      {"Surah": "Al-Haqqah", "Range": "69:1 - 69:52"},
      {"Surah": "Al-Ma'arij", "Range": "70:1 - 70:44"},
      {"Surah": "Nuh", "Range": "71:1 - 71:28"},
      {"Surah": "Al-Jinn", "Range": "72:1 - 72:28"},
      {"Surah": "Al-Muzzammil", "Range": "73:1 - 73:20"},
      {"Surah": "Al-Muddathir", "Range": "74:1 - 74:56"},
      {"Surah": "Al-Qiyama", "Range": "75:1 - 75:40"},
      {"Surah": "Al-Insan", "Range": "76:1 - 76:31"},
      {"Surah": "Al-Mursalat", "Range": "77:1 - 77:50"}
    ],
    "Para 30": [
      {"Surah": "An-Naba", "Range": "78:1 - 78:40"},
      {"Surah": "An-Nazi'at", "Range": "79:1 - 79:46"},
      {"Surah": "Abasa", "Range": "80:1 - 80:42"},
      {"Surah": "At-Takwir", "Range": "81:1 - 81:29"},
      {"Surah": "Al-Infitar", "Range": "82:1 - 82:19"},
      {"Surah": "Al-Mutaffifin", "Range": "83:1 - 83:36"},
      {"Surah": "Al-Inshiqaq", "Range": "84:1 - 84:25"},
      {"Surah": "Al-Buruj", "Range": "85:1 - 85:22"},
      {"Surah": "At-Tariq", "Range": "86:1 - 86:17"},
      {"Surah": "Al-A'la", "Range": "87:1 - 87:19"},
      {"Surah": "Al-Ghashiyah", "Range": "88:1 - 88:26"},
      {"Surah": "Al-Fajr", "Range": "89:1 - 89:30"},
      {"Surah": "Al-Balad", "Range": "90:1 - 90:20"},
      {"Surah": "Ash-Shams", "Range": "91:1 - 91:15"},
      {"Surah": "Al-Layl", "Range": "92:1 - 92:21"},
      {"Surah": "Ad-Duha", "Range": "93:1 - 93:11"},
      {"Surah": "Ash-Sharh", "Range": "94:1 - 94:8"},
      {"Surah": "At-Tin", "Range": "95:1 - 95:8"},
      {"Surah": "Al-Alaq", "Range": "96:1 - 96:19"},
      {"Surah": "Al-Qadr", "Range": "97:1 - 97:5"},
      {"Surah": "Al-Bayyina", "Range": "98:1 - 98:8"},
      {"Surah": "Az-Zalzalah", "Range": "99:1 - 99:8"},
      {"Surah": "Al-Adiyat", "Range": "100:1 - 100:11"},
      {"Surah": "Al-Qari'a", "Range": "101:1 - 101:11"},
      {"Surah": "At-Takathur", "Range": "102:1 - 102:8"},
      {"Surah": "Al-Asr", "Range": "103:1 - 103:3"},
      {"Surah": "Al-Humazah", "Range": "104:1 - 104:9"},
      {"Surah": "Al-Fil", "Range": "105:1 - 105:5"},
      {"Surah": "Quraish", "Range": "106:1 - 106:4"},
      {"Surah": "Al-Ma'un", "Range": "107:1 - 107:7"},
      {"Surah": "Al-Kawthar", "Range": "108:1 - 108:3"},
      {"Surah": "Al-Kafirun", "Range": "109:1 - 109:6"},
      {"Surah": "An-Nasr", "Range": "110:1 - 110:3"},
      {"Surah": "Al-Masad", "Range": "111:1 - 111:5"},
      {"Surah": "Al-Ikhlas", "Range": "112:1 - 112:4"},
      {"Surah": "Al-Falaq", "Range": "113:1 - 113:5"},
      {"Surah": "An-Nas", "Range": "114:1 - 114:6"}
    ]
  };

  List<String> paras = [
    "Para 1",
    "Para 2",
    "Para 3",
    "Para 4",
    "Para 5",
    "Para 6",
    "Para 7",
    "Para 8",
    "Para 9",
    "Para 10",
    "Para 11",
    "Para 12",
    "Para 13",
    "Para 14",
    "Para 15",
    "Para 16",
    "Para 17",
    "Para 18",
    "Para 19",
    "Para 20",
    "Para 21",
    "Para 22",
    "Para 23",
    "Para 24",
    "Para 25",
    "Para 26",
    "Para 27",
    "Para 28",
    "Para 29",
    "Para 30"
  ];
  List<String> availableSurahs = [];
  List<int> ayahs = List<int>.generate(286, (index) => index + 1);

  String? selectedPara;
  String? selectedSurah;
  int? selectedAyah;

  // Get range of ayahs for selected surah
  List<int> getAyahRange(String para, String surah) {
    final surahData = paraData[para]?.firstWhere(
      (s) => s["Surah"] == surah,
      orElse: () => {"Range": "1:1 - 1:7"},
    );

    final range = surahData?["Range"]?.split(" - ");
    if (range != null && range.length == 2) {
      final start = int.parse(range[0].split(":")[1]);
      final end = int.parse(range[1].split(":")[1]);
      return List<int>.generate(end - start + 1, (index) => index + start);
    }
    return [];
  }

  void _addGoalReference() {
    if (selectedPara != null && selectedSurah != null) {
      if (selectedAyah == -1) {
        // "All Ayah" is selected, so add all Ayahs for the selected Surah
        List<Map<String, String>> surahData = paraData[selectedPara] ?? [];

        // Find the Surah map matching the selectedSurah
        Map<String, String>? surahInfo = surahData.firstWhere(
              (surah) => surah['Surah'] == selectedSurah,
          orElse: () => {}, // Return an empty map if no matching Surah is found
        );

        if (surahInfo.isNotEmpty) {
          // Extract the Range for the selected Surah (if it exists)
          String range = surahInfo['Range'] ?? "";
          List<int> allAyahs = _parseRange(range);

          for (int ayah in allAyahs) {
            bool isDuplicate = goalReferences.any((goal) =>
            goal['para'] == selectedPara &&
                goal['surah'] == selectedSurah &&
                goal['ayah'] == ayah);

            if (!isDuplicate) {
              setState(() {
                goalReferences.add({
                  'para': selectedPara,
                  'surah': selectedSurah,
                  'ayah': ayah,
                });
              });
            }
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('All Ayahs for the selected Surah added.')),
          );
        }
      } else {
        // Single Ayah is selected, so add the specific Ayah
        bool isDuplicate = goalReferences.any((goal) =>
        goal['para'] == selectedPara &&
            goal['surah'] == selectedSurah &&
            goal['ayah'] == selectedAyah);

        if (isDuplicate) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('This Reference has been already added')),
          );
        } else {
          setState(() {
            goalReferences.add({
              'para': selectedPara,
              'surah': selectedSurah,
              'ayah': selectedAyah,
            });
          });
        }
      }
    } else {
      // Show an alert if selections are incomplete
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please select all fields (Para, Surah, Ayah).'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

// Helper function to parse the Ayah range string like "1:1 - 1:7"
  List<int> _parseRange(String range) {
    List<int> ayahList = [];

    // Split the range into start and end (e.g., "1:1 - 1:7")
    RegExp regExp = RegExp(r'(\d+):(\d+) - (\d+):(\d+)');
    Match? match = regExp.firstMatch(range);

    if (match != null) {
      int startSurah = int.parse(match.group(1)!);
      int startAyah = int.parse(match.group(2)!);
      int endSurah = int.parse(match.group(3)!);
      int endAyah = int.parse(match.group(4)!);

      // Generate a list of all Ayahs within the range
      for (int ayah = startAyah; ayah <= endAyah; ayah++) {
        ayahList.add(ayah);
      }
    }

    return ayahList;
  }



  void _showGoalReferencesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Goal References'),
          content: goalReferences.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: goalReferences.map((goal) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Display para, surah, and ayah in a Column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Para: ${goal['para']}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Surah: ${goal['surah']}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Ayah: ${goal['ayah']}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            // Delete icon button to remove the goal reference
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  goalReferences.remove(
                                      goal); // Remove the goal reference
                                });
                                Navigator.of(context).pop(); // Close the dialog
                                _showGoalReferencesDialog(
                                    context); // Reopen the dialog to reflect the change
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                )
              : const Text('No goal references available.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _saveGoal(String email) async {
    if (goalReferences.isNotEmpty) {
      // Show dialog to ask for daily time
      int? dailyTimeInMinutes = await _askForDailyTime();
      if (dailyTimeInMinutes == null) return; // If user cancels, do nothing

      const String url = '${AppConfig.baseUrl}/save-goals';
      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'quranReferences': goalReferences,
            'email': email,
            'dailyTime': dailyTimeInMinutes,
          }),
        );
        final responseData = jsonDecode(response.body);
        final message = responseData['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );

      } catch (e) {
        print('Error sending data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save goals. Please try again.')),
        );

      }
    } else {
      // Show alert if no goal references are added
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please add at least one Quran reference.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

// Function to show a dialog asking for daily time
  Future<int?> _askForDailyTime() async {
    final TextEditingController _timeController = TextEditingController();
    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Daily Time Commitment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter the daily time you can dedicate (minimum 10 minutes):'),
            const SizedBox(height: 12),
            TextField(
              controller: _timeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Time in minutes',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss dialog without saving
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final input = _timeController.text.trim();
              if (input.isNotEmpty) {
                final dailyTime = int.tryParse(input);
                if (dailyTime != null && dailyTime >= 10) {
                  Navigator.of(context).pop(dailyTime); // Return daily time
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter at least 10 minutes.'),
                    ),
                  );
                }
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    String email = Provider.of<UserProvider>(context).email;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Goal'),
        backgroundColor: const Color(0xFF13A795),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 42.0),
            // Para Dropdown
            Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Aligns dropdowns at the top
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Spreads widgets evenly
              children: [
                // Para Dropdown
                Expanded(
                  flex: 1, // Controls proportional space for each dropdown
                  child: DropdownSearch<String>(
                    items: paras,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: 'Para',
                        labelStyle: const TextStyle(
                          color: Color(0xFF13A795),
                          fontWeight: FontWeight.bold,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF13A795), width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF13A795), width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    popupProps: const PopupProps.menu(
                      fit: FlexFit.loose, // Adjust the dropdown menu height dynamically.
                      showSearchBox: true, // Optional: Add a search box for large lists.
                      constraints: BoxConstraints(
                        maxHeight: 300, // Set a maximum height for the dropdown.
                      ),
                    ),
                    selectedItem: selectedPara,
                    onChanged: (value) {
                      setState(() {
                        selectedPara = value;
                        selectedSurah = null;
                        selectedAyah = null;
                        if (value != null) {
                          availableSurahs = paraData[value]?.map((e) => e["Surah"] ?? "").toList() ?? [];
                        } else {
                          availableSurahs = [];
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12), // Spacing between dropdowns

                // Surah Dropdown
                Expanded(
                  flex: 1,
                  child: DropdownSearch<String>(
                    items: availableSurahs,
                    enabled: selectedPara != null,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: 'Surah',
                        labelStyle: const TextStyle(
                          color: Color(0xFF13A795),
                          fontWeight: FontWeight.bold,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF13A795), width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF13A795), width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    popupProps: const PopupProps.menu(
                      fit: FlexFit.loose, // Adjust the dropdown menu height dynamically.
                      showSearchBox: true, // Optional: Add a search box for large lists.
                      constraints: BoxConstraints(
                        maxHeight: 300, // Set a maximum height for the dropdown.
                      ),
                    ),
                    selectedItem: selectedSurah,
                    onChanged: (value) {
                      setState(() {
                        selectedSurah = value;
                        selectedAyah = null;
                        if (selectedPara != null && value != null) {
                          ayahs = getAyahRange(selectedPara!, value);
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12), // Spacing between dropdowns

                // Ayah Dropdown
                Expanded(
                  flex: 1,
                  child: DropdownSearch<String>(
                    items: ['All Ayah', ...ayahs.map((ayah) => ayah.toString()).toList()],
                    enabled: selectedSurah != null,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: 'Ayah',
                        labelStyle: const TextStyle(
                          color: Color(0xFF13A795),
                          fontWeight: FontWeight.bold,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF13A795), width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF13A795), width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    popupProps: const PopupProps.menu(
                      fit: FlexFit.loose, // Adjust the dropdown menu height dynamically.
                      showSearchBox: true, // Optional: Add a search box for large lists.
                      constraints: BoxConstraints(
                        maxHeight: 300, // Set a maximum height for the dropdown.
                      ),
                    ),
                    selectedItem: selectedAyah == -1 ? 'All Ayah' : selectedAyah?.toString(),
                    onChanged: (String? value) {
                      setState(() {
                        if (value == 'All Ayah') {
                          selectedAyah = -1; // Set selectedAyah to -1 for "All Ayah"
                        } else {
                          selectedAyah = int.tryParse(value ?? '') ?? -1; // Parse the selected ayah value, or set to -1 if parsing fails
                        }
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 42.0),
            Center(
              child: Column(
                children: [
                  // "Add Goal in List" Button
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: ElevatedButton(
                      onPressed: () {
                        _addGoalReference(); // Add the goal reference first
                        _showGoalReferencesDialog(
                            context); // Show the dialog after adding
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF13A795),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Add Goal in List',
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                      height: 20.0), // Add some spacing between the buttons

                  // "Save Goals" Button
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: ElevatedButton(
                      onPressed: () {
                        _saveGoal(email); // Function to save goals
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFF13A795), // A different color for distinction
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Save Goals',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
