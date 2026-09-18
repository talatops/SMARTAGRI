import 'package:flutter/material.dart';

class DashboardFooter extends StatelessWidget {
  const DashboardFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF001827),
        border: Border(top: BorderSide(color: Color(0xFF075C82))),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 1100;

          return Row(
            children: [
              const Icon(Icons.sync, size: 22, color: Color(0xFF00E99A)),

              const SizedBox(width: 10),

              const Text(
                'Last Updated: 10:28:45 AM',
                style: TextStyle(color: Color(0xFFB5CAD6), fontSize: 12),
              ),

              const Spacer(),

              if (!compact) ...[
                const Icon(Icons.eco, color: Color(0xFF00E99A)),
                const SizedBox(width: 7),
                const Text(
                  'Smart Agriculture System',
                  style: TextStyle(color: Color(0xFFB5CAD6), fontSize: 12),
                ),
                const SizedBox(width: 12),
                const Text('|', style: TextStyle(color: Color(0xFF075C82))),
                const SizedBox(width: 12),
              ],

              const Text(
                'v1.0.0',
                style: TextStyle(color: Color(0xFFB5CAD6), fontSize: 12),
              ),
            ],
          );
        },
      ),
    );
  }
}
