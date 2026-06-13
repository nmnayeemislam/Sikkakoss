import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../data/app_data.dart';
import '../services/progress_service.dart';
import '../utils/responsive.dart';
import '../widgets/app_background.dart';
import '../widgets/section_title.dart';
import 'surah_detail_screen.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  late Set<String> _completedLessons;

  @override
  void initState() {
    super.initState();
    _completedLessons = ProgressService.getCompletedLessons();
  }

  Future<void> _openSurah(int index) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SurahDetailScreen(surah: AppData.surahs[index]),
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
              return CustomScrollView(
                slivers: [
                  const SliverAppBar(
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Text('Small Surah'),
                  ),
                  SliverPadding(
                    padding: Responsive.pagePadding(constraints.maxWidth),
                    sliver: SliverList.list(
                      children: [
                        const SectionTitle(
                          title: 'Small Surah',
                          subtitle:
                              'Arabic text, Bangla meaning, and audio controls',
                        ),
                        const SizedBox(height: 16),
                        _SurahHero(
                          completedCount: AppData.surahs
                              .where(
                                (surah) => _completedLessons.contains(surah.id),
                              )
                              .length,
                          totalCount: AppData.surahs.length,
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
                    sliver: SliverList.separated(
                      itemCount: AppData.surahs.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final surah = AppData.surahs[index];
                        final completed = _completedLessons.contains(surah.id);
                        return _SurahListTile(
                          number: index + 1,
                          title: surah.name,
                          subtitle: surah.banglaName,
                          completed: completed,
                          onTap: () => _openSurah(index),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SurahHero extends StatelessWidget {
  const _SurahHero({required this.completedCount, required this.totalCount});

  final int completedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.berry, AppColors.sky],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.record_voice_over_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$completedCount/$totalCount Surah completed',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap any Surah to read Arabic, Bangla meaning, and play audio.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SurahListTile extends StatelessWidget {
  const _SurahListTile({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.completed,
    required this.onTap,
  });

  final int number;
  final String title;
  final String subtitle;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.94),
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: completed ? AppColors.leaf : AppColors.berry,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: completed
                      ? const Icon(Icons.check_rounded, color: Colors.white)
                      : Text(
                          '$number',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.play_circle_fill_rounded, color: AppColors.sky),
            ],
          ),
        ),
      ),
    );
  }
}
