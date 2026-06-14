import 'dart:math';

import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/quiz_question.dart';
import '../widgets/app_background.dart';
import '../widgets/kids_controls.dart';
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
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: const Color(0xFF9B7BEE),
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                foregroundColor: Colors.white,
                title: const Text('Quiz'),
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
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Question ${_currentIndex + 1} of ${_questions.length}',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 10,
                              backgroundColor: Colors.white,
                              color: const Color(0xFF32B8A6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Text(
                        question.question,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF24304F),
                            ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(question.options.length, (index) {
                      final option = question.options[index];
                      final isSelected = option == _selectedAnswer;
                      final isCorrect = option == question.correctAnswer;
                      final reveal = _selectedAnswer != null;
                      final selectedColor = isCorrect
                          ? const Color(0xFF56C250)
                          : const Color(0xFFFF6B6B);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () => _chooseAnswer(option),
                          borderRadius: BorderRadius.circular(18),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: reveal && (isCorrect || isSelected)
                                  ? selectedColor.withValues(alpha: 0.16)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: reveal && (isCorrect || isSelected)
                                    ? selectedColor
                                    : Colors.black.withValues(alpha: 0.06),
                                width: reveal && (isCorrect || isSelected)
                                    ? 2
                                    : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    option,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFF24304F),
                                        ),
                                  ),
                                ),
                                if (reveal && (isCorrect || isSelected))
                                  Icon(
                                    isCorrect
                                        ? Icons.check_circle_rounded
                                        : Icons.cancel_rounded,
                                    color: selectedColor,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                    KidsActionPill(
                      label: _currentIndex == _questions.length - 1
                          ? 'See Result'
                          : 'Next',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: _selectedAnswer == null
                          ? () {}
                          : _nextQuestion,
                      backgroundColor: const Color(0xFF9B7BEE),
                      foregroundColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
