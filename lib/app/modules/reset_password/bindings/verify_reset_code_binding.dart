import 'package:get/get.dart';
import '../controllers/verify_reset_code_controller.dart';

class VerifyResetCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyResetCodeController>(
      () => VerifyResetCodeController(),
    );
  }
}
