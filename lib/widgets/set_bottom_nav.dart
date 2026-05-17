import 'package:flutter/material.dart';

import '../core/theme/app_text_styles.dart';

class SetNavItem {
  const SetNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class SetBottomNav extends StatelessWidget {
  const SetBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<SetNavItem> items;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            // Bar background
            Container(
              height: 68,
              decoration: BoxDecoration(
                color: const Color(0xFF141210),
                borderRadius: BorderRadius.circular(34),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: List.generate(items.length, (i) {
                  final selected = i == currentIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTap(i),
                      behavior: HitTestBehavior.opaque,
                      child: _NavTile(
                        item: items[i],
                        selected: selected,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({required this.item, required this.selected});

  final SetNavItem item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    if (selected) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Glowing circular bubble
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [Color(0xFF6B4E1A), Color(0xFF3A2A0A)],
                radius: 0.85,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4A843).withValues(alpha: 0.55),
                  blurRadius: 22,
                  spreadRadius: 2,
                  offset: const Offset(0, -4),
                ),
                BoxShadow(
                  color: const Color(0xFFD4A843).withValues(alpha: 0.25),
                  blurRadius: 40,
                  spreadRadius: 6,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: Icon(
              item.icon,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            item.label,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          item.icon,
          size: 22,
          color: Colors.white.withValues(alpha: 0.45),
        ),
        const SizedBox(height: 3),
        Text(
          item.label,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.45),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
