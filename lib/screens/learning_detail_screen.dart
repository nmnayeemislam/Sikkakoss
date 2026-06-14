import 'package:flutter/material.dart';

import '../data/audio_assets.dart';
import '../models/learning_item.dart';
import '../services/audio_service.dart';
import '../services/progress_service.dart';
import '../widgets/app_background.dart';
import '../widgets/kids_controls.dart';

class LearningDetailScreen extends StatefulWidget {
  const LearningDetailScreen({
    super.key,
    required this.item,
    required this.sectionTitle,
    required this.sectionColor,
    this.isArabic = false,
  });

  final LearningItem item;
  final String sectionTitle;
  final Color sectionColor;
  final bool isArabic;

  @override
  State<LearningDetailScreen> createState() => _LearningDetailScreenState();
}

class _LearningDetailScreenState extends State<LearningDetailScreen> {
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _completed = ProgressService.getCompletedLessons().contains(widget.item.id);
  }

  Future<void> _markComplete() async {
    await ProgressService.markLessonComplete(widget.item.id);
    setState(() {
      _completed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioAsset = AudioAssets.forLearningItem(widget.item);
    final title = widget.item.title;
    final isNumber = RegExp(r'^\d+$').hasMatch(title);
    final isSingleSymbol = title.length == 1 && !isNumber;
    final prompt = isNumber
        ? widget.item.subtitle
        : isSingleSymbol
        ? '$title for ${widget.item.subtitle}'
        : widget.item.subtitle;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: widget.sectionColor,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                foregroundColor: Colors.white,
                title: Text(widget.sectionTitle),
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
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: ValueListenableBuilder<String?>(
                            valueListenable: AudioService.instance.currentAsset,
                            builder: (context, currentAudioAsset, _) {
                              final isPlaying =
                                  currentAudioAsset == audioAsset &&
                                  AudioService.instance.isPlayingAsset(
                                    audioAsset,
                                  );
                              return Container(
                                width: double.infinity,
                                constraints: const BoxConstraints(
                                  maxWidth: 440,
                                ),
                                padding: const EdgeInsets.fromLTRB(
                                  22,
                                  24,
                                  22,
                                  20,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: [
                                    BoxShadow(
                                      color: widget.sectionColor.withValues(
                                        alpha: 0.12,
                                      ),
                                      blurRadius: 24,
                                      offset: const Offset(0, 14),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: isPlaying
                                        ? widget.sectionColor
                                        : Colors.black.withValues(alpha: 0.05),
                                    width: isPlaying ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      title,
                                      textDirection: widget.isArabic
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                      style: TextStyle(
                                        fontSize: isNumber ? 88 : 76,
                                        color: widget.sectionColor,
                                        fontWeight: FontWeight.w900,
                                        height: 1,
                                        fontFamily: widget.isArabic
                                            ? 'serif'
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    if (widget.item.imageEmoji != null)
                                      Text(
                                        widget.item.imageEmoji!,
                                        style: const TextStyle(fontSize: 110),
                                      ),
                                    const SizedBox(height: 12),
                                    Text(
                                      prompt,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            color: const Color(0xFF24304F),
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    const SizedBox(height: 18),
                                    KidsActionPill(
                                      label: isPlaying
                                          ? 'Playing'
                                          : 'Pronounce',
                                      icon: isPlaying
                                          ? Icons.graphic_eq_rounded
                                          : Icons.volume_up_rounded,
                                      onPressed: audioAsset == null
                                          ? () {}
                                          : () => AudioService.instance
                                                .playAudio(audioAsset),
                                      backgroundColor: widget.sectionColor,
                                      foregroundColor: Colors.white,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
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
                      const SizedBox(height: 18),
                      KidsRoundNavRow(
                        showHome: false,
                        onLeft: () => Navigator.of(context).maybePop(),
                        onRight: () => Navigator.of(context).maybePop(),
                        leftColor: const Color(0xFF8E61E3),
                        rightColor: const Color(0xFF55C04E),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
