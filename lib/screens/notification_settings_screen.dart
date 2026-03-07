import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _promoOffers = false;
  bool _appUpdates = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('notif_push') ?? true;
      _emailNotifications = prefs.getBool('notif_email') ?? true;
      _promoOffers = prefs.getBool('notif_promo') ?? false;
      _appUpdates = prefs.getBool('notif_updates') ?? true;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Notifikasi'),
        backgroundColor: const Color(0xFF166835),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: [
          _buildSwitchTile(
            title: 'Notifikasi Push',
            subtitle: 'Terima notifikasi langsung di perangkat Anda',
            value: _pushNotifications,
            onChanged: (bool value) {
              setState(() {
                _pushNotifications = value;
              });
              _saveSetting('notif_push', value);
            },
            icon: Icons.notifications_active_outlined,
          ),
          const Divider(height: 1),
          _buildSwitchTile(
            title: 'Notifikasi Email',
            subtitle: 'Terima update dan laporan melalui email',
            value: _emailNotifications,
            onChanged: (bool value) {
              setState(() {
                _emailNotifications = value;
              });
              _saveSetting('notif_email', value);
            },
            icon: Icons.email_outlined,
          ),
          const Divider(height: 1),
          _buildSwitchTile(
            title: 'Promo & Penawaran',
            subtitle: 'Dapatkan informasi tentang promo terbaru',
            value: _promoOffers,
            onChanged: (bool value) {
              setState(() {
                _promoOffers = value;
              });
              _saveSetting('notif_promo', value);
            },
            icon: Icons.local_offer_outlined,
          ),
          const Divider(height: 1),
          _buildSwitchTile(
            title: 'Pembaruan Aplikasi',
            subtitle: 'Pemberitahuan ketika ada versi baru aplikasi',
            value: _appUpdates,
            onChanged: (bool value) {
              setState(() {
                _appUpdates = value;
              });
              _saveSetting('notif_updates', value);
            },
            icon: Icons.system_update_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF166835),
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF166835).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF166835)),
      ),
    );
  }
}
