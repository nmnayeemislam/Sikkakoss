import 'package:flutter/material.dart';

enum LearningCategoryType {
  banglaVowels,
  banglaConsonants,
  english,
  numbers,
  arabic,
  surah,
  quiz,
}

class LearningCategory {
  const LearningCategory({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final LearningCategoryType type;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}
