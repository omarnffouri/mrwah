import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    this.selectedIndex = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 24),
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.circular(46),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) {
            final isActive = selectedIndex == index;

            return GestureDetector(
              onTap: () => onTap(index),
              child: AnimatedScale(
                scale: isActive ? 1.10 : 1.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                child: _buildNavItem(index, isActive),
              ),
            );
          }),
        ),
      ),
    );
  }

  /// Build tab with icon and text when active
  Widget _buildNavItem(int index, bool isActive) {
    final String label = _labelForIndex(index);

    // Active → show pill with icon + text
    if (isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.bgColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            _buildIcon(index, true),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: AppColors.mainColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    // Inactive → only icon
    return _buildIcon(index, false);
  }

  /// Build SVG or FA icon depending on index
  Widget _buildIcon(int index, bool isActive) {
    final Color color = isActive ? AppColors.mainColor : Colors.white54;

    if (index == 1) {
      // Car wash is SVG
      return SvgPicture.asset(
        'assets/svgs/car-wash.svg',
        width: 22,
        height: 22,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    }

    return FaIcon(
      _iconForIndex(index),
      size: 22,
      color: color,
    );
  }

  /// FontAwesome icons
  IconData _iconForIndex(int index) {
    switch (index) {
      case 0:
        return FontAwesomeIcons.house;
      case 2:
        return FontAwesomeIcons.book;
      case 3:
        return FontAwesomeIcons.user;
      default:
        return FontAwesomeIcons.circleQuestion;
    }
  }

  /// Labels for each tab
  String _labelForIndex(int index) {
    switch (index) {
      case 0:
        return "home".tr;
      case 1:
        return "car_wash".tr;
      case 2:
        return "bookings".tr;
      case 3:
        return "profile".tr;
      default:
        return "";
    }
  }
}
