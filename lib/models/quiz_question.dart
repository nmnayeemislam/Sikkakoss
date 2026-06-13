class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;
}
