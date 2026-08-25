import 'package:flutter/material.dart';

extension ColorAplha on Color {
  Color applyOpacity(double opacity) {
    return withAlpha((255.0 * opacity).round());
  }
}
