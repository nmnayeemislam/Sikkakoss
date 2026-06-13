import 'dart:math';

import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/quiz_question.dart';
import '../widgets/app_background.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<QuizQuestion> _questions;
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _questions = List<QuizQuestion>.from(AppData.quizQuestions)
      ..shuffle(Random());
  }

  void _chooseAnswer(String answer) {
    if (_selectedAnswer != null) {
      return;
    }
    setState(() {
      _selectedAnswer = answer;
      if (answer == _questions[_currentIndex].correctAnswer) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex == _questions.length - 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => ResultScreen(score: _score, total: _questions.length),
        ),
      );
      return;
    }
    setState(() {
      _currentIndex++;
      _selectedAnswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Back',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Question ${_currentIndex + 1} of ${_questions.length}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Text(
                      question.question,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: ListView.separated(
                    itemCount: question.options.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final option = question.options[index];
                      final isSelected = option == _selectedAnswer;
                      final isCorrect = option == question.correctAnswer;
                      final reveal = _selectedAnswer != null;
                      final color = reveal && isCorrect
                          ? Colors.green
                          : reveal && isSelected
                          ? Colors.red
                          : Theme.of(context).colorScheme.surface;
                      return Card(
                        elevation: 0,
                        color: color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          onTap: () => _chooseAnswer(option),
                          title: Text(
                            option,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: reveal && (isCorrect || isSelected)
                                  ? Colors.white
                                  : null,
                            ),
                          ),
                          trailing: reveal && (isCorrect || isSelected)
                              ? Icon(
                                  isCorrect
                                      ? Icons.check_circle_rounded
                                      : Icons.cancel_rounded,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                FilledButton.icon(
                  onPressed: _selectedAnswer == null ? null : _nextQuestion,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(
                    _currentIndex == _questions.length - 1
                        ? 'See Result'
                        : 'Next',
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
