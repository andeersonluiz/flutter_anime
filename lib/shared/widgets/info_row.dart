import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? labelWidget;
  final Widget? valueWidget;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.labelWidget,
    this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelWidget ??
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
          const SizedBox(width: 8),
          Expanded(
            child: valueWidget ?? Text(value),
          ),
        ],
      ),
    );
  }
}
