import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/helpers/extensions.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/routes/app_pages.dart';

class PartnerOnBoarding extends StatefulWidget {
  const PartnerOnBoarding({
    super.key,
  });

  @override
  State<PartnerOnBoarding> createState() => _PartnerOnBoardingState();
}

class _PartnerOnBoardingState extends State<PartnerOnBoarding>
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

    _logoOffset = Tween<Offset>(begin: const Offset(0, -0.30), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.25, curve: Curves.easeOut)));
    _logoFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.25, curve: Curves.easeIn)));

    _headlineOffset =
        Tween<Offset>(begin: const Offset(0, -0.40), end: Offset.zero).animate(
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

    _controller.forward();
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

    double logoSize() => (height * 0.08).clamp(44.0, 88.0);
    double ctaHeight() => (height * 0.085).clamp(52.0, 80.0);

    return ScaleTransition(
      scale: _scaleAnim,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/partner_program.png',
                fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color.fromARGB(255, 7, 15, 48).applyOpacity(0.92),
                    AppColors.kDarkBlue.applyOpacity(0.74),
                    AppColors.kDarkBlue.applyOpacity(0.56),
                  ],
                  stops: const [0.3, 0.55, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.09),
                  SlideTransition(
                    position: _logoOffset,
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: Image.asset('assets/images/mrwh_logo.png',
                          color: AppColors.mainColor, height: logoSize()),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  SlideTransition(
                    position: _headlineOffset,
                    child: FadeTransition(
                      opacity: _headlineFade,
                      child: Text(
                        "partner_onboard_title".tr,
                        style: Get.textTheme.headlineLarge?.copyWith(
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  SlideTransition(
                    position: _headlineOffset,
                    child: FadeTransition(
                      opacity: _headlineFade,
                      child: Text(
                        "${'partner_onboard_welcome'.tr} \n ${'partner_onboard_body'.tr}",
                        style: Get.textTheme.headlineLarge?.copyWith(
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  SlideTransition(
                    position: _ctaOffset,
                    child: FadeTransition(
                      opacity: _ctaFade,
                      child: SizedBox(
                        width: width * 0.86,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(Routes.PARTNER_PROGRAM);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.kDarkBlue.applyOpacity(0.8),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(ctaHeight() / 2),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'get_started'.tr,
                            style: const TextStyle(
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
