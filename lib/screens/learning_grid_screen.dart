import 'dart:async';

import 'package:flutter/material.dart';

import '../data/audio_assets.dart';
import '../models/category.dart';
import '../models/learning_item.dart';
import '../services/audio_service.dart';
import '../services/progress_service.dart';
import '../widgets/app_background.dart';
import '../widgets/kids_controls.dart';
import '../widgets/learning_card.dart';
import 'learning_detail_screen.dart';

class LearningGridScreen extends StatefulWidget {
  const LearningGridScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.categoryType,
    this.isArabic = false,
  });

  final String title;
  final String subtitle;
  final List<LearningItem> items;
  final LearningCategoryType categoryType;
  final bool isArabic;

  @override
  State<LearningGridScreen> createState() => _LearningGridScreenState();
}

class _LearningGridScreenState extends State<LearningGridScreen> {
  late Set<String> _completedLessons;
  int _focusedIndex = 0;

  @override
  void initState() {
    super.initState();
    _completedLessons = ProgressService.getCompletedLessons();
    _focusedIndex = _initialFocusedIndex();
  }

  int _initialFocusedIndex() {
    if (widget.categoryType == LearningCategoryType.numbers) {
      final index = widget.items.indexWhere((item) => item.title == '15');
      if (index != -1) {
        return index;
      }
    }
    return 0;
  }

  Future<void> _openItem(LearningItem item) async {
    final audioAsset = AudioAssets.forLearningItem(item);
    if (audioAsset != null) {
      unawaited(AudioService.instance.playAudio(audioAsset));
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LearningDetailScreen(
          item: item,
          sectionTitle: widget.title,
          sectionColor: _appBarColor(),
          isArabic: widget.isArabic,
        ),
      ),
    );
    setState(() {
      _completedLessons = ProgressService.getCompletedLessons();
    });
  }

  Color _appBarColor() {
    switch (widget.categoryType) {
      case LearningCategoryType.banglaVowels:
      case LearningCategoryType.banglaConsonants:
        return const Color(0xFF40B65A);
      case LearningCategoryType.english:
        return const Color(0xFFE87FB7);
      case LearningCategoryType.numbers:
        return const Color(0xFF4D8CF5);
      case LearningCategoryType.arabic:
        return const Color(0xFF8B70E8);
      case LearningCategoryType.surah:
      case LearningCategoryType.quiz:
        return const Color(0xFF0F9CA9);
    }
  }

  int _gridColumns(double width) {
    switch (widget.categoryType) {
      case LearningCategoryType.banglaVowels:
        return width >= 700 ? 4 : 3;
      case LearningCategoryType.banglaConsonants:
        return width >= 700 ? 4 : 3;
      case LearningCategoryType.arabic:
        return width >= 700 ? 5 : 4;
      case LearningCategoryType.numbers:
        return width >= 700 ? 5 : 4;
      case LearningCategoryType.english:
      case LearningCategoryType.surah:
      case LearningCategoryType.quiz:
        return 2;
    }
  }

  Widget _buildShowcase(BuildContext context, String label, LearningItem item) {
    final audioAsset = AudioAssets.forLearningItem(item);
    return ValueListenableBuilder<String?>(
      valueListenable: AudioService.instance.currentAsset,
      builder: (context, currentAudioAsset, _) {
        final isPlaying =
            currentAudioAsset == audioAsset &&
            AudioService.instance.isPlayingAsset(audioAsset);
        return AnimatedScale(
          duration: const Duration(milliseconds: 180),
          scale: isPlaying ? 1.01 : 1.0,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(
                color: isPlaying
                    ? _appBarColor()
                    : Colors.black.withValues(alpha: 0.05),
                width: isPlaying ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _appBarColor(),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                _LearningShowcaseArt(
                  item: item,
                  color: _appBarColor(),
                  isArabic: widget.isArabic,
                ),
                const SizedBox(height: 10),
                KidsActionPill(
                  label: isPlaying ? 'Playing' : 'Listen',
                  icon: isPlaying
                      ? Icons.graphic_eq_rounded
                      : Icons.volume_up_rounded,
                  onPressed: audioAsset == null
                      ? () => _openItem(item)
                      : () => AudioService.instance.playAudio(audioAsset),
                  backgroundColor: _appBarColor(),
                  foregroundColor: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlphabetChips(BuildContext context) {
    final previewItems = widget.items.take(5).toList(growable: false);
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        for (final item in previewItems)
          InkWell(
            onTap: () {
              setState(() {
                _focusedIndex = widget.items.indexOf(item);
              });
              _openItem(item);
            },
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                item.title,
                style: TextStyle(
                  color: _appBarColor(),
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTopLesson(BuildContext context) {
    final item = widget.items[_focusedIndex];
    if (widget.categoryType == LearningCategoryType.english) {
      return _buildShowcase(context, widget.title, item);
    }
    if (widget.categoryType == LearningCategoryType.numbers) {
      return _buildShowcase(context, widget.title, item);
    }
    return const SizedBox.shrink();
  }

  bool get _isBanglaScript =>
      widget.categoryType == LearningCategoryType.banglaVowels ||
      widget.categoryType == LearningCategoryType.banglaConsonants;

  @override
  Widget build(BuildContext context) {
    if (_isBanglaScript) {
      return _buildBanglaScriptPage(context);
    }

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columns = _gridColumns(constraints.maxWidth);
              return ValueListenableBuilder<String?>(
                valueListenable: AudioService.instance.currentAsset,
                builder: (context, currentAudioAsset, _) {
                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        backgroundColor: _appBarColor(),
                        surfaceTintColor: Colors.transparent,
                        elevation: 0,
                        title: Text(widget.title),
                        centerTitle: true,
                        foregroundColor: Colors.white,
                        leading: IconButton(
                          tooltip: 'Back',
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                        actions: [
                          if (widget.categoryType ==
                                  LearningCategoryType.banglaVowels ||
                              widget.categoryType ==
                                  LearningCategoryType.arabic)
                            IconButton(
                              tooltip: 'Sound',
                              onPressed: () {
                                final item = widget.items[_focusedIndex];
                                final audioAsset = AudioAssets.forLearningItem(
                                  item,
                                );
                                if (audioAsset != null) {
                                  unawaited(
                                    AudioService.instance.playAudio(audioAsset),
                                  );
                                }
                              },
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
                      if (widget.categoryType == LearningCategoryType.english ||
                          widget.categoryType == LearningCategoryType.numbers)
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                          sliver: SliverToBoxAdapter(
                            child: _buildTopLesson(context),
                          ),
                        ),
                      if (widget.categoryType == LearningCategoryType.english)
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                          sliver: SliverToBoxAdapter(
                            child: _buildAlphabetChips(context),
                          ),
                        ),
                      if (widget.categoryType == LearningCategoryType.numbers)
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                          sliver: SliverToBoxAdapter(
                            child: _NumberRangeGrid(
                              items: widget.items.sublist(
                                10,
                                widget.items.length >= 25
                                    ? 25
                                    : widget.items.length,
                              ),
                              onTapItem: (item) {
                                setState(() {
                                  _focusedIndex = widget.items.indexOf(item);
                                });
                                _openItem(item);
                              },
                            ),
                          ),
                        ),
                      if (widget.categoryType ==
                              LearningCategoryType.banglaVowels ||
                          widget.categoryType ==
                              LearningCategoryType.banglaConsonants ||
                          widget.categoryType == LearningCategoryType.arabic)
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                          sliver: SliverGrid.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columns,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 0.88,
                                ),
                            itemCount: widget.items.length,
                            itemBuilder: (context, index) {
                              final item = widget.items[index];
                              final audioAsset = AudioAssets.forLearningItem(
                                item,
                              );
                              return LearningCard(
                                item: item,
                                isCompleted: _completedLessons.contains(
                                  item.id,
                                ),
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
                      if (widget.categoryType ==
                              LearningCategoryType.banglaVowels ||
                          widget.categoryType ==
                              LearningCategoryType.banglaConsonants ||
                          widget.categoryType == LearningCategoryType.arabic ||
                          widget.categoryType == LearningCategoryType.numbers)
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                          sliver: SliverToBoxAdapter(
                            child: KidsRoundNavRow(
                              onLeft: () => Navigator.of(context).maybePop(),
                              onHome: () => Navigator.of(
                                context,
                              ).popUntil((route) => route.isFirst),
                              onRight: widget.items.isEmpty
                                  ? null
                                  : () {
                                      final next =
                                          (_focusedIndex + 1) %
                                          widget.items.length;
                                      setState(() {
                                        _focusedIndex = next;
                                      });
                                      _openItem(widget.items[next]);
                                    },
                            ),
                          ),
                        ),
                      if (widget.categoryType == LearningCategoryType.english)
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                          sliver: SliverToBoxAdapter(
                            child: KidsRoundNavRow(
                              showHome: false,
                              onLeft: () => Navigator.of(context).maybePop(),
                              onRight: widget.items.isEmpty
                                  ? null
                                  : () {
                                      final next =
                                          (_focusedIndex + 1) %
                                          widget.items.length;
                                      setState(() {
                                        _focusedIndex = next;
                                      });
                                      _openItem(widget.items[next]);
                                    },
                            ),
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

  Widget _buildBanglaScriptPage(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6FD47D), Color(0xFFE9F7D8)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: -40,
              top: 120,
              child: _SoftGlow(
                color: Color(0xFFFFFFFF).withValues(alpha: 0.22),
                size: 180,
              ),
            ),
            Positioned(
              right: -20,
              top: 260,
              child: _SoftGlow(
                color: Color(0xFFFFF4B8).withValues(alpha: 0.18),
                size: 140,
              ),
            ),
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    toolbarHeight: 58,
                    backgroundColor: const Color(0xFF36B85D),
                    surfaceTintColor: Colors.transparent,
                    elevation: 0,
                    centerTitle: true,
                    leadingWidth: 54,
                    title: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    leading: IconButton(
                      tooltip: 'Back',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: Colors.white,
                    ),
                    actions: [
                      if (widget.categoryType ==
                              LearningCategoryType.banglaVowels ||
                          widget.categoryType ==
                              LearningCategoryType.banglaConsonants)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: IconButton(
                            tooltip: 'Sound',
                            onPressed: () {
                              final item = widget.items[_focusedIndex];
                              final audioAsset = AudioAssets.forLearningItem(
                                item,
                              );
                              if (audioAsset != null) {
                                unawaited(
                                  AudioService.instance.playAudio(audioAsset),
                                );
                              }
                            },
                            icon: const Icon(Icons.volume_up_rounded),
                            color: Colors.white,
                          ),
                        ),
                    ],
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(24),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                    sliver: SliverToBoxAdapter(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFF2FAD9,
                          ).withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.65),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.fromLTRB(12, 14, 12, 16),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final tileWidth = (constraints.maxWidth - 24) / 3;
                            return Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                for (final item in widget.items)
                                  SizedBox(
                                    width: tileWidth,
                                    child: _BanglaLetterTile(
                                      item: item,
                                      color: const Color(0xFF111111),
                                      onTap: () => _openItem(item),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(0, 6, 0, 20),
                    sliver: SliverToBoxAdapter(
                      child: KidsRoundNavRow(
                        onLeft: () => Navigator.of(context).maybePop(),
                        onHome: () => Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst),
                        onRight: widget.items.isEmpty
                            ? null
                            : () {
                                final next =
                                    (_focusedIndex + 1) % widget.items.length;
                                setState(() {
                                  _focusedIndex = next;
                                });
                                _openItem(widget.items[next]);
                              },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SoftGlow extends StatelessWidget {
  const _SoftGlow({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _BanglaLetterTile extends StatelessWidget {
  const _BanglaLetterTile({
    required this.item,
    required this.color,
    required this.onTap,
  });

  final LearningItem item;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 92,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.pronunciation,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LearningShowcaseArt extends StatelessWidget {
  const _LearningShowcaseArt({
    required this.item,
    required this.color,
    required this.isArabic,
  });

  final LearningItem item;
  final Color color;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final title = item.title;
    final isNumber = RegExp(r'^\d+$').hasMatch(title);
    final isSingleLetter = title.length == 1 && !isNumber;

    return Column(
      children: [
        Text(
          title,
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w900,
            fontSize: isNumber
                ? 86
                : isSingleLetter
                ? 84
                : 72,
            height: 1,
          ),
        ),
        const SizedBox(height: 10),
        if (item.imageEmoji != null)
          Text(item.imageEmoji!, style: const TextStyle(fontSize: 92))
        else
          const SizedBox(height: 80),
        const SizedBox(height: 10),
        Text(
          item.subtitle,
          style: const TextStyle(
            color: Color(0xFF24304F),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _NumberRangeGrid extends StatelessWidget {
  const _NumberRangeGrid({required this.items, required this.onTapItem});

  final List<LearningItem> items;
  final ValueChanged<LearningItem> onTapItem;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final item in items)
          GestureDetector(
            onTap: () => onTapItem(item),
            child: Container(
              width: 54,
              height: 54,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                item.title,
                style: const TextStyle(
                  color: Color(0xFF24304F),
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
