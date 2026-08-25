import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mrwah/app/core/helpers/location_picker.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/core/widgets/app_button.dart';
import 'package:mrwah/app/modules/partner_program/controllers/partner_program_controller.dart';

void showPartnerLocationBottomSheet(PartnerProgramController controller) {
  showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: Get.height * .8),
      builder: (context) {
        return PartnerLocationBottomSheetContent(
          controller: controller,
        );
      },
      isDismissible: false,
      enableDrag: false,
      showDragHandle: false,
      backgroundColor: Colors.transparent);
}

class PartnerLocationBottomSheetContent extends StatelessWidget {
  final PartnerProgramController controller;
  const PartnerLocationBottomSheetContent(
      {super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.h),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
          color: Colors.white),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.close_rounded,
                color: Colors.black,
                size: 24,
              ),
            ),
            SizedBox(
              height: 14.h,
            ),
            Obx(() => Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    controller.locationAddress.value,
                    style: TextStyle(
                        fontSize: 15,
                        color: AppColors.bgColor,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
            const SizedBox(height: 16),
            Obx(
              () => MapPicker(
                // pass icon widget
                iconWidget: controller.isMapLoading.value
                    ? const SizedBox.shrink()
                    : const Icon(
                        Icons.location_pin,
                        size: 40,
                        color: Colors.red,
                      ),
                //add map picker controller
                mapPickerController: controller.mapPickerController,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: Get.height * 0.55,
                    child: controller.isMapLoading.value
                        ? Center(
                            child: SpinKitSpinningLines(
                              color: AppColors.bgColor,
                              size: 28,
                            ),
                          )
                        : GoogleMap(
                            myLocationEnabled: true,
                            zoomControlsEnabled: true,
                            // hide location button
                            myLocationButtonEnabled: true,

                            mapToolbarEnabled: true,
                            mapType: MapType.normal,
                            //  camera position
                            initialCameraPosition: controller.cameraPosition,
                            onMapCreated: (GoogleMapController controller) {
                              // _controller.complete(controller);
                            },
                            onCameraMoveStarted: () {
                              // notify map is moving
                              controller.mapPickerController.mapMoving!();
                              controller.locationAddress.value = "checking ...";
                            },
                            onCameraMove: (cameraPosition) {
                              controller.cameraPosition = cameraPosition;
                            },
                            onCameraIdle: () async {
                              // notify map stopped moving
                              controller
                                  .mapPickerController.mapFinishedMoving!();

                              controller.selectedLat =
                                  controller.cameraPosition.target.latitude;
                              controller.selectedLng =
                                  controller.cameraPosition.target.longitude;
                              //get address name from camera position
                              List<Placemark> placemarks =
                                  await placemarkFromCoordinates(
                                controller.cameraPosition.target.latitude,
                                controller.cameraPosition.target.longitude,
                              );

                              // update the ui with the address
                              controller.locationAddress.value =
                                  '${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';
                            },
                          ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            AppButton(
                text: "submit".tr,
                onPressed: () {
                  controller.confirmLocation();
                  Get.back();
                }),
          ],
        ),
      ),
    );
  }
}
