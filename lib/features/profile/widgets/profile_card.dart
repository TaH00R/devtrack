import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final Widget child;

  const ProfileCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xff1A1A1E),
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white10,
        ),
      ),
      child: child,
    );
  }
}