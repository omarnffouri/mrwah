import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mrwah/app/core/helpers/location_picker.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/core/widgets/app_snack_bar.dart';
import 'package:mrwah/app/core/widgets/gallery_camera_widget.dart';
import 'package:mrwah/app/modules/booking/domain/entites/booking_car_entity.dart';
import 'package:mrwah/app/modules/booking/domain/usecases/create_booking_usecase.dart';
import 'package:mrwah/app/modules/booking/views/widgets/location_sheet_picker.dart';
import 'package:mrwah/app/modules/booking/views/widgets/payment_webview.dart';
import 'package:mrwah/app/modules/login/presentation/controllers/login_controller.dart';
import 'package:mrwah/app/services/injection_service.dart';
import 'package:mrwah/app/services/payment_link_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class BookingController extends GetxController {
  /// current step index
  var currentStep = 0.obs;
  final user = Get.find<LoginController>().user;
  String carName = '';
  String carModel = '';
  String carImage = '';
  double carPrice = 0;

  MapPickerController mapPickerController = MapPickerController();

  double selectedLat = 0;
  double selectedLng = 0;

  final userLocation = TextEditingController();
  final fullName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();

  var deliverToMe = false.obs;
  var bookCarInOffice = true.obs;

  // File variables
  var idFront = Rx<File?>(null);
  var idBack = Rx<File?>(null);
  var license = Rx<File?>(null);

  final int totalSteps = 2;

  final createBookingUseCase = sl<CreateBookingUseCase>();

  var bookWithDriver = false.obs;
  var gender = "Male".obs;
  var paymentType = "Cash Payment".obs;
  var rentalType = "Day".obs;
  var pickupDate = "".obs;
  var returnDate = "".obs;

  final locationAddress = "".obs;
  final RxBool isMapLoading = false.obs;

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(41.311158, 69.279737),
    zoom: 14.4746,
  );

  var lat = 0.0.obs;
  var lng = 0.0.obs;

  late final int carId;
  var isLoading = false.obs;

  double get total => carPrice + 15;

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;

    if (args != null) {
      carId = args['carId'];
      carName = args['carName'] ?? '';
      carModel = args['carModel'] ?? '';
      carImage = args['carImage'] ?? '';
      carPrice = args['carPrice'] ?? '';
    }

    preFillData();
  }

  void confirmLocation() {
    userLocation.text = locationAddress.value;
    lat.value = selectedLat;
    lng.value = selectedLng;
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);
  }

  void preFillData() {
    fullName.text = "${user.value.firstname} ${user.value.lastname}";
    email.text = user.value.email ?? '';
    phoneNumber.text = user.value.mobile ?? '';
  }

  Future<void> requestPermissions() async {
    if (Platform.isIOS) {
      await Permission.photos.request();
    } else {
      await Permission.storage.request();
    }
  }

  void openLocationPickerBottomSheet() async {
    showLocationBottomSheet(this);

    isMapLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 500));

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best, // replaces desiredAccuracy
        distanceFilter: 0,
      ),
    );

    cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 16,
    );

    isMapLoading.value = false;
  }

  /// 📸 Pick image
  Future<void> pickImage(Rx<File?> fileObs, String sourceLabel) async {
    await requestPermissions();
    final picker = ImagePicker();
    await Get.bottomSheet(
      GalleryCameraWidget(
        picker: picker,
        fileObs: fileObs,
        sourceLabel: sourceLabel,
      ),
    );
  }

  void nextStep() {
    if (currentStep.value == 0) {
      if (!formKey.currentState!.validate()) {
        return;
      }

      if (idFront.value == null) {
        AppSnackBar.info(
          "Please upload your Emirates ID (front side)",
        );

        return;
      }
      if (idBack.value == null) {
        AppSnackBar.info(
          "Please upload your Emirates ID (back side)",
        );
        return;
      }
      if (license.value == null) {
        AppSnackBar.info(
          "Please upload your driving license",
        );
        return;
      }

      if (pickupDate.value.isEmpty) {
        AppSnackBar.info(
          "Please select a pickup date",
        );
        return;
      }
      if (returnDate.value.isEmpty) {
        AppSnackBar.info(
          "Please select a return date",
        );
        return;
      }
    }

    if (currentStep.value < totalSteps - 1) {
      currentStep.value++;
    }
  }

  void updateRentalType(String type) {
    rentalType.value = type;
    pickupDate.value = "";
    returnDate.value = "";
  }

  Future<void> submitBooking(BuildContext context) async {
    if (isLoading.value) return;

    isLoading.value = true;

    final entity = BookingCarEntity(
      fullName: fullName.text,
      email: email.text,
      contact: phoneNumber.text,
      gender: gender.value,
      rentalType: rentalType.value,
      pickupDate: formatDateTime(_parseDate(pickupDate.value)),
      returnDate: formatDateTime(_parseDate(returnDate.value)),
      bookCarInOffice: bookCarInOffice.value,
      idFrontPath: idFront.value?.path,
      idBackPath: idBack.value?.path,
      licensePath: license.value?.path,
      lat: lat.value,
      lng: lng.value,
    );

    final result = await createBookingUseCase(carId, entity);
    isLoading.value = false;

    result.fold(
      (paymentUrl) async {
        // Cache the payment link so it can be reused in the bookings list
        PaymentLinkStorage.saveFromUrl(paymentUrl);

        await Future.delayed(const Duration(milliseconds: 100));
        Get.to(() => PaymentWebView(
              url: paymentUrl,
              bookingType: "car",
              bookingName: carName,
              rentalDate:
                  "${pickupDate.value.isEmpty ? '' : pickupDate.value} - ${returnDate.value.isEmpty ? '' : returnDate.value}",
              amount: "${carPrice.toString()} AED",
              total: "${total.toString()} AED",
            ));
      },
      (failure) async {
        await Future.delayed(const Duration(milliseconds: 200));
        AppSnackBar.error(
          failure.message,
        );
      },
    );
  }

  void previousStep() {
    if (currentStep.value > 0) currentStep.value--;
  }

  void goToStep(int step) {
    if (step >= 0 && step < totalSteps) currentStep.value = step;
  }

  Future<void> pickDate(BuildContext context, {required bool isPickup}) async {
    final selectedRentalType = rentalType.value;

    if ((selectedRentalType == "Weekly" || selectedRentalType == "Monthly") &&
        !isPickup) {
      if (pickupDate.value.isEmpty) {
        AppSnackBar.info("Please select a pickup date first");
      } else {
        AppSnackBar.info(selectedRentalType == "Weekly"
            ? "Return date is auto-set 7 days after pickup"
            : "Return date is auto-set one month after pickup");
      }
      return;
    }

    final now = DateTime.now();
    final DateTime parsedPickup =
        pickupDate.value.isNotEmpty ? _parseDate(pickupDate.value) : now;
    final DateTime firstAllowedDate = isPickup
        ? DateTime(now.year, now.month, now.day)
        : parsedPickup;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isPickup
          ? now
          : (pickupDate.value.isNotEmpty
              ? parsedPickup.add(const Duration(days: 1))
              : now),
      firstDate: firstAllowedDate,
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.bgColor,
              onPrimary: Colors.white,
              onSurface: AppColors.bgColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.bgColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (selectedRentalType == "Weekly") {
        pickupDate.value = _formatDate(picked);
        returnDate.value = _formatDate(picked.add(const Duration(days: 6)));
        return;
      }

      if (selectedRentalType == "Monthly") {
        pickupDate.value = _formatDate(picked);
        final DateTime endOfMonthRental =
            DateTime(picked.year, picked.month + 1, picked.day)
                .subtract(const Duration(days: 1));
        returnDate.value = _formatDate(endOfMonthRental);
        return;
      }

      if (isPickup) {
        pickupDate.value = _formatDate(picked);
        if (returnDate.value.isNotEmpty &&
            _parseDate(returnDate.value).isBefore(picked)) {
          returnDate.value = "";
        }
      } else {
        returnDate.value = _formatDate(picked);
      }
    }
  }

  String _formatDate(DateTime dateTime) =>
      "${dateTime.day}/${dateTime.month}/${dateTime.year}";

  DateTime _parseDate(String dateString) {
    final parts = dateString.split('/');
    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }
}
