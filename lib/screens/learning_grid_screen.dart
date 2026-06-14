import 'dart:async';

import 'package:flutter/material.dart';

import '../data/audio_assets.dart';
import '../models/learning_item.dart';
import '../services/audio_service.dart';
import '../services/progress_service.dart';
import '../utils/responsive.dart';
import '../widgets/app_background.dart';
import '../widgets/learning_card.dart';
import '../widgets/section_title.dart';
import 'learning_detail_screen.dart';

class LearningGridScreen extends StatefulWidget {
  const LearningGridScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
    this.isArabic = false,
  });

  final String title;
  final String subtitle;
  final List<LearningItem> items;
  final bool isArabic;

  @override
  State<LearningGridScreen> createState() => _LearningGridScreenState();
}

class _LearningGridScreenState extends State<LearningGridScreen> {
  late Set<String> _completedLessons;

  @override
  void initState() {
    super.initState();
    _completedLessons = ProgressService.getCompletedLessons();
  }

  Future<void> _openItem(LearningItem item) async {
    final audioAsset = AudioAssets.forLearningItem(item);
    if (audioAsset != null) {
      unawaited(AudioService.instance.playAudio(audioAsset));
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            LearningDetailScreen(item: item, isArabic: widget.isArabic),
      ),
    );
    setState(() {
      _completedLessons = ProgressService.getCompletedLessons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ValueListenableBuilder<String?>(
                valueListenable: AudioService.instance.currentAsset,
                builder: (context, currentAudioAsset, _) {
                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        title: Text(widget.title),
                      ),
                      SliverPadding(
                        padding: Responsive.pagePadding(constraints.maxWidth),
                        sliver: SliverList.list(
                          children: [
                            SectionTitle(
                              title: widget.title,
                              subtitle: widget.subtitle,
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          Responsive.pagePadding(constraints.maxWidth).left,
                          0,
                          Responsive.pagePadding(constraints.maxWidth).right,
                          24,
                        ),
                        sliver: SliverGrid.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: Responsive.gridColumns(
                                  constraints.maxWidth,
                                ),
                                mainAxisSpacing: 14,
                                crossAxisSpacing: 14,
                                childAspectRatio: 1,
                              ),
                          itemCount: widget.items.length,
                          itemBuilder: (context, index) {
                            final item = widget.items[index];
                            final audioAsset = AudioAssets.forLearningItem(
                              item,
                            );
                            return LearningCard(
                              item: item,
                              isCompleted: _completedLessons.contains(item.id),
                              isPlaying:
                                  currentAudioAsset == audioAsset &&
                                  AudioService.instance.isPlayingAsset(
                                    audioAsset,
                                  ),
                              onTap: () => _openItem(item),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
