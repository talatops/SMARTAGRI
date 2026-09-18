import 'package:flutter/material.dart';

import 'dashboard_section_card.dart';

class CropProfileCard extends StatelessWidget {
  const CropProfileCard({super.key, required this.selectedCrop});

  final String selectedCrop;

  static const crops = {
    'Wheat': '40% – 70%',
    'Rice': '60% – 85%',
    'Cotton': '35% – 65%',
    'Sugarcane': '50% – 80%',
    'Maize': '45% – 75%',
  };

  @override
  Widget build(BuildContext context) {
    return DashboardSectionCard(
      title: 'Crop Profile',
      subtitle: 'Select active crop type',
      icon: Icons.eco,
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            initialValue: selectedCrop,
            dropdownColor: const Color(0xFF031E2E),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.grass, color: Color(0xFFFFC52B)),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF0877A6)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF00D7FF)),
              ),
            ),
            items: crops.keys.map((crop) {
              return DropdownMenuItem(value: crop, child: Text(crop));
            }).toList(),
            onChanged: (value) {
              // Riverpod command
            },
          ),

          const SizedBox(height: 12),

          const Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Crop',
                    style: TextStyle(color: Color(0xFFA8D8F3)),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Acceptable Moisture Range',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFA8D8F3), fontSize: 11),
                ),
              ),
            ],
          ),

          ...crops.entries.map((entry) {
            final selected = entry.key == selectedCrop;

            return _CropRow(
              crop: entry.key,
              range: entry.value,
              selected: selected,
            );
          }),
        ],
      ),
    );
  }
}

class _CropRow extends StatelessWidget {
  const _CropRow({
    required this.crop,
    required this.range,
    required this.selected,
  });

  final String crop;
  final String range;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      decoration: BoxDecoration(
        color: selected ? const Color(0x2200E99A) : const Color(0xFF031927),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: selected ? const Color(0xFF00E99A) : const Color(0xFF075C82),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              child: Row(
                children: [
                  const Icon(Icons.grass, size: 18, color: Color(0xFFFFC52B)),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      crop,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(width: 1, height: 40, color: const Color(0xFF075C82)),

          Expanded(
            child: Text(
              range,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}


