import 'package:flutter/material.dart';

class KidsActionPill extends StatelessWidget {
  const KidsActionPill({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.foregroundColor = const Color(0xFF24304F),
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
    );
  }
}

class KidsRoundNavRow extends StatelessWidget {
  const KidsRoundNavRow({
    super.key,
    this.onLeft,
    this.onHome,
    this.onRight,
    this.showHome = true,
    this.leftIcon = Icons.arrow_back_rounded,
    this.homeIcon = Icons.home_rounded,
    this.rightIcon = Icons.arrow_forward_rounded,
    this.leftColor = const Color(0xFF8C62E5),
    this.homeColor = const Color(0xFF2E7BF6),
    this.rightColor = const Color(0xFF43B556),
  });

  final VoidCallback? onLeft;
  final VoidCallback? onHome;
  final VoidCallback? onRight;
  final bool showHome;
  final IconData leftIcon;
  final IconData homeIcon;
  final IconData rightIcon;
  final Color leftColor;
  final Color homeColor;
  final Color rightColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RoundIconButton(icon: leftIcon, color: leftColor, onPressed: onLeft),
        if (showHome) ...[
          const SizedBox(width: 16),
          _RoundIconButton(icon: homeIcon, color: homeColor, onPressed: onHome),
        ],
        const SizedBox(width: 16),
        _RoundIconButton(
          icon: rightIcon,
          color: rightColor,
          onPressed: onRight,
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}
