import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/helpers/extensions.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import '../controllers/bookings_controller.dart';

class BookingsView extends GetView<BookingsController> {
  const BookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1437),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "my_bookings".tr,
                    style: TextStyle(
                      color: AppColors.mainColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('assets/images/main_bg.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Obx(() {
                  // Initial loading
                  if (controller.isLoading.value &&
                      controller.bookings.isEmpty) {
                    return Center(
                      child: SpinKitSpinningLines(
                        color: AppColors.bgColor,
                        size: 28,
                      ),
                    );
                  }

                  // Empty state
                  if (controller.bookings.isEmpty) {
                    return const Center(
                      child: Text(
                        "No bookings yet",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.mainColor,
                    backgroundColor: Colors.white,
                    onRefresh: () async {
                      controller.page.value = 1;
                      await controller.fetchBookings();
                    },
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!controller.isLastPage.value &&
                            !controller.isLoading.value &&
                            scrollInfo.metrics.pixels >=
                                scrollInfo.metrics.maxScrollExtent - 40) {
                          controller.loadMore();
                        }
                        return false;
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: controller.bookings.length +
                            (controller.isLastPage.value ? 0 : 1),
                        itemBuilder: (context, index) {
                          // Pagination loading indicator
                          if (index == controller.bookings.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: SpinKitSpinningLines(
                                color: AppColors.bgColor,
                                size: 28,
                              ),
                            );
                          }

                          final booking = controller.bookings[index];
                          final imageUrl =
                              (booking.vehicle?.images.isNotEmpty ?? false)
                                  ? booking.vehicle!.images.first
                                  : null;
                          final statusText = booking.statusText;
                          final isPending =
                              statusText.toLowerCase() == 'pending';
                          final canPayNow = isPending;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.mainColor,
                                width: 1,
                              ),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.applyOpacity(0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                /// Car Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child:
                                      (imageUrl != null && imageUrl.isNotEmpty)
                                          ? Image.network(
                                              imageUrl,
                                              width: 90,
                                              height: 70,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, e, ___) {
                                                print('Image load error: $e');
                                                return _placeholderImage();
                                              },
                                            )
                                          : _placeholderImage(),
                                ),
                                const SizedBox(width: 12),

                                /// Booking Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        booking.vehicle?.name ?? '',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.bgColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${'date'.tr}: ${booking.dateRangeOnly}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.bgColor,
                                        ),
                                      ),
                                      Text(
                                        "${'price'.tr}: ${booking.cleanPrice}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.bgColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                /// Status
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.mainColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        statusText.toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    if (canPayNow) ...[
                                      const SizedBox(height: 8),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: AppColors.bgColor,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 6),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () =>
                                            controller.openPayment(booking),
                                        child: const Text(
                                          "Pay",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Placeholder for missing car image
  Widget _placeholderImage() {
    return Container(
      width: 90,
      height: 70,
      color: Colors.grey[200],
      child: Icon(
        Icons.car_rental,
        color: Colors.grey[400],
        size: 40,
      ),
    );
  }
}
