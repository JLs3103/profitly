import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/database_helper.dart';
import 'login_screen.dart';

class SecurityScreen extends StatefulWidget {
  final Map<String, dynamic>? currentUser;

  const SecurityScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showChangePasswordDialog() {
    _oldPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ganti Kata Sandi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Kata Sandi Lama'),
              ),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Kata Sandi Baru'),
              ),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Konfirmasi Kata Sandi Baru'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_newPasswordController.text != _confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kata sandi baru tidak cocok')),
                  );
                  return;
                }

                if (_newPasswordController.text.length < 6) {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kata sandi minimal 6 karakter')),
                  );
                  return;
                }

                if (widget.currentUser != null) {
                  bool success = await _dbHelper.changePassword(
                    widget.currentUser!['username'],
                    _oldPasswordController.text,
                    _newPasswordController.text,
                  );

                  Navigator.pop(context); // Close dialog

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kata sandi berhasil diubah!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gagal mengubah kata sandi. Pastikan kata sandi lama benar.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF166835),
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSecurityOption({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? const Color(0xFF166835)),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keamanan'),
        backgroundColor: const Color(0xFF166835),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Kredensial',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          _buildSecurityOption(
            icon: Icons.lock_outline,
            title: 'Ganti Kata Sandi',
            subtitle: 'Perbarui kata sandi akun Anda',
            onTap: _showChangePasswordDialog,
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Lanjutan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          _buildSecurityOption(
            icon: Icons.delete_forever_outlined,
            title: 'Hapus Akun',
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Hapus Akun', style: TextStyle(color: Colors.red)),
                  content: const Text(
                      'Apakah Anda yakin ingin menghapus akun ini? Semua data akan hilang secara permanen dan tidak dapat dipulihkan.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (widget.currentUser != null) {
                          bool success = await _dbHelper.deleteUser(widget.currentUser!['username']);
                          if (success) {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.remove('saved_username');
                            
                            if (!context.mounted) return;
                            Navigator.pop(context); // close dialog
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                              (route) => false,
                            );
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Akun berhasil dihapus.')),
                            );
                          } else {
                            if (!context.mounted) return;
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Gagal menghapus akun.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Hapus Akun'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
