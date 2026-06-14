import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
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
                    toolbarHeight: 64,
                    backgroundColor: const Color(0xFF0F9CA9),
                    surfaceTintColor: Colors.transparent,
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(22),
                      ),
                    ),
                    leading: IconButton(
                      tooltip: 'Menu',
                      onPressed: _openSettings,
                      icon: const Icon(Icons.menu_rounded),
                    ),
                    title: const Text(
                      'Kids Learning',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    centerTitle: true,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Color(0xFFFFC857),
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${_summary.totalStars}',
                                style: const TextStyle(
                                  color: Color(0xFF24304F),
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      18,
                      horizontalPadding,
                      10,
                    ),
                    sliver: SliverList.list(
                      children: [
                        GridView.builder(
                          itemCount: gridCategories.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.96,
                              ),
                          itemBuilder: (context, index) {
                            final category = gridCategories[index];
                            return CategoryCard(
                              category: category,
                              onTap: () => _openCategory(category),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: FilledButton.icon(
                            onPressed: () => _openCategory(quizCategory),
                            icon: const Icon(Icons.emoji_events_rounded),
                            label: const Text('Quiz'),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF8E61E3),
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
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
