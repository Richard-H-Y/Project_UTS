import 'package:flutter/material.dart';
import '../models/app_notification.dart';

class NotificationOptionsSheet extends StatelessWidget {
  final AppNotification notif;
  final VoidCallback onToggleRead;
  final VoidCallback onDelete;

  const NotificationOptionsSheet({
    super.key,
    required this.notif,
    required this.onToggleRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          ListTile(
            leading: Icon(
              notif.isRead ? Icons.mark_email_unread_outlined : Icons.done,
            ),
            title: Text(
              notif.isRead ? 'Tandai belum dibaca' : 'Tandai sudah dibaca',
            ),
            onTap: () {
              Navigator.pop(context);
              onToggleRead();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Hapus notifikasi ini'),
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
          ),
        ],
      ),
    );
  }
}
