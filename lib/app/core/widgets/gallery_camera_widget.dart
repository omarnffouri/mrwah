import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';

class GalleryCameraWidget extends StatelessWidget {
  final ImagePicker picker;
  final Rx<File?> fileObs;
  final String sourceLabel;
  final void Function(File file)? onPicked;
  const GalleryCameraWidget(
      {super.key,
      required this.picker,
      required this.fileObs,
      required this.sourceLabel,
      this.onPicked});

  Future<void> _handlePick(ImageSource source) async {
    final picked = await picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) {
      final file = File(picked.path);
      fileObs.value = file;
      if (onPicked != null) onPicked!(file);
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          ListTile(
            leading: Icon(
              Icons.camera_alt,
              color: AppColors.bgColor,
            ),
            title: Text(
              'take_photo'.tr,
              style: TextStyle(
                color: AppColors.bgColor,
              ),
            ),
            onTap: () => _handlePick(ImageSource.camera),
          ),
          ListTile(
            leading: Icon(
              Icons.photo_library,
              color: AppColors.bgColor,
            ),
            title: Text(
              'choose_from_gallery'.tr,
              style: TextStyle(
                color: AppColors.bgColor,
              ),
            ),
            onTap: () => _handlePick(ImageSource.gallery),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.close),
            title: Text('cancel'.tr),
            onTap: () => Get.back(),
          ),
        ],
      ),
    );
  }
}
