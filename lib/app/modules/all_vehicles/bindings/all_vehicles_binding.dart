import 'package:get/get.dart';

import '../controllers/all_vehicles_controller.dart';

class AllVehiclesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllVehiclesController>(
      () => AllVehiclesController(),
    );
  }
}
