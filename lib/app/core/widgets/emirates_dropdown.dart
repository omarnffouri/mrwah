import 'package:flutter/material.dart';

class EmiratesDropdown extends StatelessWidget {
  final String? selectedValue;
  final List<String> items;
  final Function(String?) onChanged;

  const EmiratesDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: (selectedValue != null && selectedValue!.isNotEmpty)
              ? selectedValue
              : null,
          isExpanded: true,
          hint: Text(
            selectedValue == null || selectedValue!.isEmpty
                ? "Select Emirate"
                : selectedValue!,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          items: items.map((city) {
            return DropdownMenuItem<String>(
              value: city,
              child: Text(
                city,
                style: const TextStyle(
                  color: Color(0xFF0B1437),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
