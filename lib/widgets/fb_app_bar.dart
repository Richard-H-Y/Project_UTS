import 'package:flutter/material.dart';

class FbAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FbAppBar({super.key});

  Widget _circleIconButton(IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: CircleAvatar(
        backgroundColor: const Color(0xFFE4E6EB),
        child: IconButton(
          icon: Icon(icon, color: Colors.black87, size: 20),
          onPressed: onTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: const Text(
        'facebook',
        style: TextStyle(
          color: Color(0xFF1877F2),
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),
      ),
      actions: [
        _circleIconButton(Icons.search, () {}),
        _circleIconButton(Icons.chat_bubble, () {}),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}