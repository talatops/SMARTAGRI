import 'package:flutter/material.dart';

import 'dashboard_section_card.dart';

class IrrigationControlCard extends StatelessWidget {
  const IrrigationControlCard({
    super.key,
    required this.mode,
    required this.pumpStatus,
    required this.pumpCommand,
    required this.onPumpChanged,
    required this.onModeChanged,
  });

  final String mode;
  final bool pumpStatus;
  final bool pumpCommand;

  final ValueChanged<bool> onPumpChanged;
  final ValueChanged<String> onModeChanged;

  @override
  Widget build(BuildContext context) {
    final autoMode = mode == 'AUTO';

    return DashboardSectionCard(
      title: 'Irrigation Control',
      subtitle: 'Manage pump and irrigation settings',
      icon: Icons.settings,
      child: Column(
        children: [
          Container(
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF053552),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: const Color(0xFF0877A6)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _ModeButton(
                    label: 'AUTO',
                    selected: autoMode,
                    onTap: () => onModeChanged('AUTO'),
                  ),
                ),
                Expanded(
                  child: _ModeButton(
                    label: 'MANUAL',
                    selected: !autoMode,
                    onTap: () => onModeChanged('MANUAL'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          LayoutBuilder(
            builder: (context, constraints) {
              final vertical = constraints.maxWidth < 340;

              final pump = _PumpButton(
                pumpStatus: pumpStatus,
                pumpCommand: pumpCommand,
                enabled: !autoMode,
                onChanged: onPumpChanged,
              );

              final status = _PumpStatus(pumpStatus: pumpStatus);

              if (vertical) {
                return Column(
                  children: [pump, const SizedBox(height: 16), status],
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: pump),

                  const SizedBox(width: 16),

                  Expanded(child: status),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFF00A8F3), Color(0xFF00D7FF)],
                )
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF98C6E6),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _PumpButton extends StatelessWidget {
  const _PumpButton({
    required this.pumpStatus,
    required this.pumpCommand,
    required this.enabled,
    required this.onChanged,
  });

  final bool pumpStatus;
  final bool pumpCommand;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: enabled ? () => onChanged(!pumpCommand) : null,
        child: Container(
          width: 145,
          height: 145,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF031927),
            border: Border.all(
              color: pumpStatus
                  ? const Color(0xFF00E99A)
                  : const Color(0xFF00C8FF),
              width: 5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.power_settings_new,
                size: 48,
                color: pumpStatus
                    ? const Color(0xFF00E99A)
                    : const Color(0xFF9CCEF1),
              ),

              const SizedBox(height: 8),

              Text(
                pumpStatus ? 'PUMP ON' : 'PUMP OFF',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PumpStatus extends StatelessWidget {
  const _PumpStatus({required this.pumpStatus});

  final bool pumpStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF031927),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF075C82)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.circle,
                size: 15,
                color: pumpStatus
                    ? const Color(0xFF00E99A)
                    : const Color(0xFF6B8090),
              ),
              const SizedBox(width: 7),
              const Text('Status:', style: TextStyle(color: Colors.white)),
            ],
          ),

          const SizedBox(height: 5),

          Text(
            pumpStatus ? 'ON' : 'OFF',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            pumpStatus
                ? 'Pump is currently running'
                : 'Pump is currently disabled',
            style: const TextStyle(color: Color(0xFFB5CAD6), fontSize: 11),
          ),
        ],
      ),
    );
  }
}
