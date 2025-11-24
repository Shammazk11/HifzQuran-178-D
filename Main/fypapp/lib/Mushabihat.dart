class MushabihatAyah {
  final int suraNumber;
  final String suraName;
  final int ayahNumber;
  final String ayahText;

  MushabihatAyah({
    required this.suraNumber,
    required this.suraName,
    required this.ayahNumber,
    required this.ayahText,
  });

  factory MushabihatAyah.fromJson(Map<String, dynamic> json) {
    return MushabihatAyah(
      suraNumber: json['sura_number'],
      suraName: json['sura_name'],
      ayahNumber: json['ayah_number'],
      ayahText: json['ayah_text'],
    );
  }
}