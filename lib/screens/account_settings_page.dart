import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  String _bio = '';
  Uint8List? _photoBytes;
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
    final bio = await _prefs.getString('bio') ?? '';
    final photoBase64 = await _prefs.getString('profile_picture') ?? '';
    Uint8List? photoBytes;
    if (photoBase64.isNotEmpty) {
      try {
        photoBytes = base64Decode(photoBase64);
      } catch (_) {}
    }
    final notifOn = await _prefs.getBool('notif_on') ?? true;
    final privateOn = await _prefs.getBool('private_on') ?? false;
    if (!mounted) return;
    setState(() {
      _username = username;
      _displayName = displayName;
      _email = email;
      _phone = phone;
      _bio = bio;
      _photoBytes = photoBytes;
      _notifOn = notifOn;
      _privateOn = privateOn;
      _isLoading = false;
    });
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  bool get _hasPhoto => _photoBytes != null;

  // Camera hanya tersedia di Android/iOS (bukan web/desktop)
  bool get _cameraSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (picked == null) return;

      final bytes = await picked.readAsBytes();
      await _prefs.setString('profile_picture', base64Encode(bytes));
      if (!mounted) return;
      setState(() => _photoBytes = bytes);
      _showSnack('Foto profil berhasil diganti');
    } catch (e) {
      if (!mounted) return;
      _showSnack('Gagal mengambil foto: $e');
    }
  }

  Future<void> _removePhoto() async {
    await _prefs.remove('profile_picture');
    if (!mounted) return;
    setState(() => _photoBytes = null);
    _showSnack('Foto profil dihapus');
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari galeri'),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickPhoto(ImageSource.gallery);
              },
            ),
            if (_cameraSupported)
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Ambil foto'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickPhoto(ImageSource.camera);
                },
              ),
            if (_hasPhoto)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Hapus foto',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _removePhoto();
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _photoHeader() {
    final name = _displayName.isNotEmpty ? _displayName : _username;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: _showPhotoOptions,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundColor: const Color(0xFF1877F2),
                  backgroundImage: _hasPhoto ? MemoryImage(_photoBytes!) : null,
                  child: _hasPhoto
                      ? null
                      : const Icon(Icons.person, color: Colors.white, size: 52),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 17,
                    backgroundColor: const Color(0xFFE4E6EB),
                    child: const Icon(Icons.camera_alt,
                        size: 18, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name.isEmpty ? 'Pengguna' : name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          if (_bio.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
              child: Text(_bio,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54)),
            ),
        ],
      ),
    );
  }

  Future<void> _editField({
    required String title,
    required String currentValue,
    required String prefKey,
    required void Function(String) onSaved,
    String? alsoSaveTo,
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

    if (result != null) {
      await _prefs.setString(prefKey, result);
      if (alsoSaveTo != null) await _prefs.setString(alsoSaveTo, result);
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
                _photoHeader(),
                _section('Informasi Akun', [
                  _infoTile(
                    Icons.account_circle,
                    'Username',
                    _username,
                    () => _editField(
                      title: 'Username',
                      currentValue: _username,
                      prefKey: 'account_username',
                      alsoSaveTo: 'username',
                      onSaved: (v) => _username = v,
                      validator: (v) {
                        if (v.length < 3) return 'Minimal 3 karakter';
                        if (v.contains(' ')) return 'Tidak boleh ada spasi';
                        return null;
                      },
                    ),
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
                    Icons.info,
                    'Bio',
                    _bio,
                    () => _editField(
                      title: 'Bio',
                      currentValue: _bio,
                      prefKey: 'bio',
                      onSaved: (v) => _bio = v,
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