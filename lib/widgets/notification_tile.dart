import 'package:flutter/material.dart';
import '../models/app_notification.dart';

class NotificationTile extends StatelessWidget {
  final AppNotification notif;
  final VoidCallback onTap;
  final VoidCallback onMore;

  const NotificationTile({
    super.key,
    required this.notif,
    required this.onTap,
    required this.onMore,
  });

  IconData _icon() {
    switch (notif.type) {
      case NotifType.like:
        return Icons.thumb_up;
      case NotifType.comment:
        return Icons.comment;
      case NotifType.friend:
        return Icons.person_add;
      case NotifType.post:
        return Icons.article;
      case NotifType.birthday:
        return Icons.cake;
    }
  }

  Color _color() {
    switch (notif.type) {
      case NotifType.like:
        return const Color(0xFF1877F2);
      case NotifType.comment:
        return const Color(0xFF45BD62);
      case NotifType.friend:
        return const Color(0xFF1877F2);
      case NotifType.post:
        return const Color(0xFFF7B928);
      case NotifType.birthday:
        return const Color(0xFFF02849);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: notif.isRead ? Colors.white : const Color(0xFFE7F3FF),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey[300],
                  child: Text(
                    notif.name[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _color(),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(_icon(), size: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black87, fontSize: 15),
                      children: [
                        TextSpan(
                          text: notif.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' ${notif.message}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notif.time,
                    style: TextStyle(
                      fontSize: 12,
                      color: notif.isRead ? Colors.grey : const Color(0xFF1877F2),
                      fontWeight: notif.isRead ? FontWeight.normal : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                InkWell(
                  onTap: onMore,
                  child: const Icon(Icons.more_horiz, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                if (!notif.isRead)
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1877F2),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
