import 'package:get/get.dart';

import '../controllers/register_stepper_controller.dart';

class RegisterStepperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterStepperController>(
      () => RegisterStepperController(),
    );
  }
}
