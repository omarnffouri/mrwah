import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/modules/profile/controllers/profile_controller.dart';

class HelpSupportView extends GetView<ProfileController> {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1B45),
      appBar: AppBar(
        title: Text(
          'help_support'.tr,
          style: TextStyle(
            color: AppColors.mainColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: AppColors.mainColor,
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: const BoxDecoration(
          color: Color(0xFFF8F8F8), // light background for the list section
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SupportTile(
              icon: Icons.email_outlined,
              label: 'email_support'.tr,
              onTap: controller.openEmailSupport,
            ),
            const SizedBox(height: 12),
            _SupportTile(
              icon: FontAwesomeIcons.whatsapp,
              label: 'whatsapp_support'.tr,
              onTap: controller.openWhatsAppSupport,
            ),
            const SizedBox(height: 12),
            _SupportTile(
              icon: Icons.phone_in_talk_outlined,
              label: 'call_support'.tr,
              onTap: controller.callSupport,
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SupportTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFC107).withOpacity(0.2), // soft gold
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFFFFC107)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0E1B45),
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 18, color: Color(0xFF0E1B45)),
          ],
        ),
      ),
    );
  }
}
