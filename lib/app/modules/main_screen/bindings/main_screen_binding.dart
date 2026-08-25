import 'package:get/get.dart';
import 'package:mrwah/app/modules/car_wash/controllers/car_wash_controller.dart';
import 'package:mrwah/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:mrwah/app/modules/my_bookings/controllers/bookings_controller.dart';
import 'package:mrwah/app/modules/profile/controllers/profile_controller.dart';

import '../controllers/main_screen_controller.dart';

class MainScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainScreenController>(
      () => MainScreenController(),
    );
    Get.put(HomeController());
    Get.put(CarWashController());
    Get.lazyPut(() => BookingsController());
    Get.lazyPut(() => ProfileController());
  }
}
