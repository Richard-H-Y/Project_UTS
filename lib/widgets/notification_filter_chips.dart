import 'package:flutter/material.dart';

class NotificationFilterChips extends StatelessWidget {
  final bool onlyUnread;
  final ValueChanged<bool> onChanged;

  const NotificationFilterChips({
    super.key,
    required this.onlyUnread,
    required this.onChanged,
  });

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFE7F3FF) : const Color(0xFFF0F2F5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? const Color(0xFF1877F2) : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: Row(
        children: [
          _chip('Semua', !onlyUnread, () => onChanged(false)),
          _chip('Belum dibaca', onlyUnread, () => onChanged(true)),
        ],
      ),
    );
  }
}
