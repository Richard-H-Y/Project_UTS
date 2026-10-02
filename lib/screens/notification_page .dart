import 'dart:async';
import 'package:flutter/material.dart';
import '../models/app_notification.dart';
import '../widgets/notification_filter_chips.dart';
import '../widgets/notification_section_header.dart';
import '../widgets/notification_tile.dart';
import '../widgets/notification_options_sheet.dart';
import '../widgets/notification_empty_state.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _onlyUnread = false;
  Timer? _timer;
  int _nextIndex = 0;

  final List<AppNotification> _incoming = [
    AppNotification(name: 'Jonathan', message: 'menyukai postingan kamu', time: 'Baru saja', type: NotifType.like),
    AppNotification(name: 'Kevin', message: 'mengomentari postingan kamu: "Mantap"', time: 'Baru saja', type: NotifType.comment),
    AppNotification(name: 'Ely', message: 'membagikan postingan baru', time: 'Baru saja', type: NotifType.post),
    AppNotification(name: 'Surya', message: 'mengirim permintaan pertemanan', time: 'Baru saja', type: NotifType.friend),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 8), (t) {
      if (!mounted) return;
      if (_nextIndex >= _incoming.length) {
        t.cancel();
        return;
      }
      setState(() => _notifs.insert(0, _incoming[_nextIndex++]));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  final List<AppNotification> _notifs = [
    AppNotification(name: 'Richard', message: 'menyukai postingan kamu', time: '5 menit lalu', type: NotifType.like),
    AppNotification(name: 'Surya', message: 'mengomentari postingan kamu: "Keren!"', time: '20 menit lalu', type: NotifType.comment),
    AppNotification(name: 'Elysia', message: 'mengirim permintaan pertemanan', time: '1 jam lalu', type: NotifType.friend),
    AppNotification(name: 'Andrian', message: 'membagikan postingan baru', time: '3 jam lalu', type: NotifType.post, isRead: true),
    AppNotification(name: 'Kevin', message: 'berulang tahun hari ini', time: '1 hari lalu', type: NotifType.birthday, isRead: true),
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
      onTap: () => setState(() => n.isRead = true),
      onMore: () => _showOptions(n),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unread = _notifs.where((n) => !n.isRead).toList();
    final read = _onlyUnread ? <AppNotification>[] : _notifs.where((n) => n.isRead).toList();

    return ListView(
      children: [
        NotificationFilterChips(
          onlyUnread: _onlyUnread,
          onChanged: (v) => setState(() => _onlyUnread = v),
        ),
        if (unread.isEmpty && read.isEmpty)
          NotificationEmptyState(
            message: _onlyUnread ? 'Semua sudah dibaca' : 'Belum ada notifikasi',
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
