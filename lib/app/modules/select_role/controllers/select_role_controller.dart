import 'package:get/get.dart';

class SelectRoleController extends GetxController {
  var selectedRole = ''.obs;
  final hoverUser = false.obs;
  final hoverPartner = false.obs;

  get isEnabled => selectedRole.value.isEmpty;
}
