import 'package:devtrack/features/profile/widgets/profile_card.dart';
import 'package:devtrack/features/profile/widgets/profile_field.dart';
import 'package:devtrack/features/profile/widgets/profile_input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountCard extends StatelessWidget {
  final dynamic user;
  final bool editingDisplayName;
  final bool savingDisplayName;
  final TextEditingController controller;
  final VoidCallback onEdit;
  final Future<void> Function() onSave;

  const AccountCard({
    super.key,
    required this.user,
    required this.editingDisplayName,
    required this.savingDisplayName,
    required this.controller,
    required this.onEdit,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ProfileField(
                  label: 'DISPLAY NAME',
                  value:
                      user?.displayName ??
                      user?.userName ??
                      'USER',
                ),
              ),

              IconButton(
                onPressed:
                    editingDisplayName
                        ? onSave
                        : onEdit,
                icon: Icon(
                  editingDisplayName
                      ? Icons.check
                      : Icons.edit_outlined,
                  color:
                      const Color(
                    0xffB388FF,
                  ),
                  size: 20,
                ),
              ),
            ],
          ),

          if (editingDisplayName) ...[
            const SizedBox(height: 10),

            TextField(
              controller: controller,
              enabled:
                  !savingDisplayName,
              style:
                  GoogleFonts.jetBrainsMono(
                color: Colors.white,
                fontSize: 12,
              ),
              cursorColor:
                  const Color(
                0xffB388FF,
              ),
              decoration:
                  profileInputDecoration(
                'Display name',
              ),
            ),
          ],

          const Divider(
            color: Colors.white10,
            height: 28,
          ),

          ProfileField(
            label: 'USERNAME',
            value:
                user?.userName ??
                'UNKNOWN',
          ),

          const SizedBox(height: 17),

          ProfileField(
            label: 'EMAIL',
            value:
                user?.email ??
                'UNKNOWN',
          ),
        ],
      ),
    );
  }
}