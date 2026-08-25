import 'package:get/get.dart';

class MainScreenController extends GetxController {
  final selectedIndex = 0.obs;
  final isReverse = false.obs;

  void changeTab(int newIndex) {
    isReverse.value = newIndex < selectedIndex.value;
    selectedIndex.value = newIndex;
  }
}
