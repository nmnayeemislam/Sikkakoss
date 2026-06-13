import 'package:flutter/material.dart';

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
                    FilledButton.icon(
                      onPressed: () => AudioService.playSurah(
                        context,
                        widget.surah.name,
                        widget.surah.audioAsset,
                      ),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Play Audio'),
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
