import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/enums/register_loading_enum.dart';
import 'package:mrwah/app/core/widgets/app_snack_bar.dart';
import 'package:mrwah/app/modules/register_stepper/domain/entites/register_params.dart';
import 'package:mrwah/app/modules/register_stepper/domain/usecases/register_usecase.dart';
import 'package:mrwah/app/routes/app_pages.dart';
import 'package:mrwah/app/services/injection_service.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterStepperController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxInt step = 0.obs;
  int get totalSteps => 2;
  bool get isFirstStep => step.value == 0;
  bool get isLastStep => step.value == totalSteps - 1;
  Rx<RegisterLoadingState> loadingState = RegisterLoadingState.idle.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();

  late AnimationController animationController;
  late Animation<Offset> slideAnimation;

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumber = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool acceptPrivacy = false.obs;

  final registerUseCase = sl<RegisterUseCase>();

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );
    slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
            CurvedAnimation(
                parent: animationController, curve: Curves.easeOut));
    animationController.forward();
  }

  void next() {
    if (formKey.currentState?.validate() != true) {
      return;
    }
    if (step.value < totalSteps - 1) {
      step.value++;
      animationController.forward(from: 0);
    }
  }

  void back() {
    if (step.value > 0) {
      step.value--;
      animationController.forward(from: 0);
    }
  }

  Future<void> sendOtp() async {
    if (formKey.currentState?.validate() != true) return;

    try {
      loadingState.value = RegisterLoadingState.sendingOtp;

      // ✅ Firebase needs full E.164 number
      final firebasePhone = '+971${phoneNumber.text.trim()}';

      await _auth.verifyPhoneNumber(
        phoneNumber: firebasePhone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          loadingState.value = RegisterLoadingState.idle;
          showSnack(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          loadingState.value = RegisterLoadingState.idle;

          Get.toNamed(
            Routes.OTP,
            arguments: {
              'verificationId': verificationId,
              'registerParam': RegisterParam(
                firstName: firstName.text.trim(),
                lastName: lastName.text.trim(),
                email: emailController.text.trim(),
                phone: phoneNumber.text.trim(),
                password: passwordController.text,
              ),
            },
          );
        },
        codeAutoRetrievalTimeout: (_) {},
      );
    } catch (e) {
      loadingState.value = RegisterLoadingState.idle;

      showSnack(e.toString());
    }
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

  void showSnack(String message) {
    final context = Get.context;
    if (context == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void onClose() {
    firstName.dispose();
    lastName.dispose();
    emailController.dispose();
    phoneNumber.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    animationController.dispose();
    super.onClose();
  }
}
