import 'package:flutter/material.dart';

import 'composite_moisture_card.dart';
import 'crop_profile_card.dart';
import 'field_telemetry_card.dart';
import 'irrigation_control_card.dart';
import 'soil_metrics_card.dart';
import 'weather_status_card.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 38,
          child: Column(
            children: [
              SoilMetricsCard(
                soil20cm: 20,
                soil40cm: 40,
                soil5cm: 5,
                waterLevel: 50,
              ),

              SizedBox(height: 16),

              CompositeMoistureCard(moisture: 10, status: "AUTO"),
            ],
          ),
        ),

        SizedBox(width: 16),

        Expanded(
          flex: 29,
          child: Column(
            children: [
              FieldTelemetryCard(humidity: 5, temperature: 22),

              SizedBox(height: 16),

              IrrigationControlCard(
                mode: 'AUTO',
                pumpStatus: false,
                pumpCommand: false,
                onPumpChanged: (value) {
                  // Riverpod command here
                },
                onModeChanged: (mode) {
                  // Riverpod command here
                },
              ),
            ],
          ),
        ),

        SizedBox(width: 16),

        Expanded(
          flex: 33,
          child: Column(
            children: [
              WeatherStatusCard(
                temperature: 28.5,
                rainProbability: 15,
                isRaining: true,
              ),

              SizedBox(height: 16),
              CropProfileCard(selectedCrop: 'Wheat'),
            ],
          ),
        ),
      ],
    );
  }
}
