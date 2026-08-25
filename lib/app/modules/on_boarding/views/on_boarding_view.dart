import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/modules/on_boarding/views/components/on_boarding_one.dart';
import 'package:mrwah/app/modules/on_boarding/views/components/on_boarding_three.dart';
import 'package:mrwah/app/modules/on_boarding/views/components/on_boarding_two.dart';
import 'package:mrwah/app/routes/app_pages.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  static const Color kDarkBlue = Color(0xFF0B1437);
  static const Color kGold = Color(0xFFF4C14B);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  void _goToPage(int idx) {
    _pageController.animateToPage(idx,
        duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OnBoardingView.kDarkBlue,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (idx) => setState(() => _pageIndex = idx),
            children: [
              OnboardingPageOne(
                active: _pageIndex == 0,
                onNext: () => _goToPage(1),
              ),
              OnBoardingTwo(
                active: _pageIndex == 1,
                onNext: () => _goToPage(2),
              ),
              OnBoardingThree(
                active: _pageIndex == 2,
                onNext: () {
                  Get.offNamed(Routes.LOGIN);
                },
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 22,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _PagerDot(active: _pageIndex == 0),
                const SizedBox(width: 8),
                _PagerDot(active: _pageIndex == 1),
                const SizedBox(width: 8),
                _PagerDot(active: _pageIndex == 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PagerDot extends StatelessWidget {
  final bool active;
  const _PagerDot({required this.active});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: active ? 22 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? const Color(0xFFF4C14B) : Colors.white24,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
