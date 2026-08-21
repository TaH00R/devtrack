import 'package:flutter/material.dart';

class DashboardProgressBar
    extends StatelessWidget {
  final double value;
  final Color color;

  const DashboardProgressBar({
    super.key,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(10),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: 8,
        backgroundColor: Colors.white10,
        valueColor:
            AlwaysStoppedAnimation<Color>(
          color,
        ),
      ),
    );
  }
}