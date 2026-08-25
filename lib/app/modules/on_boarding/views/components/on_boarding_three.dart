import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/modules/on_boarding/views/components/partner_web_view.dart';

class OnBoardingThree extends StatefulWidget {
  final VoidCallback onNext;
  final bool active;
  const OnBoardingThree({super.key, required this.onNext, this.active = false});

  @override
  State<OnBoardingThree> createState() => _OnBoardingThreeState();
}

class _OnBoardingThreeState extends State<OnBoardingThree>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<Offset> _headlineOffset;
  late final Animation<double> _headlineFade;
  late final Animation<Offset> _ctaOffset;
  late final Animation<double> _ctaFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _scaleAnim = Tween<double>(begin: 0.98, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _headlineOffset =
        Tween<Offset>(begin: const Offset(0, 0.20), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _controller,
                curve: const Interval(0.10, 0.60, curve: Curves.easeOut)));
    _headlineFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.10, 0.60, curve: Curves.easeIn)));

    _ctaOffset = Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.55, 1.0, curve: Curves.elasticOut)));
    _ctaFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 1.0, curve: Curves.easeIn)));

    if (widget.active) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant OnBoardingThree oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.active && widget.active) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final height = mq.size.height;

    return ScaleTransition(
      scale: _scaleAnim,
      child: Stack(
        children: [
          // BG image
          Positioned.fill(
            child: Image.asset(
              'assets/images/car_washing.jpg', // <-- Change to your asset
              fit: BoxFit.fitHeight,
            ),
          ),
          // Gradient overlay: white -> transparent up
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: height * 0.45, // about the lower half
            child: IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xFF0B1437), // solid blue
                      Color(0xE50B1437), // 90% blue
                      Color(0x700B1437), // 44% blue
                      Color(0x000B1437), // 0% blue (transparent)
                    ],
                    stops: [0, 0.32, 0.89, 1],
                  ),
                ),
              ),
            ),
          ),
          // Main content: text and button (over the gradient)
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 32,
                top: height * 0.54,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main headline
                  SlideTransition(
                    position: _headlineOffset,
                    child: FadeTransition(
                      opacity: _headlineFade,
                      child: Text(
                        "Give New Look\nTo Your Car",
                        style: TextStyle(
                          color: AppColors.mainColor, // strong orange
                          fontWeight: FontWeight.bold,
                          fontSize: 34,
                          height: 1.13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FadeTransition(
                    opacity: _headlineFade,
                    child: Text(
                      "Experience the power of perfect foam with the most luxurious wash around.",
                      style: TextStyle(
                        color: AppColors.mainColor,
                        fontSize: 18,
                        height: 1.35,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14, left: 4),
                    child: Text(
                      "Start as :",
                      style:
                          TextStyle(color: AppColors.mainColor, fontSize: 20),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SlideTransition(
                          position: _ctaOffset,
                          child: FadeTransition(
                            opacity: _ctaFade,
                            child: SizedBox(
                              height: 60,
                              child: ElevatedButton(
                                onPressed: widget.onNext,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.mainColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'User',
                                  style: TextStyle(
                                    color: AppColors.bgColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16), // spacing between buttons
                      Expanded(
                        child: SlideTransition(
                          position: _ctaOffset,
                          child: FadeTransition(
                            opacity: _ctaFade,
                            child: SizedBox(
                              height: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(() => const PartnerWebView(
                                        url: 'https://mrwah.org/admin',
                                      ));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.mainColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Partner',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.bgColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
