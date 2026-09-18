import 'package:flutter/material.dart';

import 'dashboard_section_card.dart';

class WeatherStatusCard extends StatelessWidget {
  const WeatherStatusCard({
    super.key,
    required this.temperature,
    required this.rainProbability,
    required this.isRaining,
  });

  final double temperature;
  final double rainProbability;
  final bool isRaining;

  @override
  Widget build(BuildContext context) {
    return DashboardSectionCard(
      title: 'Weather Status',
      subtitle: 'External weather forecast',
      icon: Icons.cloud,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Text(
                        '${temperature.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      isRaining ? 'Raining' : 'No Rain',
                      style: const TextStyle(
                        color: Color(0xFF35C9FF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                isRaining ? Icons.cloudy_snowing : Icons.wb_cloudy,
                size: 60,
                color: isRaining
                    ? const Color(0xFF35C9FF)
                    : const Color(0xFFFFC52B),
              ),
            ],
          ),

          const SizedBox(height: 15),

          const Divider(color: Color(0xFF075C82)),

          const SizedBox(height: 10),

          _WeatherMetric(
            icon: Icons.water_drop,
            value: '${rainProbability.toStringAsFixed(0)}%',
            label: 'Rain Forecast',
          ),
        ],
      ),
    );
  }
}

class _WeatherMetric extends StatelessWidget {
  const _WeatherMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF00D7FF), size: 30),

        const SizedBox(height: 5),

        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          label,
          style: const TextStyle(color: Color(0xFFB5CAD6), fontSize: 11),
        ),
      ],
    );
  }
}
