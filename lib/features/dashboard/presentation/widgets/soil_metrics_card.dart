import 'package:flutter/material.dart';

import 'dashboard_section_card.dart';

class SoilMetricsCard extends StatelessWidget {
  const SoilMetricsCard({
    super.key,
    required this.soil5cm,
    required this.soil20cm,
    required this.soil40cm,
    required this.waterLevel,
  });

  final double soil5cm;
  final double soil20cm;
  final double soil40cm;
  final double waterLevel;

  @override
  Widget build(BuildContext context) {
    return DashboardSectionCard(
      title: 'Soil & Field Water Metrics',
      subtitle: 'Real-time soil moisture levels and field water status',
      icon: Icons.eco,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final twoColumns = constraints.maxWidth < 480;

          if (twoColumns) {
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: .9,
              children: _items,
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _MoistureTile(
                  icon: Icons.water,
                  title: 'Surface Zone',
                  depth: '5 cm',
                  value: soil5cm,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MoistureTile(
                  icon: Icons.grass,
                  title: 'Root Zone',
                  depth: '20 cm',
                  value: soil20cm,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MoistureTile(
                  icon: Icons.nature,
                  title: 'Deep Zone',
                  depth: '40 cm',
                  value: soil40cm,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(child: _WaterTile(value: waterLevel)),
            ],
          );
        },
      ),
    );
  }

  List<Widget> get _items => [
    _MoistureTile(
      icon: Icons.water,
      title: 'Surface Zone',
      depth: '5 cm',
      value: soil5cm,
    ),
    _MoistureTile(
      icon: Icons.grass,
      title: 'Root Zone',
      depth: '20 cm',
      value: soil20cm,
    ),
    _MoistureTile(
      icon: Icons.nature,
      title: 'Deep Zone',
      depth: '40 cm',
      value: soil40cm,
    ),
    _WaterTile(value: waterLevel),
  ];
}

class _MoistureTile extends StatelessWidget {
  const _MoistureTile({
    required this.icon,
    required this.title,
    required this.depth,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String depth;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 205),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF031927),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF075C82)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: const Color(0xFF35C9FF)),
          const SizedBox(height: 8),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          Text(
            '($depth)',
            style: const TextStyle(color: Color(0xFFB4C7D2), fontSize: 11),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: 75,
            height: 75,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: value / 100,
                  strokeWidth: 8,
                  backgroundColor: const Color(0xFF064164),
                  color: const Color(0xFF00D7FF),
                ),
                Text(
                  '${value.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Moisture Level',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFB4C7D2), fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _WaterTile extends StatelessWidget {
  const _WaterTile({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 205),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF031927),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF075C82)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.water_drop, size: 36, color: Color(0xFF00C8FF)),

          const SizedBox(height: 8),

          const Text(
            'Field Water Level',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            '${value.toStringAsFixed(0)} cm',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0x3300E99A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF00E99A)),
            ),
            child: const Text(
              '✓ Normal / OK',
              style: TextStyle(
                color: Color(0xFF00E99A),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
