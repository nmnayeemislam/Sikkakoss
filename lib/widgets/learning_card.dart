import 'package:flutter/material.dart';

import '../models/learning_item.dart';

class LearningCard extends StatelessWidget {
  const LearningCard({
    super.key,
    required this.item,
    required this.isCompleted,
    required this.isPlaying,
    required this.onTap,
  });

  final LearningItem item;
  final bool isCompleted;
  final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isPlaying
                  ? item.color
                  : Colors.black.withValues(alpha: 0.05),
              width: isPlaying ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: item.color.withValues(alpha: isPlaying ? 0.18 : 0.10),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? const Color(0xFF43B556)
                          : item.color.withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCompleted
                          ? Icons.check_rounded
                          : Icons.volume_up_rounded,
                      color: isCompleted ? Colors.white : item.color,
                      size: 13,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: item.color,
                                fontWeight: FontWeight.w900,
                                height: 1,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.pronunciation,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: const Color(0xFF24304F),
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        if (item.imageEmoji != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            item.imageEmoji!,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ],
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
