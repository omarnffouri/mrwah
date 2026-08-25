import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/helpers/extensions.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/core/widgets/user_profile_image.dart';
import 'package:mrwah/app/modules/profile/views/pages/fav_view.dart';
import 'package:mrwah/app/modules/profile/views/pages/help_support_view.dart';
import 'package:mrwah/app/routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 250,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0B1437),
                  Color(0xFF1A237E),
                ],
              ),
            ),
          ),

          // Main content scrollable
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // 🔵 Top Profile Section
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserProfileImage(
                        image: controller.user.value.profileImage ?? '',
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Obx(() => Text(
                                controller.user.value.firstname ?? '',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.mainColor,
                                ),
                              )),
                          Obx(() => Text(
                                controller.user.value.email ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.mainColor.applyOpacity(0.8),
                                ),
                              )),
                        ],
                      ),
                      // const Spacer(),
                      // TextButton.icon(
                      //   onPressed: () {},
                      //   icon: Icon(Icons.edit,
                      //       size: 16, color: AppColors.mainColor),
                      //   label: Text("edit".tr,
                      //       style: TextStyle(
                      //           color: AppColors.mainColor, fontSize: 14)),
                      // )
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
                      image: DecorationImage(
                        image: AssetImage('assets/images/main_bg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ListView(
                      children: [
                        _sectionTitle("general".tr),
                        _menuItem(Icons.favorite, "favorite_cars".tr,
                            () => Get.to(() => FavoriteCarsView())),
                        _menuItem(Icons.language, "languages".tr,
                            () => Get.toNamed(Routes.LANGUAGES)),
                        Obx(() => _menuSwitchItem(
                              Icons.face_retouching_natural,
                              "face_id_login".tr,
                              controller.isFaceIdEnabled.value,
                              controller.toggleFaceId,
                            )),
                        const SizedBox(height: 10),
                        _sectionTitle("support".tr),
                        _menuItem(Icons.policy, "privacy_policy".tr,
                            () => controller.openPrivacyPolicy()),
                        _menuItem(Icons.support_agent, "help_support".tr,
                            () => Get.to(() => const HelpSupportView())),
                        _menuItem(Icons.delete, "Delete Account",
                            controller.confirmDelete),
                        _menuItem(Icons.logout, "log_out".tr,
                            controller.confirmLogout),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 2),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.bgColor,
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String text, VoidCallback onTap) {
    return GestureDetector(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.mainColor.applyOpacity(0.1),
          child: Icon(icon, color: AppColors.mainColor),
        ),
        title: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: AppColors.textColor,
          ),
        ),
        trailing:
            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.mainColor),
        onTap: onTap,
      ),
    );
  }

  Widget _menuSwitchItem(
      IconData icon, String text, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.mainColor.applyOpacity(0.1),
        child: Icon(icon, color: AppColors.mainColor),
      ),
      title: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: AppColors.textColor,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.mainColor,
        inactiveThumbColor: AppColors.bgColor,
        trackOutlineColor: WidgetStateProperty.all(AppColors.mainColor),
      ),
    );
  }
}
