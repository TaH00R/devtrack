import 'package:flutter/material.dart';

class ProfileVerticalDivider
    extends StatelessWidget {
  const ProfileVerticalDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 1,
      margin:
          const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      color: Colors.white10,
    );
  }
}