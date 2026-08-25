import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/helpers/extensions.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/modules/car_detail/controllers/car_detail_controller.dart';
import 'package:mrwah/app/modules/car_detail/views/widgets/image_slider.dart';
import 'package:mrwah/app/routes/app_pages.dart';

class CarDetailView extends GetView<CarDetailController> {
  const CarDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final car = controller.car;
    return Scaffold(
      backgroundColor: const Color(0xFF0B1437),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.applyOpacity(0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ImageSlider(
                    car: car,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 250,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage('assets/images/main_bg.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            car.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: AppColors.textColor,
                            ),
                          ),
                        ),
                        // Row(
                        //   children: [
                        //     const Icon(Icons.star,
                        //         color: Colors.orange, size: 22),
                        //     const SizedBox(width: 3),
                        //     Text(
                        //       '5.0',
                        //       style: TextStyle(
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.orange[800],
                        //         fontSize: 17,
                        //       ),
                        //     ),
                        //     const SizedBox(width: 3),
                        //     Text(
                        //       '(120)',
                        //       style: TextStyle(
                        //           color: AppColors.textColor, fontSize: 13),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                    child: Html(
                      data: car.details,
                      style: {
                        "body": Style(
                          color: Colors.grey[600],
                          fontSize: FontSize(15),
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                        ),
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(
                    thickness: 0.4,
                    endIndent: 12,
                    indent: 12,
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 21,
                          backgroundImage: NetworkImage(
                            car.owner?.profileImage ?? '',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          car.owner?.name ?? 'Car Shop',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor,
                              fontSize: 16),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.verified,
                            color: Colors.blue, size: 18),
                        const Spacer(),
                        // GestureDetector(
                        //     onTap: controller.makePhoneCall,
                        //     child: Icon(Icons.phone,
                        //         color: AppColors.mainColor, size: 22)),
                        // const SizedBox(width: 16),
                        // GestureDetector(
                        //   onTap: controller.openWhatsApp,
                        //   child: Icon(FontAwesomeIcons.whatsapp,
                        //       color: AppColors.mainColor, size: 22),
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  // Car Features Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: car.specifications?.length ?? 0,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.2,
                      ),
                      itemBuilder: (context, index) {
                        final specKey =
                            car.specifications!.keys.elementAt(index);
                        final specData = car.specifications![specKey];

                        final label = specData[1];
                        final value = specData[2];

                        final icon = _getIconForSpec(label);

                        return _FeatureBox(
                          icon: icon,
                          label: label,
                          value: value,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 26),
                  // Reviews
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 24),
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //         "Reviews (125)",
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 18,
                  //           color: AppColors.textColor,
                  //         ),
                  //       ),
                  //       const Spacer(),
                  //       Text(
                  //         "See All",
                  //         style: TextStyle(
                  //           color: AppColors.mainColor,
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 15,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 10),
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 24.0),
                  //   child: Column(
                  //     children: [
                  //       _ReviewCard(
                  //         name: "Mr. Jack",
                  //         rating: 5,
                  //         review:
                  //             "The rental car was clean, reliable, and the service was quick and efficient.",
                  //       ),
                  //       SizedBox(height: 8),
                  //       _ReviewCard(
                  //         name: "Robert",
                  //         rating: 5,
                  //         review:
                  //             "The rental car was clean, modern, and the service was quick and efficient.",
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          elevation: 1,
                        ),
                        onPressed: () {
                          Get.toNamed(Routes.BOOKING, arguments: {
                            'carId': car.id,
                            'carName': car.name,
                            'carPrice': car.price,
                            'carImage': (car.images.isNotEmpty)
                                ? car.images.first
                                : 'https://via.placeholder.com/150',
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "book_now".tr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 19),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_ios,
                                size: 20, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

IconData _getIconForSpec(String label) {
  switch (label.toLowerCase()) {
    case 'max speed':
      return Icons.speed;
    case 'engine output':
      return Icons.flash_on;
    case 'capacity':
      return Icons.event_seat;
    case 'advance':
      return Icons.auto_awesome;
    case 'single charge':
      return Icons.battery_charging_full;
    case 'cylindars':
      return Icons.settings;
    default:
      return Icons.info_outline;
  }
}

class _FeatureBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _FeatureBox({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.mainColor.applyOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.mainColor, size: 28),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 13,
              )),
          Text(
            value,
            style: TextStyle(
                color: AppColors.textColor,
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// class _ReviewCard extends StatelessWidget {
//   final String name;
//   final int rating;
//   final String review;

//   const _ReviewCard({
//     required this.name,
//     required this.rating,
//     required this.review,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.white,
//       elevation: 0.5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
//       child: Container(
//         decoration: BoxDecoration(
//             // color: Colors.white,
//             borderRadius: BorderRadius.circular(13),
//             border: Border.all(color: AppColors.mainColor)),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CircleAvatar(
//                 backgroundColor: AppColors.mainColor,
//                 child: Text(name[0],
//                     style: const TextStyle(
//                         color: Colors.white, fontWeight: FontWeight.bold)),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           name,
//                           style: TextStyle(
//                             color: AppColors.textColor,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(width: 6),
//                         const Icon(Icons.star, color: Colors.orange, size: 15),
//                         Text(
//                           "$rating.0",
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.orange),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       review,
//                       style:
//                           TextStyle(color: AppColors.textColor, fontSize: 13.7),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
