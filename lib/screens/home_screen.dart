import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../data/app_data.dart';
import '../models/category.dart';
import '../models/progress_summary.dart';
import '../services/progress_service.dart';
import '../widgets/app_background.dart';
import '../widgets/category_card.dart';
import 'learning_grid_screen.dart';
import 'quiz_screen.dart';
import 'settings_screen.dart';
import 'surah_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onThemeChanged});

  final ValueChanged<bool> onThemeChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ProgressSummary _summary;

  @override
  void initState() {
    super.initState();
    _summary = ProgressService.getSummary();
  }

  void _refreshProgress() {
    setState(() {
      _summary = ProgressService.getSummary();
    });
  }

  Future<void> _openCategory(LearningCategory category) async {
    await ProgressService.setLastOpenedCategory(category.title);
    if (!mounted) {
      return;
    }

    Widget screen;
    switch (category.type) {
      case LearningCategoryType.banglaVowels:
        screen = LearningGridScreen(
          title: category.title,
          subtitle: category.subtitle,
          items: AppData.banglaVowels,
          categoryType: category.type,
        );
        break;
      case LearningCategoryType.banglaConsonants:
        screen = LearningGridScreen(
          title: category.title,
          subtitle: category.subtitle,
          items: AppData.banglaConsonants,
          categoryType: category.type,
        );
        break;
      case LearningCategoryType.english:
        screen = LearningGridScreen(
          title: category.title,
          subtitle: category.subtitle,
          items: AppData.englishAlphabet,
          categoryType: category.type,
        );
        break;
      case LearningCategoryType.numbers:
        screen = LearningGridScreen(
          title: category.title,
          subtitle: category.subtitle,
          items: AppData.numbers,
          categoryType: category.type,
        );
        break;
      case LearningCategoryType.arabic:
        screen = LearningGridScreen(
          title: category.title,
          subtitle: category.subtitle,
          items: AppData.arabicLetters,
          categoryType: category.type,
          isArabic: true,
        );
        break;
      case LearningCategoryType.surah:
        screen = const SurahListScreen();
        break;
      case LearningCategoryType.quiz:
        screen = const QuizScreen();
        break;
    }

    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => screen));
    _refreshProgress();
  }

  Future<void> _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SettingsScreen(onThemeChanged: widget.onThemeChanged),
      ),
    );
    _refreshProgress();
  }

  int get _completedCount => _summary.completedLessons.length;

  String get _heroMessage {
    if (_summary.lastOpenedCategory.isNotEmpty) {
      return 'Last opened: ${_summary.lastOpenedCategory}';
    }
    return 'Start with letters, numbers, and small surah practice.';
  }

  Widget _buildCategorySection({
    required List<LearningCategory> gridCategories,
    required LearningCategory quizCategory,
    required bool isDark,
    required int columns,
  }) {
    return Column(
      children: [
        _HeroPanel(
          message: _heroMessage,
          completedCount: _completedCount,
          totalStars: _summary.totalStars,
          bestQuizScore: _summary.bestQuizScore,
          onQuizTap: () => _openCategory(quizCategory),
        ),
        const SizedBox(height: 22),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(
              eyebrow: 'Explore',
              title: 'Choose a learning path',
              subtitle:
                  'Letters, numbers, Arabic, and surah in one place.',
            ),
            if (_summary.lastOpenedCategory.isNotEmpty) ...[
              const SizedBox(height: 12),
              _PillBadge(
                icon: Icons.history_rounded,
                label: _summary.lastOpenedCategory,
                backgroundColor: isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.white.withOpacity(0.9),
                foregroundColor: isDark ? Colors.white : AppColors.ink,
                iconColor: AppColors.sky,
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          itemCount: gridCategories.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.98,
          ),
          itemBuilder: (context, index) {
            final category = gridCategories[index];
            return CategoryCard(
              category: category,
              onTap: () => _openCategory(category),
            );
          },
        ),
        const SizedBox(height: 18),
        _QuizBanner(
          bestScore: _summary.bestQuizScore,
          onTap: () => _openCategory(quizCategory),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final gridCategories = AppData.categories
        .where((category) => category.type != LearningCategoryType.quiz)
        .toList(growable: false);
    final quizCategory = AppData.categories.firstWhere(
      (category) => category.type == LearningCategoryType.quiz,
    );

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 700 ? 3 : 2;
              final horizontalPadding = constraints.maxWidth >= 700
                  ? 24.0
                  : 16.0;
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    toolbarHeight: 72,
                    backgroundColor: isDark
                        ? const Color(0xFF152742)
                        : const Color(0xFFFFFCF4),
                    elevation: 0,
                    leading: IconButton(
                      tooltip: 'Settings',
                      onPressed: _openSettings,
                      icon: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.08)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(0.08)
                                : const Color(0xFFE6E2D8),
                          ),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color: isDark ? Colors.white : AppColors.ink,
                        ),
                      ),
                    ),
                    leadingWidth: 68,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Kids Learning',
                          style: TextStyle(
                            color: isDark ? Colors.white : AppColors.ink,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Fun lessons for little learners',
                          style: TextStyle(
                            color: isDark
                                ? Colors.white70
                                : AppColors.ink.withOpacity(0.62),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    centerTitle: false,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _PillBadge(
                          icon: Icons.star_rounded,
                          label: '${_summary.totalStars}',
                          backgroundColor: isDark
                              ? const Color(0xFF1D3557)
                              : Colors.white,
                          foregroundColor: isDark
                              ? Colors.white
                              : const Color(0xFF24304F),
                          iconColor: const Color(0xFFFFC857),
                        ),
                      ),
                    ],
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      20,
                      horizontalPadding,
                      28,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _buildCategorySection(
                        gridCategories: gridCategories,
                        quizCategory: quizCategory,
                        isDark: isDark,
                        columns: columns,
                      ),
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

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({
    required this.message,
    required this.completedCount,
    required this.totalStars,
    required this.bestQuizScore,
    required this.onQuizTap,
  });

  final String message;
  final int completedCount;
  final int totalStars;
  final int bestQuizScore;
  final VoidCallback onQuizTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F9CA9), Color(0xFF146C94), Color(0xFF243B6B)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F9CA9).withOpacity(0.28),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -36,
            right: -18,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.09),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -32,
            left: -16,
            child: Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: const Color(0xFFFFC857).withOpacity(0.18),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Make learning joyful',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Play, learn, and grow every day',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              height: 1.12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.16),
                        ),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 14,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _MetricChip(
                      icon: Icons.check_circle_rounded,
                      label: '$completedCount lessons done',
                    ),
                    _MetricChip(
                      icon: Icons.star_rounded,
                      label: '$totalStars stars',
                    ),
                    _MetricChip(
                      icon: Icons.workspace_premium_rounded,
                      label: 'Best quiz $bestQuizScore',
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: onQuizTap,
                  icon: const Icon(Icons.emoji_events_rounded),
                  label: const Text('Practice Quiz'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF173763),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
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

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFFFFD479)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: TextStyle(
            color: isDark ? const Color(0xFF8ED1FF) : const Color(0xFF0F9CA9),
            letterSpacing: 1.2,
            fontWeight: FontWeight.w900,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.ink,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(
            color: isDark
                ? Colors.white70
                : AppColors.ink.withOpacity(0.68),
            fontSize: 14,
            height: 1.35,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _PillBadge extends StatelessWidget {
  const _PillBadge({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: foregroundColor.withOpacity(0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 7),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: foregroundColor,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizBanner extends StatelessWidget {
  const _QuizBanner({required this.bestScore, required this.onTap});

  final int bestScore;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.white.withOpacity(0.82),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : const Color(0xFFE8E0D4),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.berry, AppColors.sky],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Challenge time',
                        style: TextStyle(
                          color: isDark ? Colors.white : AppColors.ink,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Open the quiz and beat your best score of $bestScore.',
                        style: TextStyle(
                          color: isDark
                              ? Colors.white70
                              : AppColors.ink.withOpacity(0.66),
                          fontSize: 13,
                          height: 1.35,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: isDark ? Colors.white : AppColors.ink,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
