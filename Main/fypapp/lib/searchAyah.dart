import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;

import 'config.dart';

class SearchAyahPage extends StatefulWidget {
  const SearchAyahPage({super.key});

  @override
  SearchAyahPageState createState() => SearchAyahPageState();
}

class SearchAyahPageState extends State<SearchAyahPage> {
  // Para-Surah mapping data
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
  String? fetchedAyahText; // To store the fetched Ayah text
  bool isLoading = false;
  bool isAyahVisible = false;

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

  Future<void> sendSelection(String para, String surah, int ayah) async {
    const String url = '${AppConfig.baseUrl}/searchayah';

    // Create the payload
    final Map<String, dynamic> data = {
      'para': para,
      'surah': surah,
      'ayah': ayah,
    };

    try {
      setState(() {
        isLoading = true; // Set loading to true while fetching
      });

      // Send a POST request with the JSON payload
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Update the UI with the fetched Ayah
        setState(() {
          fetchedAyahText = responseData['ayahText']; // Adjust based on API response
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ayah successfully fetched!'),
          ),
        );
      } else {
        setState(() {
          fetchedAyahText = "Error: Unable to fetch Ayah.";
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error fetching Ayah data!'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        fetchedAyahText = "Error occurred: $e";
        isLoading = false;
      });


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Ayah'),
        backgroundColor: const Color(0xFF13A795),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 42.0),

            // Dropdowns for Para, Surah, and Ayah
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
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
                const SizedBox(width: 12),

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
                const SizedBox(width: 12),

                Expanded(
                  flex: 1,
                  child: DropdownSearch<String>(
                    items: ayahs.map((ayah) => ayah.toString()).toList(),
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
                    selectedItem: selectedAyah?.toString(),
                    onChanged: (value) {
                      setState(() {
                        selectedAyah = value != null ? int.tryParse(value) : null;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 62.0),

            // Search Button
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 200),
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedPara != null && selectedSurah != null && selectedAyah != null) {
                      setState(() {
                        isLoading = true; // Set loading state
                      });

                      await sendSelection(selectedPara!, selectedSurah!, selectedAyah!);

                      setState(() {
                        isLoading = false; // Reset loading state
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select Para, Surah, and Ayah'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF13A795),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    ),
                  )
                      : const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Search Ayah'),
                  ),
                ),
              ),
            ),

            // Display Fetched Ayah Text
            if (fetchedAyahText != null && !isLoading)
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF13A795), width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Text(
                  fetchedAyahText!,
                  style: const TextStyle(
                    fontSize: 23,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

}
