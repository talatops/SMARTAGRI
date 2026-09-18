import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF001827),
        border: Border(bottom: BorderSide(color: Color(0xFF075C82))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 1150;

          return Row(
            children: [
              const Icon(Icons.eco, size: 42, color: Color(0xFF00E99A)),

              const SizedBox(width: 12),

              const Text(
                'Smart Agriculture',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(width: 6),

              const Text(
                'System',
                style: TextStyle(
                  color: Color(0xFF00E99A),
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),

              if (!compact) ...[
                const SizedBox(width: 24),

                Container(width: 1, height: 32, color: const Color(0xFF00A5CF)),

                const SizedBox(width: 24),

                const Text(
                  'Smarter Water   •   Healthier Crops   •   Higher Yields',
                  style: TextStyle(color: Color(0xFFC3D1DA), fontSize: 12),
                ),
              ],

              const Spacer(),

              if (!compact)
                const Row(
                  children: [
                    Icon(Icons.calendar_month, color: Color(0xFF35C9FF)),
                    SizedBox(width: 8),
                    Text('Sep 09, 2026', style: TextStyle(color: Colors.white)),
                    SizedBox(width: 16),
                    Text('|', style: TextStyle(color: Color(0xFF35C9FF))),
                    SizedBox(width: 16),
                    Icon(Icons.access_time, color: Color(0xFF35C9FF)),
                    SizedBox(width: 8),
                    Text('10:30 AM', style: TextStyle(color: Colors.white)),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
