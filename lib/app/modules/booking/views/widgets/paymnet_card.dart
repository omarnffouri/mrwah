import 'package:flutter/material.dart';

class PaymnetCard extends StatelessWidget {
  const PaymnetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.credit_card, color: Colors.orange, size: 40),
              Icon(Icons.credit_card, color: Colors.white, size: 40),
            ],
          ),
          Text(
            "BANJAMIN JACK",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            "9655   9655   9655   9655",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 2,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Expire: 10-5-2030",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
