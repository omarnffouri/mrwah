import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mrwah/app/core/helpers/extensions.dart';
import 'package:mrwah/app/modules/car_search/controllers/car_search_controller.dart';

class CarSearchView extends GetView<CarSearchController> {
  const CarSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f8fa),
      body: SafeArea(
        child: Column(
          children: [
            // AppBar section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.black, size: 24),
                    onPressed: () => Get.back(),
                  ),
                  const Spacer(),
                  const Text(
                    "Search",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.more_horiz, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Search Box and Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: "Search your dream car.....",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200)),
                    child: IconButton(
                        icon: const Icon(Icons.tune, color: Colors.black),
                        onPressed: () {}),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Brand Filter
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, i) {
                  final selected = controller.selectedBrand.value == i;
                  final brand = controller.brands[i];

                  return GestureDetector(
                    onTap: () => controller.selectBrand(i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: selected ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            brand['icon'] as IconData,
                            color: selected ? Colors.white : Colors.black,
                            size: 22,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            brand['label'].toString(),
                            style: TextStyle(
                                color: selected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (c, i) => const SizedBox(width: 8),
                itemCount: controller.brands.length,
              ),
            ),
            const SizedBox(height: 12),
            // Recommend For You
            Expanded(
              child: ListView(
                children: const [
                  _SectionTitle("Recommend For You"),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                            child: _CarCardSearch(
                          image:
                              "https://www.pngmart.com/files/22/BMW-M8-PNG-Photo.png",
                          name: "Tesla Model S",
                          rating: 5.0,
                          location: "Chicago, USA",
                          price: "\$100/Day",
                        )),
                        SizedBox(width: 10),
                        Expanded(
                            child: _CarCardSearch(
                          image: "https://pngimg.com/d/ferrari_PNG10600.png",
                          name: "Ferrari LaFerrari",
                          rating: 5.0,
                          location: "Washington DC",
                          price: "\$100/Day",
                        )),
                      ],
                    ),
                  ),
                  SizedBox(height: 14),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                            child: _CarCardSearch(
                          image:
                              "https://pngimg.com/d/lamborghini_PNG10609.png",
                          name: "Lamborghini Aventador",
                          rating: 4.9,
                          location: "Washington DC",
                          price: "\$100/Day",
                        )),
                        SizedBox(width: 10),
                        Expanded(
                            child: _CarCardSearch(
                          image: "https://pngimg.com/d/bmw_PNG1714.png",
                          name: "BMW GTS3 M2",
                          rating: 5.0,
                          location: "New York, USA",
                          price: "\$100/Day",
                        )),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  _SectionTitle("Our Popular Cars"),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                            child: _CarCardSmall(
                          image: "https://pngimg.com/d/ferrari_PNG10600.png",
                          name: "Ferrari LaFerrari",
                          rating: 5.0,
                          price: "\$100/Day",
                        )),
                        SizedBox(width: 10),
                        Expanded(
                            child: _CarCardSmall(
                          image:
                              "https://www.pngmart.com/files/22/BMW-M8-PNG-Photo.png",
                          name: "BMW M8",
                          rating: 5.0,
                          price: "\$100/Day",
                        )),
                      ],
                    ),
                  ),
                  SizedBox(height: 90),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 0),
        decoration: BoxDecoration(
          color: Colors.black.applyOpacity(0.95),
          borderRadius: BorderRadius.circular(28),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.home, color: Colors.white, size: 26),
            Icon(Icons.search, color: Colors.white, size: 26),
            Icon(Icons.mail_outline, color: Colors.white, size: 26),
            Icon(Icons.person_outline, color: Colors.white, size: 26),
          ],
        ),
      ),
    );
  }
}

// ----- Section Title Widget -----
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
      child: Row(
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Spacer(),
          Text("View All",
              style: TextStyle(
                  color: Colors.grey[700], fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ----- Car Card Widget -----
class _CarCardSearch extends StatelessWidget {
  final String image;
  final String name;
  final double rating;
  final String location;
  final String price;

  const _CarCardSearch({
    required this.image,
    required this.name,
    required this.rating,
    required this.location,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200)),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(
                  child: Image.network(image, height: 70, fit: BoxFit.contain),
                ),
                const Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 13,
                    child: Icon(Icons.favorite_border,
                        size: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 15),
                Text(rating.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.orange)),
              ],
            ),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey[600], size: 14),
                Text(location,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
            Row(
              children: [
                Text(price,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text("Book now",
                      style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ----- Small Car Card Widget -----
class _CarCardSmall extends StatelessWidget {
  final String image;
  final String name;
  final double rating;
  final String price;

  const _CarCardSmall({
    required this.image,
    required this.name,
    required this.rating,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Image.network(image, height: 48, width: 54, fit: BoxFit.contain),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13)),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 13),
                      Text(rating.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                              fontSize: 12)),
                    ],
                  ),
                  Text(price, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
