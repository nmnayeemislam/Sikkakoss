import 'package:flutter/material.dart';

class LearningItem {
  const LearningItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.pronunciation,
    required this.color,
    this.imageEmoji,
    this.details,
    this.audioAsset,
  });

  final String id;
  final String title;
  final String subtitle;
  final String pronunciation;
  final Color color;
  final String? imageEmoji;
  final String? details;
  final String? audioAsset;
}
