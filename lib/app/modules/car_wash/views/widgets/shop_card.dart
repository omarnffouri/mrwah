import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/helpers/extensions.dart';
import 'package:mrwah/app/core/resources/app_colors.dart';
import 'package:mrwah/app/modules/shop_detail/domain/entites/car_wash_entity.dart';
import 'package:mrwah/app/routes/app_pages.dart';
import 'package:mrwah/app/services/storage_service.dart';

class ShopCard extends StatelessWidget {
  final CarWashShopEntity shop;

  const ShopCard({
    super.key,
    required this.shop,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => shop.isBusyValue
          ? null
          : Get.toNamed(Routes.SHOP_DETAIL, arguments: shop),
      child: Directionality(
        textDirection: Localizations.localeOf(context).languageCode == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Container(
          width: 280,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.applyOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                /// Background Image
                Image.network(
                  shop.image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),

                /// Dark overlay (for better text readability)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.applyOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                if (shop.isBusyValue)
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black.applyOpacity(0.55),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.bgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "This shop is currently busy",
                          style: TextStyle(
                            color: AppColors.mainColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                /// Rating badge (top-right)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          shop.rating.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.bgColor),
                        ),
                      ],
                    ),
                  ),
                ),

                PositionedDirectional(
                  start: !StorageService.isArabic ? 12 : null,
                  end: StorageService.isArabic ? 12 : null,
                  bottom: 12,
                  child: Column(
                    crossAxisAlignment: !StorageService.isArabic
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      Text(
                        shop.name,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            shop.state,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
