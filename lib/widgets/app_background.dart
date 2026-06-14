import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? const [Color(0xFF16213E), Color(0xFF0F3460)]
              : const [Color(0xFFFFF6EA), Color(0xFFFFFAF2), Color(0xFFFFF2E5)],
        ),
      ),
      child: child,
    );
  }
}
