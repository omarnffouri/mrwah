import 'package:flutter/material.dart';

class AppGradient extends StatelessWidget {
  const AppGradient({super.key, this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0B1437),
            Color(0xFF1A237E),
            Color(0xFF0B1437),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}
