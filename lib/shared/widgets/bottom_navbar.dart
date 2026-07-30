import 'package:flutter/material.dart';
import 'package:pixelarticons/pixel.dart';

class DevTrackNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const DevTrackNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  static const Color bg = Color(0xFF1E1F24);
  static const Color purple = Color(0xFFA970FF);
  static const Color inactive = Color(0xFF7A7C88);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
        child: Container(
          height: 76,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: Colors.white.withOpacity(.05),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.35),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              _NavItem(
                icon: Pixel.home,
                label: "Home",
                index: 0,
                selectedIndex: selectedIndex,
                onTap: onTap,
              ),
              _NavItem(
                icon: Pixel.flag,
                label: "Goals",
                index: 1,
                selectedIndex: selectedIndex,
                onTap: onTap,
              ),
              _NavItem(
                icon: Pixel.folder,
                label: "Projects",
                index: 2,
                selectedIndex: selectedIndex,
                onTap: onTap,
              ),
              _NavItem(
                icon: Pixel.notes,
                label: "Notes",
                index: 3,
                selectedIndex: selectedIndex,
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool selected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFA970FF).withOpacity(.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFFA970FF)
                        : Colors.transparent,
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: const Color(0xFFA970FF)
                                .withOpacity(.18),
                            blurRadius: 18,
                          )
                        ]
                      : [],
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: selected
                      ? const Color(0xFFA970FF)
                      : const Color(0xFF7A7C88),
                ),
              ),

              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}