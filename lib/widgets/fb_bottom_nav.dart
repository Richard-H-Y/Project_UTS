import 'package:flutter/material.dart';

class FbBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FbBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<IconData> _icons = [
    Icons.home,
    Icons.ondemand_video,
    Icons.storefront,
    Icons.group,
    Icons.notifications,
    Icons.menu,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: const Color(0xFF1877F2),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: List.generate(
        _icons.length,
        (i) => BottomNavigationBarItem(icon: Icon(_icons[i]), label: ''),
      ),
    );
  }
}