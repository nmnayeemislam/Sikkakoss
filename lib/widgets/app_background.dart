import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [Color(0xFF16213E), Color(0xFF0F3460)]
              : const [AppColors.cream, Color(0xFFE9FFF9), Color(0xFFFFF0F6)],
        ),
      ),
      child: child,
    );
  }
}
