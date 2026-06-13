import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/category.dart';
import '../models/progress_summary.dart';
import '../services/progress_service.dart';
import '../utils/responsive.dart';
import '../widgets/app_background.dart';
import '../widgets/category_card.dart';
import '../widgets/progress_header.dart';
import '../widgets/section_title.dart';
import '../widgets/surah_section.dart';
import 'learning_grid_screen.dart';
import 'quiz_screen.dart';
import 'settings_screen.dart';
import 'surah_detail_screen.dart';
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
        );
      case LearningCategoryType.banglaConsonants:
        screen = LearningGridScreen(
          title: category.title,
          subtitle: category.subtitle,
          items: AppData.banglaConsonants,
        );
      case LearningCategoryType.english:
        screen = LearningGridScreen(
          title: category.title,
          subtitle: category.subtitle,
          items: AppData.englishAlphabet,
        );
      case LearningCategoryType.numbers:
        screen = LearningGridScreen(
          title: category.title,
          subtitle: category.subtitle,
          items: AppData.numbers,
        );
      case LearningCategoryType.arabic:
        screen = LearningGridScreen(
          title: category.title,
          subtitle: category.subtitle,
          items: AppData.arabicLetters,
          isArabic: true,
        );
      case LearningCategoryType.surah:
        screen = const SurahListScreen();
      case LearningCategoryType.quiz:
        screen = const QuizScreen();
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

  Future<void> _openSurahFromHome(int index) async {
    await ProgressService.setLastOpenedCategory('Small Surah');
    if (!mounted) {
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SurahDetailScreen(surah: AppData.surahs[index]),
      ),
    );
    _refreshProgress();
  }

  Future<void> _openSurahSection() async {
    await ProgressService.setLastOpenedCategory('Small Surah');
    if (!mounted) {
      return;
    }
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const SurahListScreen()));
    _refreshProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columns = Responsive.gridColumns(constraints.maxWidth);
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: const Text('Kids Learning App'),
                    actions: [
                      IconButton(
                        tooltip: 'Settings',
                        onPressed: _openSettings,
                        icon: const Icon(Icons.settings_rounded),
                      ),
                    ],
                  ),
                  SliverPadding(
                    padding: Responsive.pagePadding(constraints.maxWidth),
                    sliver: SliverList.list(
                      children: [
                        ProgressHeader(summary: _summary),
                        const SizedBox(height: 22),
                        SurahSection(
                          surahs: AppData.surahs,
                          completedLessons: _summary.completedLessons,
                          onOpenSurah: _openSurahFromHome,
                          onOpenAll: _openSurahSection,
                        ),
                        const SizedBox(height: 22),
                        const SectionTitle(
                          title: 'Choose a colorful lesson',
                          subtitle:
                              'Offline lessons for bright little learners',
                        ),
                        if (_summary.lastOpenedCategory.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Chip(
                            avatar: const Icon(Icons.history_rounded),
                            label: Text(
                              'Last opened: ${_summary.lastOpenedCategory}',
                            ),
                          ),
                        ],
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 1.05,
                      ),
                      itemCount: AppData.categories.length,
                      itemBuilder: (context, index) {
                        final category = AppData.categories[index];
                        return CategoryCard(
                          category: category,
                          onTap: () => _openCategory(category),
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
