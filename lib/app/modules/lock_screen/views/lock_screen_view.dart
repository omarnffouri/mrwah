import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/core/widgets/app_snack_bar.dart';
import 'package:mrwah/app/routes/app_pages.dart';
import 'package:mrwah/app/services/biometric_auth_service.dart';
import 'package:mrwah/app/services/injection_service.dart';

class LockScreenView extends StatelessWidget {
  const LockScreenView({super.key});

  Future<void> _unlock() async {
    final success = await sl<BiometricAuthService>().authenticate();

    if (success) {
      Get.offAllNamed(Routes.MAIN_SCREEN);
    } else {
      AppSnackBar.error(
        'lock_screen_try_again'.tr,
        title: 'lock_screen_failed'.tr,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1B45), // same dark blue top
      body: SafeArea(
        bottom: false,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: const BoxDecoration(
            color: Color(0xFFF8F8F8),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lock icon inside golden bubble
              // Container(
              //   padding: const EdgeInsets.all(20),
              //   decoration: BoxDecoration(
              //     color: const Color(0xFFFFC107).applyOpacity(0.2),
              //     borderRadius: BorderRadius.circular(18),
              //   ),
              //   child: const Icon(
              //     Icons.lock_outline_rounded,
              //     size: 60,
              //     color: Color(0xFFFFC107),
              //   ),
              // ),

              Lottie.asset(
                'assets/images/face_scanning.json',
                width: 240,
              ),

              const SizedBox(height: 28),

              // Title
              Text(
                'lock_screen_title'.tr,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E1B45),
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                'lock_screen_subtitle'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF0E1B45),
                ),
              ),

              const SizedBox(height: 40),

              // Unlock Button
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: _unlock,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainColor, // your gold color
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 3,
                  ),
                  child: Text(
                    'lock_screen_button'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF0E1B45),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
