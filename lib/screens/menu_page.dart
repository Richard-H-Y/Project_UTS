import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'account_settings_page.dart';
import 'login_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  String _username = '';
  Uint8List? _photoBytes;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    String displayName = await _prefs.getString('display_name') ?? '';
    String savedUsername = await _prefs.getString('username') ?? '';
    String photoBase64 = await _prefs.getString('profile_picture') ?? '';
    Uint8List? photoBytes;
    if (photoBase64.isNotEmpty) {
      try {
        photoBytes = base64Decode(photoBase64);
      } catch (_) {}
    }
    if (!mounted) return;
    setState(() {
      _username = displayName.isNotEmpty ? displayName : savedUsername;
      _photoBytes = photoBytes;
    });
  }

  void _openAccountSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AccountSettingsPage()),
    );
    _loadUsername();
  }

  void _logout() async {
    await _prefs.setBool('isLoggedIn', false);
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 12),
        Center(
          child: GestureDetector(
            onTap: _openAccountSettings,
            child: CircleAvatar(
              radius: 36,
              backgroundColor: const Color(0xFF1877F2),
              backgroundImage:
                  _photoBytes != null ? MemoryImage(_photoBytes!) : null,
              child: _photoBytes != null
                  ? null
                  : const Icon(Icons.person, color: Colors.white, size: 36),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _username.isEmpty ? 'Pengguna' : _username,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: const Icon(Icons.settings, color: Color(0xFF1877F2)),
            title: const Text(
              'Pengaturan Akun',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: _openAccountSettings,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Keluar',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: _logout,
          ),
        ),
      ],
    );
  }
}