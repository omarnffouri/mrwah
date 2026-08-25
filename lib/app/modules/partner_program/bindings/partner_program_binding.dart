import 'package:get/get.dart';

import '../controllers/partner_program_controller.dart';

class PartnerProgramBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PartnerProgramController>(
      () => PartnerProgramController(),
    );
  }
}
