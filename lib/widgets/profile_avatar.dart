import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileAvatar extends StatefulWidget {
  final double radius;

  const ProfileAvatar({super.key, this.radius = 20});

  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  static final ValueNotifier<Uint8List?> photoBytes = ValueNotifier(null);
  static bool _loaded = false;

  static Future<void> load() async {
    if (_loaded) return;
    _loaded = true;
    final photoBase64 = await _prefs.getString('profile_picture') ?? '';
    if (photoBase64.isEmpty) return;
    try {
      photoBytes.value = base64Decode(photoBase64);
    } catch (_) {
      photoBytes.value = null;
    }
  }

  static Future<void> setPhoto(Uint8List bytes) async {
    await _prefs.setString('profile_picture', base64Encode(bytes));
    photoBytes.value = bytes;
  }

  static Future<void> removePhoto() async {
    await _prefs.remove('profile_picture');
    photoBytes.value = null;
  }

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  @override
  void initState() {
    super.initState();
    ProfileAvatar.load();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Uint8List?>(
      valueListenable: ProfileAvatar.photoBytes,
      builder: (context, bytes, _) {
        return CircleAvatar(
          radius: widget.radius,
          backgroundColor: const Color(0xFF1877F2),
          backgroundImage: bytes != null ? MemoryImage(bytes) : null,
          child: bytes != null
              ? null
              : Icon(Icons.person, color: Colors.white, size: widget.radius),
        );
      },
    );
  }
}