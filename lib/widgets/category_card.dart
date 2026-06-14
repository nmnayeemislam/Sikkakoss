import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category, required this.onTap});

  final LearningCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (category.type == LearningCategoryType.banglaVowels) {
      return _BanglaVowelCard(onTap: onTap);
    }

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        _lighten(category.color, 0.08),
        category.color,
        _darken(category.color, 0.12),
      ],
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: category.color.withValues(alpha: 0.28),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(child: Center(child: _buildHeroArt(category))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroArt(LearningCategory category) {
    switch (category.type) {
      case LearningCategoryType.banglaVowels:
        return _StackedArt(
          symbol: 'অ',
          symbolSize: 44,
          icon: Icons.auto_stories_rounded,
        );
      case LearningCategoryType.banglaConsonants:
        return _StackedArt(
          symbol: 'ক',
          symbolSize: 44,
          icon: Icons.auto_stories_rounded,
        );
      case LearningCategoryType.english:
        return const _AlphabetArt();
      case LearningCategoryType.numbers:
        return const _NumberArt();
      case LearningCategoryType.arabic:
        return const _ArabicArt();
      case LearningCategoryType.surah:
        return const _SurahArt();
      case LearningCategoryType.quiz:
        return const _QuizArt();
    }
  }

  static Color _lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  static Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }
}

class _StackedArt extends StatelessWidget {
  const _StackedArt({
    required this.symbol,
    required this.symbolSize,
    required this.icon,
  });

  final String symbol;
  final double symbolSize;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          symbol,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: symbolSize,
            height: 1,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ],
    );
  }
}

class _AlphabetArt extends StatelessWidget {
  const _AlphabetArt();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: const [
        _LetterTile(letter: 'A', color: Color(0xFFFF7D7D), tilt: -0.14),
        SizedBox(width: 4),
        _LetterTile(letter: 'B', color: Color(0xFFFFD166), tilt: 0.05),
        SizedBox(width: 4),
        _LetterTile(letter: 'C', color: Color(0xFF8ED1FF), tilt: -0.06),
      ],
    );
  }
}

class _LetterTile extends StatelessWidget {
  const _LetterTile({
    required this.letter,
    required this.color,
    required this.tilt,
  });

  final String letter;
  final Color color;
  final double tilt;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: tilt,
      child: Container(
        width: 28,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
        ),
        child: Text(
          letter,
          style: TextStyle(
            color: color,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NumberArt extends StatelessWidget {
  const _NumberArt();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: const [
        _DigitTile(digit: '1', color: Color(0xFFFFD166), tilt: -0.06),
        SizedBox(width: 4),
        _DigitTile(digit: '2', color: Color(0xFFFF8B94), tilt: 0.03),
        SizedBox(width: 4),
        _DigitTile(digit: '3', color: Color(0xFF7ED957), tilt: -0.04),
      ],
    );
  }
}

class _DigitTile extends StatelessWidget {
  const _DigitTile({
    required this.digit,
    required this.color,
    required this.tilt,
  });

  final String digit;
  final Color color;
  final double tilt;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: tilt,
      child: Container(
        width: 28,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
        ),
        child: Text(
          digit,
          style: TextStyle(
            color: color,
            fontSize: 21,
            fontWeight: FontWeight.w900,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArabicArt extends StatelessWidget {
  const _ArabicArt();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'ا ب ت',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Arabic',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SurahArt extends StatelessWidget {
  const _SurahArt();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      height: 78,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.mosque_rounded, color: Colors.white, size: 42),
    );
  }
}

class _QuizArt extends StatelessWidget {
  const _QuizArt();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.emoji_events_rounded,
      color: Colors.white,
      size: 56,
    );
  }
}

class _BanglaVowelCard extends StatelessWidget {
  const _BanglaVowelCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF6B7A), Color(0xFFFF5B93)],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B7A).withValues(alpha: 0.28),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Padding(
            padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'বাংলা স্বরবর্ণ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    height: 1.05,
                  ),
                ),
                SizedBox(height: 6),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'অ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.w900,
                            height: 0.95,
                            shadows: [
                              Shadow(
                                color: Color(0x22000000),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text('📖', style: TextStyle(fontSize: 34, height: 1)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
