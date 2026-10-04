import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static const String _defaultPassword = '123456';

  bool _isLoading = true;
  String _username = '';
  String _displayName = '';
  String _email = '';
  String _phone = '';
  bool _notifOn = true;
  bool _privateOn = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final username = await _prefs.getString('username') ?? '';
    final displayName = await _prefs.getString('display_name') ?? '';
    final email = await _prefs.getString('email') ?? '';
    final phone = await _prefs.getString('phone') ?? '';
    final notifOn = await _prefs.getBool('notif_on') ?? true;
    final privateOn = await _prefs.getBool('private_on') ?? false;
    if (!mounted) return;
    setState(() {
      _username = username;
      _displayName = displayName;
      _email = email;
      _phone = phone;
      _notifOn = notifOn;
      _privateOn = privateOn;
      _isLoading = false;
    });
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _editField({
    required String title,
    required String currentValue,
    required String prefKey,
    required void Function(String) onSaved,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String)? validator,
  }) async {
    final controller = TextEditingController(text: currentValue);
    String? errorText;

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Ubah $title'),
              content: TextField(
                controller: controller,
                autofocus: true,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  hintText: title,
                  errorText: errorText,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () {
                    final value = controller.text.trim();
                    final error = validator?.call(value);
                    if (error != null) {
                      setDialogState(() => errorText = error);
                      return;
                    }
                    Navigator.pop(dialogContext, value);
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
    controller.dispose();

    if (result != null) {
      await _prefs.setString(prefKey, result);
      if (!mounted) return;
      setState(() => onSaved(result));
      _showSnack('$title berhasil disimpan');
    }
  }

  Future<void> _changePassword() async {
    final oldController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();
    String? errorText;

    final savedPassword = await _prefs.getString('password') ?? _defaultPassword;
    if (!mounted) return;

    final success = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Ganti Password'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: oldController,
                    obscureText: true,
                    decoration: const InputDecoration(hintText: 'Password lama'),
                  ),
                  TextField(
                    controller: newController,
                    obscureText: true,
                    decoration: const InputDecoration(hintText: 'Password baru'),
                  ),
                  TextField(
                    controller: confirmController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Konfirmasi password baru',
                    ),
                  ),
                  if (errorText != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () {
                    String? error;
                    if (oldController.text != savedPassword) {
                      error = 'Password lama salah';
                    } else if (newController.text.length < 6) {
                      error = 'Password baru minimal 6 karakter';
                    } else if (newController.text != confirmController.text) {
                      error = 'Konfirmasi password tidak sama';
                    }
                    if (error != null) {
                      setDialogState(() => errorText = error);
                      return;
                    }
                    Navigator.pop(dialogContext, true);
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    final newPassword = newController.text;
    oldController.dispose();
    newController.dispose();
    confirmController.dispose();

    if (success == true) {
      await _prefs.setString('password', newPassword);
      _showSnack('Password berhasil diganti');
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar?'),
        content: const Text('Kamu harus login lagi untuk masuk.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    await _prefs.setBool('isLoggedIn', false);
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1877F2)),
      title: Text(label),
      subtitle: Text(value.isEmpty ? 'Belum diisi' : value),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Pengaturan Akun',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _section('Informasi Akun', [
                  ListTile(
                    leading: const Icon(Icons.account_circle,
                        color: Color(0xFF1877F2)),
                    title: const Text('Username'),
                    subtitle: Text(_username.isEmpty ? '-' : _username),
                  ),
                  _infoTile(
                    Icons.badge,
                    'Nama tampilan',
                    _displayName,
                    () => _editField(
                      title: 'Nama tampilan',
                      currentValue: _displayName,
                      prefKey: 'display_name',
                      onSaved: (v) => _displayName = v,
                      validator: (v) =>
                          v.isEmpty ? 'Nama tidak boleh kosong' : null,
                    ),
                  ),
                  _infoTile(
                    Icons.email,
                    'Email',
                    _email,
                    () => _editField(
                      title: 'Email',
                      currentValue: _email,
                      prefKey: 'email',
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (v) => _email = v,
                      validator: (v) =>
                          v.contains('@') ? null : 'Email tidak valid',
                    ),
                  ),
                  _infoTile(
                    Icons.phone,
                    'Nomor telepon',
                    _phone,
                    () => _editField(
                      title: 'Nomor telepon',
                      currentValue: _phone,
                      prefKey: 'phone',
                      keyboardType: TextInputType.phone,
                      onSaved: (v) => _phone = v,
                      validator: (v) =>
                          v.length < 8 ? 'Nomor telepon tidak valid' : null,
                    ),
                  ),
                ]),
                _section('Keamanan', [
                  ListTile(
                    leading: const Icon(Icons.lock, color: Color(0xFF1877F2)),
                    title: const Text('Ganti password'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _changePassword,
                  ),
                ]),
                _section('Preferensi', [
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications,
                        color: Color(0xFF1877F2)),
                    title: const Text('Notifikasi'),
                    value: _notifOn,
                    onChanged: (value) async {
                      setState(() => _notifOn = value);
                      await _prefs.setBool('notif_on', value);
                    },
                  ),
                  SwitchListTile(
                    secondary:
                        const Icon(Icons.shield, color: Color(0xFF1877F2)),
                    title: const Text('Akun privat'),
                    subtitle:
                        const Text('Hanya teman yang bisa melihat postinganmu'),
                    value: _privateOn,
                    onChanged: (value) async {
                      setState(() => _privateOn = value);
                      await _prefs.setBool('private_on', value);
                    },
                  ),
                ]),
                _section('Akun', [
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Keluar',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    onTap: _logout,
                  ),
                ]),
              ],
            ),
    );
  }
}
