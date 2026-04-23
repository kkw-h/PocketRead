import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocketread/core/router/app_router.dart';

enum AppBottomNavTab {
  bookshelf,
  my,
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.currentTab,
    super.key,
  });

  final AppBottomNavTab currentTab;

  static const Color _green = Color(0xFF1DB954);
  static const Color _muted = Color(0xFF8B9099);
  static const Color _line = Color(0xFFE5E6EB);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _line)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: <Widget>[
            Expanded(
              child: _BottomNavItem(
                icon: Icons.menu_book_outlined,
                selectedIcon: Icons.menu_book_rounded,
                label: '书架',
                selected: currentTab == AppBottomNavTab.bookshelf,
                onTap: () {
                  if (currentTab != AppBottomNavTab.bookshelf) {
                    context.goNamed(AppRoute.bookshelf.name);
                  }
                },
              ),
            ),
            Expanded(
              child: _BottomNavItem(
                icon: Icons.person_outline_rounded,
                selectedIcon: Icons.person_rounded,
                label: '我的',
                selected: currentTab == AppBottomNavTab.my,
                onTap: () {
                  if (currentTab != AppBottomNavTab.my) {
                    context.goNamed(AppRoute.my.name);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = selected ? AppBottomNav._green : AppBottomNav._muted;

    return InkResponse(
      onTap: onTap,
      radius: 28,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(selected ? selectedIcon : icon, size: 24, color: color),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
