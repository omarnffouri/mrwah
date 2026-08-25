import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/widgets/app_snack_bar.dart';
import 'package:mrwah/app/modules/login/domain/usecases/add_device_token.dart';
import 'package:mrwah/app/modules/login/presentation/controllers/login_controller.dart';
import 'package:mrwah/app/modules/register_stepper/domain/entites/register_params.dart';
import 'package:mrwah/app/modules/register_stepper/domain/usecases/register_usecase.dart';
import 'package:mrwah/app/routes/app_pages.dart';
import 'package:mrwah/app/services/injection_service.dart';
import 'package:mrwah/app/services/storage_service.dart';

class OtpController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final int otpLength = 6;

  final otpCode = ''.obs;
  final TextEditingController otpController = TextEditingController();
  final RxInt resendSeconds = 0.obs;
  final RxBool canResend = true.obs;
  int resendCount = 0;
  Timer? resendTimer;

  late AnimationController animationController;
  late Animation<Offset> slideAnimation;
  late Animation<double> fadeAnimation;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final registerUseCase = sl<RegisterUseCase>();
  final addDeviceTokenUseCase = sl<AddDeviceTokenUseCase>();

  late String verificationId;
  late RegisterParam registerParam;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    verificationId = Get.arguments['verificationId'];
    registerParam = Get.arguments['registerParam'];

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
    );

    fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(animationController);

    animationController.forward();
  }

  String get maskedPhone {
    final phone = registerParam.phone;

    if (phone.length < 4) return phone;

    final last2 = phone.substring(phone.length - 2);
    return "+971 ${phone.substring(0, 2)}****$last2";
  }

  // ------------------------------------------------------------
  // VERIFY OTP → REGISTER → SAVE DEVICE TOKEN
  // ------------------------------------------------------------
  Future<void> submitOtp() async {
    if (otpCode.value.length < otpLength) {
      AppSnackBar.info(
        "Please enter complete OTP",
      );
      return;
    }

    try {
      isLoading.value = true;

      // ------------------------------------------------
      // 1️⃣ VERIFY OTP WITH FIREBASE
      // ------------------------------------------------
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode.value,
      );

      await _auth.signInWithCredential(credential);

      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) {
        throw Exception('Firebase user not found');
      }

      // ------------------------------------------------
      // 2️⃣ CALL EXISTING REGISTER API (NO TOKEN PASSED)
      // ------------------------------------------------
      final result = await registerUseCase(registerParam);

      result.fold(
        (user) async {
          isLoading.value = false;

          // ----------------------------
          // PARTNER FLOW
          // ----------------------------
          if (registerParam.type == UserType.partner) {
            AppSnackBar.success(
              "We will contact you soon",
            );

            // Do NOT save user / token
            Get.offAllNamed(Routes.LOGIN);
            return;
          }

          // ----------------------------
          // NORMAL USER FLOW
          // ----------------------------
          await StorageService.saveUser(user);

          if (Get.isRegistered<LoginController>()) {
            Get.find<LoginController>().user.value = user;
          }

          await _sendDeviceTokenToBackend();

          Get.offAllNamed(Routes.MAIN_SCREEN);
        },
        (failure) {
          isLoading.value = false;
          AppSnackBar.error(
            failure.message,
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;

      AppSnackBar.error(
        e.message ?? 'Invalid OTP',
      );
    } catch (e) {
      isLoading.value = false;

      AppSnackBar.error(
        e.toString(),
      );
    }
  }

  int _getNextDelaySeconds() {
    resendCount++;

    if (resendCount == 1) return 30;
    if (resendCount == 2) return 60;
    if (resendCount == 3) return 120;
    if (resendCount == 4) return 600;
    return 3600; // 1 hour
  }

  void _startResendTimer(int seconds) {
    resendSeconds.value = seconds;
    canResend.value = false;

    resendTimer?.cancel();
    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds.value <= 1) {
        timer.cancel();
        canResend.value = true;
        resendSeconds.value = 0;
      } else {
        resendSeconds.value--;
      }
    });
  }

  Future<void> resendOtp() async {
    if (!canResend.value) return;

    try {
      final delay = _getNextDelaySeconds();
      _startResendTimer(delay);

      final phone = registerParam.phone;
      final firebasePhone = '+971$phone';

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: firebasePhone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (_) {},
        verificationFailed: (e) {
          AppSnackBar.error(e.message ?? 'Failed to resend OTP');
        },
        codeSent: (String newVerificationId, int? _) {
          verificationId = newVerificationId;

          AppSnackBar.success(
            "OTP resent successfully",
            title: "Sent",
          );
        },
        codeAutoRetrievalTimeout: (_) {},
      );
    } catch (e) {
      AppSnackBar.error(e.toString());
    }
  }

  Future<void> _sendDeviceTokenToBackend() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();

    if (fcmToken != null) {
      final result = await addDeviceTokenUseCase(fcmToken);
      result.fold(
        (_) => debugPrint("🔥 Device token saved"),
        (f) => debugPrint("❌ Token save failed: ${f.message}"),
      );
    }
  }

  @override
  void onClose() {
    resendTimer?.cancel();
    otpController.dispose();
    animationController.dispose();
    super.onClose();
  }
}
