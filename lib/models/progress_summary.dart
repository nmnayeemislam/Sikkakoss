class ProgressSummary {
  const ProgressSummary({
    required this.completedLessons,
    required this.quizScores,
    required this.lastOpenedCategory,
    required this.totalStars,
    required this.isDarkMode,
  });

  final Set<String> completedLessons;
  final List<int> quizScores;
  final String lastOpenedCategory;
  final int totalStars;
  final bool isDarkMode;

  int get bestQuizScore {
    if (quizScores.isEmpty) {
      return 0;
    }
    return quizScores.reduce(
      (value, element) => value > element ? value : element,
    );
  }
}
