import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AudioService {
  const AudioService._();

  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playPronunciation(
    BuildContext context,
    String pronunciation,
    String? audioAsset,
  ) async {
    if (audioAsset != null) {
      try {
        await rootBundle.load('assets/$audioAsset');
        await _player.stop();
        await _player.play(AssetSource(audioAsset));
      } on FlutterError {
        await SystemSound.play(SystemSoundType.alert);
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('Audio file not found for $pronunciation.'),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        return;
      }
    } else {
      await SystemSound.play(SystemSoundType.click);
    }

    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            audioAsset == null
                ? 'Pronunciation: $pronunciation'
                : 'Playing $pronunciation',
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  static Future<void> playSurah(
    BuildContext context,
    String surahName,
    String audioAsset,
  ) async {
    try {
      await rootBundle.load('assets/$audioAsset');
      await _player.stop();
      await _player.play(AssetSource(audioAsset));
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Playing $surahName'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
    } on FlutterError {
      await SystemSound.play(SystemSoundType.alert);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Audio file not found for $surahName.'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
    }
  }

  static Future<void> stopSurah() async {
    await _player.stop();
  }
}
