import 'package:flutter/material.dart';

class StarRow extends StatelessWidget {
  const StarRow({super.key, required this.count, this.size = 24});

  final int count;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        count,
        (index) =>
            Icon(Icons.star_rounded,
             color: Colors.amber.shade600,
             size: size),
      ),
    );
  }
}
