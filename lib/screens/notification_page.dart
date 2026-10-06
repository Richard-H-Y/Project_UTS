import 'package:flutter/material.dart';

import '../models/app_notification.dart';
import '../widgets/notification_filter_chips.dart';
import '../widgets/notification_section_header.dart';
import '../widgets/notification_tile.dart';
import '../widgets/notification_options_sheet.dart';
import '../widgets/notification_empty_state.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key, required this.onNotificationTap});

  final ValueChanged<AppNotification> onNotificationTap;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _onlyUnread = false;

  final List<AppNotification> _notifs = [
    AppNotification(
      name: 'Kamu',
      message: 'membagikan video boss',
      time: 'Baru saja',
      type: NotifType.post,
      targetReelIndex: 0,
    ),
    AppNotification(
      name: 'Richard',
      message: 'mengomentarimu di video boss: "Keren!"',
      time: '2 menit lalu',
      type: NotifType.comment,
      targetReelIndex: 0,
    ),
    AppNotification(
      name: 'Surya',
      message: 'mengomentarimu di video boss: "Gokil banget!"',
      time: '3 menit lalu',
      type: NotifType.comment,
      targetReelIndex: 0,
    ),
    AppNotification(
      name: 'Andrian',
      message: 'mengomentarimu di video boss: "Mantap videonya!"',
      time: '4 menit lalu',
      type: NotifType.comment,
      targetReelIndex: 0,
    ),
    AppNotification(
      name: 'Richard',
      message: 'menyukai postingan kamu',
      time: '5 menit lalu',
      type: NotifType.like,
      targetPostIndex: 0,
    ),
    AppNotification(
      name: 'Surya',
      message: 'mengomentari postingan kamu: "Keren!"',
      time: '20 menit lalu',
      type: NotifType.comment,
      targetPostIndex: 2,
    ),
    AppNotification(
      name: 'Elysia',
      message: 'mengirim permintaan pertemanan',
      time: '1 jam lalu',
      type: NotifType.friend,
    ),
    AppNotification(
      name: 'Andrian',
      message: 'membagikan postingan baru',
      time: '3 jam lalu',
      type: NotifType.post,
      targetPostIndex: 3,
      isRead: true,
    ),
    AppNotification(
      name: 'Kevin',
      message: 'berulang tahun hari ini',
      time: '1 hari lalu',
      type: NotifType.birthday,
      isRead: true,
    ),
  ];

  void _markAllRead() {
    setState(() {
      for (final n in _notifs) {
        n.isRead = true;
      }
    });
  }

  void _showOptions(AppNotification n) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => NotificationOptionsSheet(
        notif: n,
        onToggleRead: () => setState(() => n.isRead = !n.isRead),
        onDelete: () => setState(() => _notifs.remove(n)),
      ),
    );
  }

  Widget _tile(AppNotification n) {
    return NotificationTile(
      notif: n,
      onTap: () {
        setState(() => n.isRead = true);
        widget.onNotificationTap(n);
      },
      onMore: () => _showOptions(n),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unread = _notifs.where((n) => !n.isRead).toList();
    final read = _onlyUnread
        ? <AppNotification>[]
        : _notifs.where((n) => n.isRead).toList();

    return ListView(
      children: [
        NotificationFilterChips(
          onlyUnread: _onlyUnread,
          onChanged: (v) => setState(() => _onlyUnread = v),
        ),
        if (unread.isEmpty && read.isEmpty)
          NotificationEmptyState(
            message: _onlyUnread
                ? 'Semua sudah dibaca'
                : 'Belum ada notifikasi',
          ),
        if (unread.isNotEmpty) ...[
          NotificationSectionHeader(
            title: 'Baru',
            actionLabel: 'Tandai semua dibaca',
            onAction: _markAllRead,
          ),
          for (final n in unread) _tile(n),
        ],
        if (read.isNotEmpty) ...[
          const NotificationSectionHeader(title: 'Sebelumnya'),
          for (final n in read) _tile(n),
        ],
      ],
    );
  }
}
