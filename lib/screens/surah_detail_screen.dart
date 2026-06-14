import 'package:flutter/material.dart';

import '../data/audio_assets.dart';
import '../models/surah.dart';
import '../services/audio_service.dart';
import '../services/progress_service.dart';
import '../widgets/app_background.dart';

class SurahDetailScreen extends StatefulWidget {
  const SurahDetailScreen({super.key, required this.surah});

  final Surah surah;

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  late bool _completed;

  @override
  void initState() {
    super.initState();
    _completed = ProgressService.getCompletedLessons().contains(
      widget.surah.id,
    );
  }

  Future<void> _markComplete() async {
    await ProgressService.markLessonComplete(widget.surah.id);
    setState(() {
      _completed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioAsset = AudioAssets.forSurah(widget.surah);
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(widget.surah.name),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(18),
                sliver: SliverList.list(
                  children: [
                    Text(
                      widget.surah.banglaName,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 14),
                    ValueListenableBuilder<String?>(
                      valueListenable: AudioService.instance.currentAsset,
                      builder: (context, currentAsset, _) {
                        final isCurrent =
                            currentAsset == audioAsset &&
                            AudioService.instance.isPlayingAsset(audioAsset);
                        return Column(
                          children: [
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                FilledButton.icon(
                                  onPressed: audioAsset == null
                                      ? null
                                      : () => AudioService.instance.playAudio(
                                          audioAsset,
                                        ),
                                  icon: Icon(
                                    isCurrent
                                        ? Icons.graphic_eq_rounded
                                        : Icons.play_arrow_rounded,
                                  ),
                                  label: Text(isCurrent ? 'Playing' : 'Play'),
                                ),
                                FilledButton.tonalIcon(
                                  onPressed: () =>
                                      AudioService.instance.pause(),
                                  icon: const Icon(Icons.pause_rounded),
                                  label: const Text('Pause'),
                                ),
                                FilledButton.tonalIcon(
                                  onPressed: () => AudioService.instance.stop(),
                                  icon: const Icon(Icons.stop_rounded),
                                  label: const Text('Stop'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _AudioProgressBar(audioAsset: audioAsset),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(widget.surah.arabicText.length, (index) {
                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                widget.surah.arabicText[index],
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(
                                  fontSize: 30,
                                  height: 1.8,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'serif',
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                widget.surah.banglaTranslation[index],
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    FilledButton.tonalIcon(
                      onPressed: _completed ? null : _markComplete,
                      icon: Icon(
                        _completed
                            ? Icons.check_circle_rounded
                            : Icons.task_alt_rounded,
                      ),
                      label: Text(_completed ? 'Completed' : 'Mark Complete'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AudioProgressBar extends StatelessWidget {
  const _AudioProgressBar({required this.audioAsset});

  final String? audioAsset;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Duration>(
      valueListenable: AudioService.instance.position,
      builder: (context, position, _) {
        return ValueListenableBuilder<Duration?>(
          valueListenable: AudioService.instance.duration,
          builder: (context, duration, _) {
            final totalMilliseconds =
                (duration ?? Duration.zero).inMilliseconds;
            final safeMax = totalMilliseconds <= 0
                ? 1.0
                : totalMilliseconds.toDouble();
            final value = position.inMilliseconds.clamp(0, safeMax).toDouble();
            final enabled = audioAsset != null && totalMilliseconds > 0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Slider(
                  value: value,
                  max: safeMax,
                  onChanged: enabled
                      ? (newValue) {
                          AudioService.instance.seek(
                            Duration(milliseconds: newValue.round()),
                          );
                        }
                      : null,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(position)),
                    Text(_formatDuration(duration ?? Duration.zero)),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
