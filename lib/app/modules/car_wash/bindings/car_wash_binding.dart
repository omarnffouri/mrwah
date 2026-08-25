import 'package:get/get.dart';

import '../controllers/car_wash_controller.dart';

class CarWashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CarWashController>(
      () => CarWashController(),
    );
  }
}
