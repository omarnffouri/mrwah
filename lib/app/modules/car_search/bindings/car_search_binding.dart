import 'package:get/get.dart';

import '../controllers/car_search_controller.dart';

class CarSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CarSearchController>(
      () => CarSearchController(),
    );
  }
}
