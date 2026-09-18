import 'package:flutter/material.dart';

import 'dashboard_section_card.dart';

class FieldTelemetryCard extends StatelessWidget {
  const FieldTelemetryCard({
    super.key,
    required this.temperature,
    required this.humidity,
  });

  final double temperature;
  final double humidity;

  @override
  Widget build(BuildContext context) {
    return DashboardSectionCard(
      title: 'Field Telemetry',
      subtitle: 'Live microclimate data from on-board sensors',
      icon: Icons.bar_chart,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final vertical = constraints.maxWidth < 300;

          final items = [
            Expanded(
              child: _TelemetryTile(
                icon: Icons.thermostat,
                iconColor: const Color(0xFFFFC52B),
                title: 'Temperature',
                value: '${temperature.toStringAsFixed(1)}°C',
              ),
            ),
            Expanded(
              child: _TelemetryTile(
                icon: Icons.water_drop,
                iconColor: const Color(0xFF00C8FF),
                title: 'Relative Humidity',
                value: '${humidity.toStringAsFixed(0)}%',
              ),
            ),
          ];

          if (vertical) {
            return Column(
              children: [
                items[0].child,
                const SizedBox(height: 10),
                items[1].child,
              ],
            );
          }

          return IntrinsicHeight(
            child: Row(
              children: [items[0], const SizedBox(width: 10), items[1]],
            ),
          );
        },
      ),
    );
  }
}

class _TelemetryTile extends StatelessWidget {
  const _TelemetryTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 205),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF031927),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF075C82)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 42),

          const SizedBox(height: 12),

          FittedBox(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 20),

          FittedBox(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 15),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0x2200E99A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '●  Normal',
              style: TextStyle(color: Color(0xFF00E99A)),
            ),
          ),
        ],
      ),
    );
  }
}
