import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/core/widgets/app_snack_bar.dart';
import 'package:mrwah/app/modules/booking/views/widgets/payment_webview.dart';
import 'package:mrwah/app/modules/shop_detail/domain/entites/car_wash_entity.dart';
import 'package:mrwah/app/modules/shop_detail/domain/usecases/create_car_wash_booking_usecase.dart';
import 'package:mrwah/app/services/injection_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopDetailController extends GetxController {
  final createCarWashBookingUsecase = sl<CreateCarWashBookingUsecase>();

  // UI state
  final RxBool isLoading = false.obs;
  final RxString selectedDateStr = ''.obs;
  final RxInt selectedMethodId = 2.obs;
  final formKey = GlobalKey<FormState>();

  // shop entity passed as argument
  late final CarWashShopEntity shop;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args != null && args is CarWashShopEntity) {
      shop = args;
    } else {}
  }

  /// Formats
  String formatForDisplay(DateTime dt) =>
      DateFormat('dd/MM/yyyy hh:mm a').format(dt);

  String formatForApi(DateTime dt) =>
      DateFormat('yyyy-MM-dd hh:mm a').format(dt);

  String selectedDateApi = '';

  /// Date-time picker
  Future<void> pickDateTime(BuildContext context) async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.mainColor,
              onPrimary: Colors.white,
              onSurface: AppColors.bgColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.mainColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0), // Prevent overflow
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              useMaterial3: false,
              colorScheme: ColorScheme.light(
                primary: AppColors.mainColor,
                onPrimary: Colors.white,
                onSurface: AppColors.bgColor,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.mainColor,
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (time == null) return;

    final picked =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);

    selectedDateStr.value =
        "${formatForDisplay(picked)} — ${formatForApi(picked)}";

    selectedDateApi = formatForApi(picked);
  }

  void openMap() async {
    final lat = shop.lat;
    final lng = shop.lng;

    final Uri googleUrl =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");

    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
    } else {
      AppSnackBar.error(
        "Could not open Google Maps.",
      );
    }
  }

  Future<void> submitBooking() async {
    if (isLoading.value) return;
    if (selectedDateApi.isEmpty) {
      AppSnackBar.info(
        "Please select booking date & time",
      );
      return;
    }

    try {
      isLoading.value = true;

      final res = await createCarWashBookingUsecase(
        shopId: shop.plan.id,
        bookingTime: selectedDateApi,
      );

      isLoading.value = false;

      res.fold((url) {
        Get.to(() => PaymentWebView(
              url: url,
              bookingType: "shop",
            ));
      }, (failure) {
        AppSnackBar.error(
          failure.message,
        );
      });
    } catch (e) {
      AppSnackBar.error(
        e.toString(),
      );
    }
  }
}
