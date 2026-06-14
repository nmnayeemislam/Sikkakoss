import 'package:flutter/material.dart';

import '../data/audio_assets.dart';
import '../models/surah.dart';
import '../services/audio_service.dart';
import '../services/progress_service.dart';
import '../widgets/app_background.dart';
import '../widgets/kids_controls.dart';

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
                backgroundColor: const Color(0xFF37B8C8),
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                foregroundColor: Colors.white,
                title: Text(widget.surah.banglaName),
                leading: IconButton(
                  tooltip: 'Back',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                actions: [
                  IconButton(
                    tooltip: 'Sound',
                    onPressed: audioAsset == null
                        ? null
                        : () => AudioService.instance.playAudio(audioAsset),
                    icon: const Icon(Icons.volume_up_rounded),
                  ),
                  const SizedBox(width: 6),
                ],
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                sliver: SliverList.list(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            widget.surah.name,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: const Color(0xFF24304F),
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap play to listen and follow the verse.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: const Color(0xFF6D7B95),
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<String?>(
                      valueListenable: AudioService.instance.currentAsset,
                      builder: (context, currentAsset, _) {
                        final isCurrent =
                            currentAsset == audioAsset &&
                            AudioService.instance.isPlayingAsset(audioAsset);
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                KidsActionPill(
                                  label: isCurrent ? 'Playing' : 'Play',
                                  icon: isCurrent
                                      ? Icons.graphic_eq_rounded
                                      : Icons.play_arrow_rounded,
                                  onPressed: audioAsset == null
                                      ? () {}
                                      : () => AudioService.instance.playAudio(
                                          audioAsset,
                                        ),
                                  backgroundColor: const Color(0xFF55C04E),
                                  foregroundColor: Colors.white,
                                ),
                                const SizedBox(width: 12),
                                KidsActionPill(
                                  label: 'Pause',
                                  icon: Icons.pause_rounded,
                                  onPressed: () =>
                                      AudioService.instance.pause(),
                                  backgroundColor: const Color(0xFF8E61E3),
                                  foregroundColor: Colors.white,
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _AudioProgressBar(audioAsset: audioAsset),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    ...List.generate(widget.surah.arabicText.length, (index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.86),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              widget.surah.arabicText[index],
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                fontSize: 28,
                                height: 1.8,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'serif',
                                color: Color(0xFF24304F),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.surah.banglaTranslation[index],
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.55,
                                color: Color(0xFF24304F),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        KidsActionPill(
                          label: _completed ? 'Completed' : 'Mark Complete',
                          icon: _completed
                              ? Icons.check_circle_rounded
                              : Icons.task_alt_rounded,
                          onPressed: _completed ? () {} : _markComplete,
                          backgroundColor: const Color(0xFF55C04E),
                          foregroundColor: Colors.white,
                        ),
                      ],
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

            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Slider(
                    value: value,
                    max: safeMax,
                    activeColor: const Color(0xFF37B8C8),
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
              ),
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
