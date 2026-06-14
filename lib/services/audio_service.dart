import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../data/audio_assets.dart';

class AudioService extends WidgetsBindingObserver {
  AudioService._();

  static final AudioService instance = AudioService._();

  final AudioPlayer _player = AudioPlayer();
  final ValueNotifier<String?> currentAsset = ValueNotifier<String?>(null);
  final ValueNotifier<PlayerState> playerState = ValueNotifier<PlayerState>(
    PlayerState.stopped,
  );
  final ValueNotifier<Duration> position = ValueNotifier<Duration>(
    Duration.zero,
  );
  final ValueNotifier<Duration?> duration = ValueNotifier<Duration?>(null);

  StreamSubscription<PlayerState>? _stateSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) {
      return;
    }
    _initialized = true;
    await _player.setReleaseMode(ReleaseMode.stop);

    _stateSubscription = _player.onPlayerStateChanged.listen((state) {
      playerState.value = state;
      if (state == PlayerState.completed) {
        currentAsset.value = null;
      }
    });

    _positionSubscription = _player.onPositionChanged.listen((value) {
      position.value = value;
    });

    _durationSubscription = _player.onDurationChanged.listen((value) {
      duration.value = value;
    });
  }

  Future<bool> playAudio(String assetPath) async {
    final resolvedPath = await _resolvePath(assetPath);
    if (resolvedPath == null) {
      await SystemSound.play(SystemSoundType.alert);
      return false;
    }

    await stop();
    currentAsset.value = assetPath;

    try {
      await _player.play(AssetSource(resolvedPath));
      return true;
    } catch (error) {
      debugPrint('Failed to play $assetPath: $error');
      currentAsset.value = null;
      playerState.value = PlayerState.stopped;
      await SystemSound.play(SystemSoundType.alert);
      return false;
    }
  }

  Future<void> pause() async {
    if (playerState.value == PlayerState.playing) {
      await _player.pause();
    }
  }

  Future<void> resume() async {
    if (playerState.value == PlayerState.paused) {
      await _player.resume();
    }
  }

  Future<void> stop() async {
    await _player.stop();
    position.value = Duration.zero;
    currentAsset.value = null;
    playerState.value = PlayerState.stopped;
  }

  Future<void> seek(Duration seekTo) async {
    await _player.seek(seekTo);
  }

  bool isPlayingAsset(String? assetPath) {
    if (assetPath == null) {
      return false;
    }
    return currentAsset.value == assetPath &&
        playerState.value == PlayerState.playing;
  }

  Future<String?> _resolvePath(String logicalPath) async {
    final candidates = <String>[
      logicalPath,
      ...AudioAssets.legacyCandidates(logicalPath),
    ];

    for (final candidate in candidates) {
      try {
        await rootBundle.load('assets/$candidate');
        return candidate;
      } on FlutterError {
        continue;
      }
    }

    return null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        unawaited(pause());
        break;
      case AppLifecycleState.resumed:
      case AppLifecycleState.hidden:
        break;
      case AppLifecycleState.detached:
        unawaited(stop());
        break;
    }
  }

  Future<void> dispose() async {
    await _stateSubscription?.cancel();
    await _positionSubscription?.cancel();
    await _durationSubscription?.cancel();
    await _player.dispose();
    currentAsset.dispose();
    playerState.dispose();
    position.dispose();
    duration.dispose();
  }
}
