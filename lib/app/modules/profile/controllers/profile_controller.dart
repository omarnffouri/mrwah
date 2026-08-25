import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/core/widgets/app_snack_bar.dart';
import 'package:mrwah/app/modules/login/domain/usecases/delete_usecase.dart';
import 'package:mrwah/app/modules/login/domain/usecases/logout_usecase.dart';
import 'package:mrwah/app/modules/login/presentation/controllers/login_controller.dart';
import 'package:mrwah/app/routes/app_pages.dart';
import 'package:mrwah/app/services/biometric_auth_service.dart';
import 'package:mrwah/app/services/injection_service.dart';
import 'package:mrwah/app/services/storage_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileController extends GetxController {
  final logoutUseCase = sl<LogoutUseCase>();
  final deleteUseCase = sl<DeleteUsecase>();

  final user = Get.find<LoginController>().user;

  var isLoading = false.obs;

  var isFaceIdEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Load Face ID toggle state
    isFaceIdEnabled.value = StorageService.isBiometricEnabled;
  }

  Future<void> toggleFaceId(bool value) async {
    if (value) {
      // User wants to enable Face ID
      final available = await sl<BiometricAuthService>().isBiometricAvailable();
      if (!available) {
        AppSnackBar.error(
          "Biometric authentication not available.",
        );
        return;
      }

      final success = await sl<BiometricAuthService>().authenticate();
      if (success) {
        await StorageService.setBiometricEnabled(true);
        isFaceIdEnabled.value = true;
        AppSnackBar.success(
          "Face ID Enabled",
        );
      } else {
        AppSnackBar.error(
          "Authentication failed",
        );
      }
    } else {
      // Disable Face ID
      await StorageService.setBiometricEnabled(false);
      isFaceIdEnabled.value = false;
      AppSnackBar.info("Face ID Login has been turned off", title: 'Disabled');
    }
  }

  Future<void> logout() async {
    isLoading.value = true;

    final result = await logoutUseCase();
    result.fold(
      (success) async {
        final remember = StorageService.isRememberMe;
        final savedEmail = StorageService.savedEmail;
        final savedPassword = StorageService.savedPassword;
        await StorageService.clear();
        if (remember) {
          await StorageService.saveCredentials(
            email: savedEmail,
            password: savedPassword,
          );
        }
        AppSnackBar.success(
          'Logged out successfully',
        );

        Get.offAllNamed(Routes.SPLASH);
      },
      (failure) {
        AppSnackBar.error(
          failure.message,
        );
      },
    );

    isLoading.value = false;
  }

  Future<void> deleteUser() async {
    isLoading.value = true;

    final result = await deleteUseCase(user.value.id!);
    result.fold(
      (success) async {
        final remember = StorageService.isRememberMe;
        final savedEmail = StorageService.savedEmail;
        final savedPassword = StorageService.savedPassword;
        await StorageService.clear();
        await StorageService.setBiometricEnabled(false);
        if (remember) {
          await StorageService.saveCredentials(
            email: savedEmail,
            password: savedPassword,
          );
        }

        AppSnackBar.success(
          'Account Deleted successfully',
        );
        Get.offAllNamed(Routes.SPLASH);
      },
      (failure) {
        AppSnackBar.success(
          failure.message,
        );
      },
    );

    isLoading.value = false;
  }

  void openPrivacyPolicy() async {
    final Uri url =
        Uri.parse('https://mrwah.org/documents/Application_Legal_Package.pdf');

    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
      AppSnackBar.error(
        'Could not open Privacy Policy link',
      );
    }
  }

  void confirmLogout() {
    Get.dialog(
      barrierDismissible: true,
      AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.bgColor,
            ),
            onPressed: () {
              Get.back();
              logout(); // close dialog
            },
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
            ),
            onPressed: () {
              Get.back(); // close dialog
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void confirmDelete() {
    Get.dialog(
      AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
          "Are you sure you want to permanently delete your account?",
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.bgColor,
            ),
            onPressed: () {
              Get.back();
              deleteUser(); // close dialog
            },
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
            ),
            onPressed: () {
              Get.back(); // close dialog
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> openEmailSupport() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'mrwahsaeed@gmail.com',
      query: Uri.encodeFull('subject=Help & Support Request'),
    );

    if (!await launchUrl(emailUri)) {
      AppSnackBar.error(
        'Could not open email app',
      );
    }
  }

  Future<void> openWhatsAppSupport() async {
    const phone = '+971562697565';
    final message =
        Uri.encodeComponent('Hello, I need help with the Mrwah app.');
    final whatsappUrl = Platform.isIOS
        ? Uri.parse('https://wa.me/$phone?text=$message')
        : Uri.parse('whatsapp://send?phone=$phone&text=$message');

    if (!await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication)) {
      AppSnackBar.error(
        'Could not open WhatsApp',
      );
    }
  }

  Future<void> callSupport() async {
    final Uri telUri = Uri(
      scheme: 'tel',
      path: '+971562697565',
    );

    if (await canLaunchUrl(telUri)) {
      await launchUrl(
        telUri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      AppSnackBar.error(
        'Cannot open phone dialer on this device',
      );
    }
  }
}
