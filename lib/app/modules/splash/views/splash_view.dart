import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 8, 17, 52), // Very dark blue top
              Color.fromARGB(255, 11, 22, 62), // Midnight blue (middle)
              Color.fromARGB(255, 32, 51, 108), // Less dark blue (bottom)
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: controller.fadeAnimation,
            child: Image.asset(
              'assets/images/mrwh_logo.png',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
