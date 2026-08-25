import 'package:flutter/material.dart';
import 'package:mrwah/app/core/helpers/extensions.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';

class OnBoardingTwo extends StatefulWidget {
  final bool active;
  final VoidCallback onNext;
  const OnBoardingTwo({super.key, required this.onNext, this.active = false});

  @override
  State<OnBoardingTwo> createState() => _OnBoardingTwoState();
}

class _OnBoardingTwoState extends State<OnBoardingTwo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<Offset> _logoOffset;
  late final Animation<double> _logoFade;
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

    _logoOffset = Tween<Offset>(begin: const Offset(0, -0.28), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.25, curve: Curves.easeOut)));
    _logoFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.25, curve: Curves.easeIn)));

    _headlineOffset =
        Tween<Offset>(begin: const Offset(0, -0.36), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _controller,
                curve: const Interval(0.15, 0.55, curve: Curves.easeOut)));
    _headlineFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.55, curve: Curves.easeIn)));

    _ctaOffset = Tween<Offset>(begin: const Offset(0, -0.35), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.45, 1.0, curve: Curves.elasticOut)));
    _ctaFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 1.0, curve: Curves.easeIn)));

    if (widget.active) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant OnBoardingTwo oldWidget) {
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
    final width = mq.size.width;

    double ctaHeight() => (height * 0.085).clamp(52.0, 80.0);

    return ScaleTransition(
      scale: _scaleAnim,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bg_2.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.kDarkBlue.applyOpacity(0.92),
                    AppColors.kDarkBlue.applyOpacity(0.74),
                    AppColors.kDarkBlue.applyOpacity(0.56),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: width * 0.06, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.05),
                  SlideTransition(
                    position: _logoOffset,
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: Image.asset('assets/images/mrwh_logo.png',
                          color: AppColors.kGold, height: 64),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  SlideTransition(
                    position: _headlineOffset,
                    child: FadeTransition(
                      opacity: _headlineFade,
                      child: const Text(
                        "Let's Start A New Experience\nwith our services.",
                        style: TextStyle(
                          fontSize: 45,
                          color: AppColors.kGold,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Discover your next adventure with Mrwah. We’re here to provide you with a seamless car rental experience. Let’s get started on your journey.",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.kGold.applyOpacity(0.95),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  SlideTransition(
                    position: _ctaOffset,
                    child: FadeTransition(
                      opacity: _ctaFade,
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: widget.onNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.kDarkBlue.applyOpacity(0.8),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(ctaHeight() / 2),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              color: AppColors.kGold,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
