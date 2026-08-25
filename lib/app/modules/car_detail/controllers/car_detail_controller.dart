import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/widgets/app_snack_bar.dart';
import 'package:mrwah/app/modules/home/domain/entities/car_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class CarDetailController extends GetxController {
  late CarEntity car;

  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is CarEntity) {
      car = arg;
    } else {
      throw Exception("Invalid car data passed to CarDetail");
    }
  }

  Future<void> makePhoneCall() async {
    final dialCode = car.owner?.dialCode ?? '';
    final mobile = car.owner?.mobile ?? '';

    if (mobile.isEmpty) {
      AppSnackBar.error(
        "Phone number not available",
      );
      return;
    }

    final phoneNumber = '+$dialCode$mobile';
    final Uri phoneUri = Uri.parse('tel:$phoneNumber');

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      AppSnackBar.error(
        "Could not launch phone app",
      );
    }
  }

  // 💬 WhatsApp function
  Future<void> openWhatsApp() async {
    final dialCode = car.owner?.dialCode ?? '';
    final mobile = car.owner?.mobile ?? '';

    if (mobile.isEmpty) {
      AppSnackBar.error(
        'WhatsApp number not available',
      );
      return;
    }

    final phoneNumber = '$dialCode$mobile';
    final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      AppSnackBar.error(
        'Could not open WhatsApp',
      );
    }
  }
}
