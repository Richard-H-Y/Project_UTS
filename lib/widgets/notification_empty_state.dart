import 'package:flutter/material.dart';

class NotificationEmptyState extends StatelessWidget {
  final String message;

  const NotificationEmptyState({
    super.key,
    this.message = 'Belum ada notifikasi',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(message, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
