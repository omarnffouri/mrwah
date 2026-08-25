import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/widgets/app_gradient.dart';
import 'package:mrwah/app/modules/my_bookings/views/bookings_view.dart';
import 'package:mrwah/app/modules/car_wash/views/car_wash_view.dart';
import 'package:mrwah/app/modules/home/presentation/views/home_view.dart';
import 'package:mrwah/app/modules/main_screen/controllers/main_screen_controller.dart';
import 'package:mrwah/app/core/widgets/app_nav_bar.dart';
import 'package:mrwah/app/modules/profile/views/profile_view.dart';

class MainScreenView extends GetView<MainScreenController> {
  const MainScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(),
      const CarWashView(),
      const BookingsView(),
      const ProfileView(),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const Positioned.fill(
            child: AppGradient(),
          ),
          // Fading page transition!
          Obx(() => AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey<int>(controller.selectedIndex.value),
                  child: pages[controller.selectedIndex.value],
                ),
              )),
          // Floating nav bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(
              () => CustomBottomNavBar(
                selectedIndex: controller.selectedIndex.value,
                onTap: controller.changeTab,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
