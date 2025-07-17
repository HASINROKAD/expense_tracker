import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';

class DynamicTextRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const DynamicTextRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? TColors.textSecondaryDark
                      : Colors.black87,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
          ),
        ],
      ),
    );
  }
}
