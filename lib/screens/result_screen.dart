import 'package:flutter/material.dart';

import '../services/progress_service.dart';
import '../widgets/app_background.dart';
import '../widgets/star_row.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.score, required this.total});

  final int score;
  final int total;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late final int _stars;

  @override
  void initState() {
    super.initState();
    _stars = _calculateStars();
    ProgressService.saveQuizScore(widget.score, _stars);
  }

  int _calculateStars() {
    final ratio = widget.score / widget.total;
    if (ratio >= 0.85) {
      return 3;
    }
    if (ratio >= 0.6) {
      return 2;
    }
    if (ratio > 0) {
      return 1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.emoji_events_rounded,
                        size: 86,
                        color: Colors.amber,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Great Job!',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Score: ${widget.score}/${widget.total}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      StarRow(count: _stars, size: 34),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.home_rounded),
                        label: const Text('Back Home'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
