class Surah {
  const Surah({
    required this.id,
    required this.name,
    required this.banglaName,
    required this.arabicText,
    required this.banglaTranslation,
    required this.audioAsset,
  });

  final String id;
  final String name;
  final String banglaName;
  final List<String> arabicText;
  final List<String> banglaTranslation;
  final String audioAsset;
}
