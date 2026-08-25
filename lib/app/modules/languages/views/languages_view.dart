import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/helpers/extensions.dart';
import 'package:mrwah/app/modules/languages/controllers/languages_controller.dart';

class LanguagesView extends GetView<LanguagesController> {
  const LanguagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1B45),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFFFC107)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'languages'.tr,
          style: const TextStyle(
            color: Color(0xFFFFC107),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: const BoxDecoration(
          color: Color(0xFFF8F8F8),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Obx(() {
          final selectedCode = controller.selectedLanguage.value;

          return ListView.separated(
            itemCount: controller.languages.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final lang = controller.languages[index];
              final isSelected = selectedCode == lang['code'];

              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => controller.changeLanguage(lang['code']!),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFFF6DE) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.applyOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color:
                          isSelected ? const Color(0xFFFFC107) : Colors.white,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC107).applyOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.language,
                            color: Color(0xFFFFC107)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          lang['name']!.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0E1B45),
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFFFFC107),
                          size: 24,
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
