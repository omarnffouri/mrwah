import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mrwah/app/core/helpers/extensions.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';

class LoadingOverlay extends StatelessWidget {
  final String text;

  const LoadingOverlay({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.applyOpacity(0.65),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 44,
              height: 44,
              child: SpinKitSpinningLines(
                color: AppColors.kGold,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              text,
              style: const TextStyle(
                color: AppColors.kDarkBlue,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
