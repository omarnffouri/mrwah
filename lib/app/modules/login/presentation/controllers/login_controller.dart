import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/core/widgets/app_snack_bar.dart';
import 'package:mrwah/app/modules/login/domain/entities/login_params.dart';
import 'package:mrwah/app/modules/login/domain/entities/user.dart';
import 'package:mrwah/app/modules/login/domain/usecases/add_device_token.dart';
import 'package:mrwah/app/modules/login/domain/usecases/login_usecase.dart';
import 'package:mrwah/app/routes/app_pages.dart';
import 'package:mrwah/app/services/biometric_auth_service.dart';
import 'package:mrwah/app/services/injection_service.dart';
import 'package:mrwah/app/services/storage_service.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var rememberMe = false.obs;
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;
  Rx<User> user = const User().obs;

  final formKey = GlobalKey<FormState>();

  late AnimationController animationController;
  late Animation<Offset> slideAnimation;

  final loginUseCase = sl<LoginUseCase>();
  final addDeviceTokenUseCase = sl<AddDeviceTokenUseCase>();

  // --- Toggle Remember Me
  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    try {
      isLoading.value = true;

      final result = await loginUseCase(
        LoginParams(
          email: emailController.text,
          password: passwordController.text,
        ),
      );

      result.fold((user) async {
        /// Save user locally
        await StorageService.saveUser(user);
        this.user.value = user;

        isLoading.value = false;

        // -----------------------------------------------------------
        // BIOMETRIC PROMPT (only once)
        // -----------------------------------------------------------
        if (!StorageService.isBiometricEnabled) {
          final available =
              await sl<BiometricAuthService>().isBiometricAvailable();

          if (available) {
            final enable = await Get.dialog<bool>(
              AlertDialog(
                title: Text("enable_face_id".tr),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset('assets/images/biometry_icon.json',
                        width: 130),
                    const SizedBox(height: 8),
                    Text(
                      "face_id_message".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.bgColor),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(result: false),
                    child: Text("face_id_no".tr,
                        style: TextStyle(color: AppColors.bgColor)),
                  ),
                  TextButton(
                    onPressed: () => Get.back(result: true),
                    child: Text("face_id_yes".tr,
                        style: TextStyle(color: AppColors.bgColor)),
                  ),
                ],
              ),
            );

            // --- Handle the user choice ---
            if (enable == true) {
              final authSuccess =
                  await sl<BiometricAuthService>().authenticate();
              if (authSuccess) {
                await StorageService.setBiometricEnabled(true);
                AppSnackBar.success(
                  "face_id_enabled_message".tr,
                  title: "face_id_enabled".tr,
                );
              }
            } else {
              await StorageService.setBiometricEnabled(false);
              AppSnackBar.info(
                "face_id_disabled_message".tr,
                title: "face_id_disabled".tr,
              );
            }
          }
        }

        // -----------------------------------------------------------
        // SUCCESS SNACKBAR
        // -----------------------------------------------------------

        AppSnackBar.success(
          "Welcome ${user.firstname}",
          title: 'Success',
        );

        // -----------------------------------------------------------
        // REMEMBER ME
        // -----------------------------------------------------------
        if (rememberMe.value) {
          await StorageService.saveCredentials(
            email: emailController.text,
            password: passwordController.text,
          );
        } else {
          await StorageService.clearCredentials();
        }

        // -----------------------------------------------------------
        // SEND DEVICE TOKEN TO BACKEND
        // -----------------------------------------------------------
        final fcmToken = await FirebaseMessaging.instance.getToken();

        if (fcmToken != null) {
          final tokenResult = await addDeviceTokenUseCase(fcmToken);

          tokenResult.fold(
            (success) => debugPrint("🔥 Device token saved to backend"),
            (failure) =>
                debugPrint("❌ Failed saving device token: ${failure.message}"),
          );
        } else {
          debugPrint("❌ No FCM token available");
        }

        // -----------------------------------------------------------
        // NAVIGATE TO MAIN SCREEN
        // -----------------------------------------------------------
        Get.offAllNamed(Routes.MAIN_SCREEN);
      }, (failure) {
        isLoading.value = false;
        AppSnackBar.error(
          failure.message,
        );
      });
    } catch (e) {
      isLoading.value = false;
      AppSnackBar.error(e.toString());
    }
  }

  // --- Navigate
  void goToSignUp() => Get.toNamed(Routes.SELECT_ROLE);
  void goToResetPassword() => Get.toNamed(Routes.RESET_PASSWORD);

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutCubic,
    ));
    animationController.forward();

    if (StorageService.isRememberMe) {
      emailController.text = StorageService.savedEmail;
      passwordController.text = StorageService.savedPassword;
      rememberMe.value = true;
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailController.clear();
    passwordController.dispose();
    super.onClose();
  }
}
