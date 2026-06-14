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
    final borderColor = isPlaying
        ? Colors.white
        : Colors.white.withValues(alpha: 0.18);
    return Card(
      elevation: 0,
      color: item.color,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: borderColor, width: isPlaying ? 2.4 : 1),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 180),
                  scale: isPlaying ? 1.08 : 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: isPlaying ? 0.28 : 0.18,
                      ),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.volume_up_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              Center(
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 220),
                  scale: isPlaying ? 1.03 : 1.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.imageEmoji ?? item.title,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: item.imageEmoji == null ? 54 : 44,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
