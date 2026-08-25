import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mrwah/app/core/helpers/location_picker.dart';
import 'package:mrwah/app/core/widgets/app_snack_bar.dart';
import 'package:mrwah/app/modules/partner_program/views/widgets/partner_location_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:mrwah/app/core/enums/service_type_enum.dart';
import 'package:mrwah/app/core/widgets/gallery_camera_widget.dart';
import 'package:mrwah/app/modules/register_stepper/domain/entites/register_params.dart';
import 'package:mrwah/app/routes/app_pages.dart';

class PartnerProgramController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // -------------------- FORM CONTROLLERS --------------------
  final formKey = GlobalKey<FormState>();
  final ownerFirstName = TextEditingController();
  final ownerLastName = TextEditingController();
  final email = TextEditingController();
  final contact = TextEditingController();
  final workshopName = TextEditingController();
  final userLocation = TextEditingController();

  // -------------------- ANIMATION --------------------
  late final AnimationController animController;
  late final Animation<Offset> slideAnim;

  // -------------------- OBSERVABLES --------------------
  final idFront = Rx<File?>(null);
  final idBack = Rx<File?>(null);
  final licenseFile = Rx<File?>(null);
  final isLoading = false.obs;

  final serviceType = Rx<ServiceType?>(null);
  final selectedEmirate = ''.obs;
  final locationAddress = "".obs;
  final RxBool isMapLoading = false.obs;

  //-------------------- LOCATION STUFF---------------
  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(41.311158, 69.279737),
    zoom: 14.4746,
  );

  var lat = 0.0.obs;
  var lng = 0.0.obs;

  MapPickerController mapPickerController = MapPickerController();

  double selectedLat = 0;
  double selectedLng = 0;

  // -------------------- EMIRATES DATA --------------------
  final emiratesApi = [
    "Dubai",
    "Abu Dhabi",
    "Sharjah",
    "Ajman",
    "Ras Al Khaimah",
    "Fujairah",
    "Umm Al Quwain",
  ];

  final emiratesUi = {
    "Dubai": "dubai".tr,
    "Abu Dhabi": "abu_dhabi".tr,
    "Sharjah": "sharjah".tr,
    "Ajman": "ajman".tr,
    "Ras Al Khaimah": "ras_al_khaimah".tr,
    "Fujairah": "fujairah".tr,
    "Umm Al Quwain": "umm_al_quwain".tr,
  };

  // -------------------- INIT --------------------
  @override
  void onInit() {
    super.onInit();
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.22),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animController,
        curve: Curves.easeOutCubic,
      ),
    );

    animController.forward();
  }

  @override
  void onClose() {
    animController.dispose();
    ownerFirstName.dispose();
    ownerLastName.dispose();
    email.dispose();
    contact.dispose();
    workshopName.dispose();
    userLocation.dispose();
    super.onClose();
  }

  // -------------------- IMAGE PICKING + COMPRESSION --------------------
  Future<void> pickImage(Rx<File?> target, String label) async {
    final picker = ImagePicker();
    await Get.bottomSheet(
      GalleryCameraWidget(
        picker: picker,
        fileObs: target,
        sourceLabel: label,
        onPicked: (File file) async {
          final compressed = await _compressImage(file);
          target.value = compressed;
        },
      ),
    );
  }

  Future<File> _compressImage(File file) async {
    try {
      final dir = await getTemporaryDirectory();
      final outPath = path.join(
        dir.path,
        'compressed_${path.basename(file.path)}',
      );

      File result = file;
      int quality = 90;

      while (result.lengthSync() > 1500000 && quality > 30) {
        final x = await FlutterImageCompress.compressAndGetFile(
          file.path,
          outPath,
          quality: quality,
        );

        if (x == null) break;

        result = File(x.path);
        quality -= 10;
      }

      return result;
    } catch (e) {
      return file;
    }
  }

  //---------------------LOCATION--------------------
  void openLocationPickerBottomSheet() async {
    showPartnerLocationBottomSheet(this);

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

  void confirmLocation() {
    userLocation.text = locationAddress.value;
    lat.value = selectedLat;
    lng.value = selectedLng;
  }

  // -------------------- SUBMIT --------------------
  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    if (serviceType.value == null) {
      AppSnackBar.info("Please select workshop type");
      return;
    }

    if (selectedEmirate.value.isEmpty) {
      AppSnackBar.info("Please select an Emirate");
      return;
    }

    if (idFront.value == null ||
        idBack.value == null ||
        licenseFile.value == null) {
      AppSnackBar.info(
        "Please upload all required documents",
        title: "Missing Fields",
      );
      return;
    }

    try {
      isLoading.value = true;

      final param = RegisterParam(
        firstName: ownerFirstName.text.trim(),
        lastName: ownerLastName.text.trim(),
        email: email.text.trim(),
        phone: contact.text.trim(),
        password: 'password',
        type: UserType.partner,
        businessName: workshopName.text.trim(),
        state: selectedEmirate.value,
        idFront: idFront.value,
        idBack: idBack.value,
        otherFile: licenseFile.value,
        late: lat.value,
        lang: lng.value,
        serviceType: serviceType.value!.apiValue,
      );

      // 🔐 SEND OTP ONLY
      await _sendOtp(param);
    } catch (e) {
      isLoading.value = false;
      AppSnackBar.error(e.toString());
    }
  }

  Future<void> _sendOtp(RegisterParam param) async {
    final firebasePhone = '+971${contact.text.trim()}';

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: firebasePhone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (_) {},
      verificationFailed: (e) {
        isLoading.value = false;
        AppSnackBar.error(e.message ?? 'OTP verification failed');
      },
      codeSent: (verificationId, _) {
        isLoading.value = false;

        // 👉 Navigate to SAME OTP screen
        Get.toNamed(
          Routes.OTP,
          arguments: {
            'verificationId': verificationId,
            'registerParam': param,
          },
        );
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }
}
