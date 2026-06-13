import 'package:flutter/widgets.dart';

class Responsive {
  const Responsive._();

  static int gridColumns(double width) {
    if (width >= 1000) {
      return 4;
    }
    if (width >= 650) {
      return 3;
    }
    return 2;
  }

  static EdgeInsets pagePadding(double width) {
    if (width >= 900) {
      return const EdgeInsets.symmetric(horizontal: 32, vertical: 24);
    }
    return const EdgeInsets.all(16);
  }
}
