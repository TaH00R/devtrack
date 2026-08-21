import 'package:devtrack/features/profile/widgets/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoutCard extends StatelessWidget {
  final Future<void> Function() onLogout;

  const LogoutCard({
    super.key,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,

        leading: const Icon(
          Icons.logout,
          color: Color(0xffFF8BA7),
        ),

        title: Text(
          'LOGOUT',
          style:
              GoogleFonts.jetBrainsMono(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),

        onTap: onLogout,
      ),
    );
  }
}