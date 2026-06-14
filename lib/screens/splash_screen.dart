import 'dart:async';

import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onThemeChanged});

  final ValueChanged<bool> onThemeChanged;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.06).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );
    Timer(const Duration(seconds: 3), _goHome);
  }

  void _goHome() {
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => HomeScreen(onThemeChanged: widget.onThemeChanged),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF60C8FF), Color(0xFF7BDEFF), Color(0xFF46C96D)],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(left: 18, top: 60, child: _Cloud(size: 58)),
            const Positioned(right: 26, top: 86, child: _Cloud(size: 46)),
            const Positioned(left: 80, top: 120, child: _Cloud(size: 28)),
            const Positioned(right: 80, top: 180, child: _StarBubble()),
            const Positioned(left: 28, top: 210, child: _StarBubble()),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 150,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF78DD72), Color(0xFF49C158)],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 22,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(34),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.32),
                        ),
                      ),
                      child: Column(
                        children: [
                          _RainbowTitle(),
                          const SizedBox(height: 12),
                          Text(
                            'LEARNING APP',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      _KidFace(color: Color(0xFFFFC83D), smile: true),
                      SizedBox(width: 20),
                      _KidFace(color: Color(0xFFFF7A7A), smile: false),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Container(
                    width: 160,
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3C4),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 20,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('📖', style: TextStyle(fontSize: 96)),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Container(
                    width: 180,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.72,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFF34C759),
                          borderRadius: BorderRadius.all(Radius.circular(999)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Loading...',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RainbowTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const colors = [
      Color(0xFFFF6B6B),
      Color(0xFFFFC83D),
      Color(0xFF55C04E),
      Color(0xFF2E7BF6),
    ];
    const letters = ['K', 'I', 'D', 'S'];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(letters.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            letters[index],
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w900,
              color: colors[index],
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _Cloud extends StatelessWidget {
  const _Cloud({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.cloud_rounded,
      color: Colors.white.withValues(alpha: 0.84),
      size: size,
    );
  }
}

class _StarBubble extends StatelessWidget {
  const _StarBubble();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.24),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.star_rounded, size: 14, color: Colors.white),
    );
  }
}

class _KidFace extends StatelessWidget {
  const _KidFace({required this.color, required this.smile});

  final Color color;
  final bool smile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.95),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              smile ? '😊' : '😄',
              style: const TextStyle(fontSize: 34),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ],
    );
  }
}
