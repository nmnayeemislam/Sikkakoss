import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../services/progress_service.dart';
import '../widgets/app_background.dart';
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
    final completedCount = AppData.surahs
        .where((surah) => _completedLessons.contains(surah.id))
        .length;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: const Color(0xFF65D0F0),
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                foregroundColor: Colors.white,
                title: const Text('Small Surah'),
                leading: IconButton(
                  tooltip: 'Back',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
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
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.68),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: const Color(0xFF43B556),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.menu_book_rounded,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$completedCount/${AppData.surahs.length} completed',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: const Color(0xFF24304F),
                                      ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Arabic text, Bangla meaning, and audio controls',
                                  style: TextStyle(
                                    color: Color(0xFF6D7B95),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
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
          ),
        ),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFF43B556),
            borderRadius: BorderRadius.circular(18),
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
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            color: Color(0xFF24304F),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF6D7B95),
          ),
        ),
        trailing: Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: Color(0xFF8E61E3),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.play_arrow_rounded, color: Colors.white),
        ),
      ),
    );
  }
}
