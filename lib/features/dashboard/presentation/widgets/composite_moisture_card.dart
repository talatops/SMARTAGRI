import 'package:flutter/material.dart';

import 'dashboard_section_card.dart';

class CompositeMoistureCard extends StatelessWidget {
  const CompositeMoistureCard({
    super.key,
    required this.moisture,
    required this.status,
  });

  final double moisture;
  final String status;

  @override
  Widget build(BuildContext context) {
    return DashboardSectionCard(
      title: 'Composite Soil Moisture',
      subtitle: 'Calculated from all depth sensors',
      icon: Icons.water_drop,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final vertical = constraints.maxWidth < 420;

          final gauge = SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: moisture / 100,
                    strokeWidth: 12,
                    backgroundColor: const Color(0xFF05466B),
                    color: const Color(0xFF00D7FF),
                  ),
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${moisture.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Text(
                      'Composite Score',
                      style: TextStyle(color: Color(0xFFD0DDE4), fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          );

          final detail = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF00E99A)),
                  borderRadius: BorderRadius.circular(25),
                  color: const Color(0x1100E99A),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.eco, color: Color(0xFF00E99A)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'Soil moisture level is within optimal range for healthy crop growth.',
                style: TextStyle(color: Color(0xFFD0DDE4), height: 1.45),
              ),
            ],
          );

          if (vertical) {
            return Column(
              children: [gauge, const SizedBox(height: 16), detail],
            );
          }

          return Row(
            children: [
              gauge,
              const SizedBox(width: 20),
              Expanded(child: detail),
            ],
          );
        },
      ),
    );
  }
}
