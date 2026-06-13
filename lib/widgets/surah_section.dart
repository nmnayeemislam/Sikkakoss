import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../models/surah.dart';

class SurahSection extends StatelessWidget {
  const SurahSection({
    super.key,
    required this.surahs,
    required this.completedLessons,
    required this.onOpenSurah,
    required this.onOpenAll,
  });

  final List<Surah> surahs;
  final Set<String> completedLessons;
  final ValueChanged<int> onOpenSurah;
  final VoidCallback onOpenAll;

  @override
  Widget build(BuildContext context) {
    final completedCount = surahs
        .where((surah) => completedLessons.contains(surah.id))
        .length;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.berry, AppColors.sky, AppColors.mint],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.berry.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Small Surah',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$completedCount/${surahs.length} completed · Arabic, Bangla meaning, audio',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
          const SizedBox(height: 16),
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: surahs.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final surah = surahs[index];
                final completed = completedLessons.contains(surah.id);
                return _SurahQuickTile(
                  surah: surah,
                  completed: completed,
                  onTap: () => onOpenSurah(index),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onOpenAll,
            icon: const Icon(Icons.auto_stories_rounded),
            label: const Text('Open Surah Section'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _SurahQuickTile extends StatelessWidget {
  const _SurahQuickTile({
    required this.surah,
    required this.completed,
    required this.onTap,
  });

  final Surah surah;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.94),
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 168,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      completed
                          ? Icons.check_circle_rounded
                          : Icons.play_circle_fill_rounded,
                      color: completed ? AppColors.leaf : AppColors.berry,
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.volume_up_rounded,
                      color: AppColors.sky,
                      size: 20,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      surah.banglaName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.ink.withValues(alpha: 0.72),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
