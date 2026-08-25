import 'package:get/get.dart';
import 'package:flutter/material.dart';

class OnBoardingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation<Offset> logoOffset;
  late Animation<double> logoFade;
  late Animation<Offset> headlineOffset;
  late Animation<double> headlineFade;
  late Animation<Offset> ctaOffset;
  late Animation<double> ctaFade;

  RxInt pageIndex = 0.obs;
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    logoOffset = Tween<Offset>(begin: const Offset(0, -0.20), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: animController,
            curve: const Interval(0.0, 0.28, curve: Curves.easeOut)));
    logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animController,
        curve: const Interval(0.0, 0.28, curve: Curves.easeIn)));

    headlineOffset =
        Tween<Offset>(begin: const Offset(0, -0.24), end: Offset.zero).animate(
            CurvedAnimation(
                parent: animController,
                curve: const Interval(0.20, 0.55, curve: Curves.easeOut)));
    headlineFade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animController,
        curve: const Interval(0.20, 0.55, curve: Curves.easeIn)));

    ctaOffset = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: animController,
            curve: const Interval(0.52, 1.0, curve: Curves.easeOutQuart)));
    ctaFade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animController,
        curve: const Interval(0.52, 1.0, curve: Curves.easeIn)));

    pageController = PageController();

    animController.forward();
    pageController.addListener(() {
      int page = pageController.page?.round() ?? 0;
      pageIndex.value = page;
      if (page == 0) animController.forward();
    });
  }

  void goToPage(int idx) {
    pageController.animateToPage(idx,
        duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    if (idx == 0) {
      animController.forward(from: 0);
    }
  }

  @override
  void onClose() {
    animController.dispose();
    pageController.dispose();
    super.onClose();
  }
}
