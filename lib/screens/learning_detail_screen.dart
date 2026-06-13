import 'package:flutter/material.dart';

import '../models/learning_item.dart';
import '../services/audio_service.dart';
import '../services/progress_service.dart';
import '../widgets/app_background.dart';

class LearningDetailScreen extends StatefulWidget {
  const LearningDetailScreen({
    super.key,
    required this.item,
    this.isArabic = false,
  });

  final LearningItem item;
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
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(widget.item.subtitle),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: widget.item.color,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: widget.item.color.withValues(alpha: 0.35),
                              blurRadius: 24,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              widget.item.imageEmoji ?? widget.item.title,
                              style: TextStyle(
                                fontSize: widget.item.imageEmoji == null
                                    ? 110
                                    : 88,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontFamily: widget.isArabic ? 'serif' : null,
                              ),
                              textDirection: widget.isArabic
                                  ? TextDirection.rtl
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              widget.item.title,
                              style: TextStyle(
                                fontSize: widget.isArabic ? 72 : 54,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontFamily: widget.isArabic ? 'serif' : null,
                              ),
                              textDirection: widget.isArabic
                                  ? TextDirection.rtl
                                  : null,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.item.details ?? widget.item.subtitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          FilledButton.icon(
                            onPressed: () => AudioService.playPronunciation(
                              context,
                              widget.item.pronunciation,
                              widget.item.audioAsset,
                            ),
                            icon: const Icon(Icons.volume_up_rounded),
                            label: const Text('Pronounce'),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: _completed ? null : _markComplete,
                            icon: Icon(
                              _completed
                                  ? Icons.check_circle_rounded
                                  : Icons.task_alt_rounded,
                            ),
                            label: Text(
                              _completed ? 'Completed' : 'Mark Complete',
                            ),
                          ),
                        ],
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
