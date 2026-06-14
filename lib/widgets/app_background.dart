import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? const [Color(0xFF16213E), Color(0xFF0F3460)]
              : const [Color(0xFFFFF8EB), Color(0xFFFFFCF8), Color(0xFFFFF0D9)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -30,
            top: 40,
            child: _GlowDot(
              color: const Color(0xFFB8E8FF).withValues(alpha: 0.32),
              size: 140,
            ),
          ),
          Positioned(
            right: -50,
            top: 120,
            child: _GlowDot(
              color: const Color(0xFFFFC4DA).withValues(alpha: 0.26),
              size: 160,
            ),
          ),
          Positioned(
            left: 28,
            bottom: 90,
            child: _GlowDot(
              color: const Color(0xFFFFE48A).withValues(alpha: 0.24),
              size: 110,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _GlowDot extends StatelessWidget {
  const _GlowDot({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
