import 'package:flutter/material.dart';
import 'package:pixelarticons/pixel.dart';

class DevTrackNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const DevTrackNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const Color background = Color(0xFF1E1F24);
  static const Color active = Color(0xFFA970FF);
  static const Color inactive = Color(0xFF8D8D98);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
        child: Container(
          height: 78,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(.05),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.35),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              _item(
                icon: Pixel.home,
                label: "Home",
                index: 0,
              ),
              _item(
                icon: Pixel.article,
                label: "Goals",
                index: 1,
              ),
              _item(
                icon: Pixel.folder,
                label: "Projects",
                index: 2,
              ),
              _item(
                icon: Pixel.file,
                label: "Notes",
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final selected = currentIndex == index;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => onTap(index),
        child: SizedBox(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: selected ? 1 : 0,
                duration: const Duration(milliseconds: 250),
                child: Container(
                  width: 7,
                  height: 7,
                  margin: const EdgeInsets.only(bottom: 5),
                  decoration: const BoxDecoration(
                    color: active,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Icon(
                icon,
                size: 22,
                color: selected ? active : inactive,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: selected ? active : inactive,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}