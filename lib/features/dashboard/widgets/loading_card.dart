import 'package:flutter/material.dart';

class LoadingCard extends StatelessWidget {
  final Color color;

  const LoadingCard({
    super.key,
    this.color = const Color(0xffB388FF),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: const Color(0xff1A1A1E),
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white10,
        ),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: color,
          strokeWidth: 2,
        ),
      ),
    );
  }
}