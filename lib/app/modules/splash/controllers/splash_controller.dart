import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mrwah/app/routes/app_pages.dart';
import 'package:mrwah/app/services/storage_service.dart';
import 'package:mrwah/app/modules/login/domain/entities/user.dart';
import 'package:mrwah/app/modules/login/presentation/controllers/login_controller.dart';
import 'package:mrwah/app/services/app_update_service.dart';
import 'package:new_version_plus/new_version_plus.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;
  late Animation<Offset> slideAnimation;

  final loginController = Get.put(LoginController(), permanent: true);
  final AppUpdateService _appUpdateService = AppUpdateService();

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );

    scaleAnimation = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutBack),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    animationController.forward();

    // After splash, go next
    Future.delayed(const Duration(milliseconds: 1600), () async {
      await _handlePostSplash();
    });
  }

  Future<void> _handlePostSplash() async {
    final hasBlockingUpdate = await _checkForUpdates();

    if (hasBlockingUpdate) {
      return;
    }

    await nextPage();
  }

  Future<bool> _checkForUpdates() async {
    final status = await _appUpdateService.getLatestStatus();

    if (status == null || !status.canUpdate) {
      return false;
    }

    _showUpdateDialog(status);
    return true;
  }

  void _showUpdateDialog(VersionStatus status) {
    Get.dialog(
      barrierDismissible: false,
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/mrwh_logo.png',
                height: 64,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 12),
              const Text('Update Required'),
            ],
          ),
          content: Text(
            'A newer version (${status.storeVersion}) is available. '
            'Please update the app to continue.',
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E1B45),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => _appUpdateService.openStoreListing(status),
                child: const Text('Update Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> nextPage() async {
    // ✅ Check for first launch before anything else
    if (StorageService.isFirstLaunch) {
      StorageService.isFirstLaunch = false;

      Get.offAllNamed(Routes.ON_BOARDING);
      return;
    }

    final userMap = StorageService.user;

    if (StorageService.isLoggedIn && userMap != null) {
      userMap['token'] = StorageService.token;
      loginController.user.value = User.fromJson(userMap);

      // -------------------------------
      // 🔥 NEW BIOMETRIC LOGIC ADDED HERE
      // -------------------------------
      if (StorageService.isBiometricEnabled) {
        // Go to lock screen instead of main screen
        Get.offAllNamed(Routes.LOCK_SCREEN);
        return;
      }
      // -------------------------------
      // END OF NEW LOGIC
      // -------------------------------

      // old logic remains untouched
      Get.offAllNamed(Routes.MAIN_SCREEN);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
