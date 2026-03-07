import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import '../main.dart' show themeModeNotifier;
import 'notification_settings_screen.dart';
import 'security_screen.dart';

class SettingsScreen extends StatefulWidget {
  final Map<String, dynamic>? user;
  const SettingsScreen({super.key, this.user});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  String _selectedCurrency = 'IDR (Rp)';

  static const Color _primaryColor = Color(0xFF166835);

  @override
  void initState() {
    super.initState();
    _isDarkMode = themeModeNotifier.value == ThemeMode.dark;
    _loadPreferences();
    // Keep local state in sync if notifier changes externally
    themeModeNotifier.addListener(_syncDarkMode);
  }

  @override
  void dispose() {
    themeModeNotifier.removeListener(_syncDarkMode);
    super.dispose();
  }

  void _syncDarkMode() {
    if (mounted) {
      setState(() {
        _isDarkMode = themeModeNotifier.value == ThemeMode.dark;
      });
    }
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCurrency = prefs.getString('currency') ?? 'IDR (Rp)';
    });
  }

  Future<void> _savePreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) await prefs.setBool(key, value);
    if (value is String) await prefs.setString(key, value);
  }

  // ── Dark Mode ──────────────────────────────────────────────────────────────
  void _toggleDarkMode(bool value) {
    themeModeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
    _savePreference('dark_mode', value);
    _showSnackBar(value ? 'dark_mode_enabled'.tr() : 'light_mode_enabled'.tr());
  }

  // ── Bahasa ─────────────────────────────────────────────────────────────────
  void _showLanguageDialog() {
    // Simpan outer context agar setLocale & setState bisa dipanggil dari dalam dialog
    final outerContext = context;
    showDialog(
      context: outerContext,
      builder: (dialogContext) => AlertDialog(
        title: Text('language'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('indonesian'.tr()),
              trailing: outerContext.locale.languageCode == 'id'
                  ? const Icon(Icons.check, color: _primaryColor)
                  : null,
              onTap: () {
                outerContext.setLocale(const Locale('id'));
                Navigator.pop(dialogContext);
                if (mounted) setState(() {});
              },
            ),
            ListTile(
              title: Text('english'.tr()),
              trailing: outerContext.locale.languageCode == 'en'
                  ? const Icon(Icons.check, color: _primaryColor)
                  : null,
              onTap: () {
                outerContext.setLocale(const Locale('en'));
                Navigator.pop(dialogContext);
                if (mounted) setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── Mata Uang – UI saja ────────────────────────────────────────────────────
  void _showCurrencyPicker() {
    final currencies = [
      'IDR (Rp)',
      'USD (\$)',
      'EUR (€)',
      'SGD (S\$)',
      'MYR (RM)',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'select_currency'.tr(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            ...currencies.map((cur) => ListTile(
                  title: Text(cur),
                  trailing: _selectedCurrency == cur
                      ? const Icon(Icons.check, color: _primaryColor)
                      : null,
                  onTap: () {
                    setState(() => _selectedCurrency = cur);
                    _savePreference('currency', cur);
                    Navigator.pop(context);
                  },
                )),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  // ── Tentang ────────────────────────────────────────────────────────────────
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bar_chart, color: _primaryColor, size: 24),
            ),
            const SizedBox(width: 12),
            const Text('Profitly'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${'version'.tr()} 1.0.0', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'profitly_desc'.tr(),
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Text('developed_by'.tr(),
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const Text('© 2024 Profitly. All rights reserved.',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text('close'.tr()),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    // Hapus semua snackbar yang sedang antre agar tampil langsung tanpa delay
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: _primaryColor,
        ),
      );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final String currentLang =
        context.locale.languageCode == 'id' ? 'indonesian'.tr() : 'english'.tr();

    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr()),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // ── Akun ──────────────────────────────────────────
          _buildSectionHeader('account'.tr()),
          _buildSettingCard(children: [
            _buildArrowTile(
              icon: Icons.notifications_outlined,
              iconColor: _primaryColor,
              title: 'notifications'.tr(),
              subtitle: 'manage_notifications'.tr(),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationSettingsScreen(),
                ),
              ),
            ),
            const Divider(height: 1, indent: 72),
            _buildArrowTile(
              icon: Icons.lock_outline,
              iconColor: _primaryColor,
              title: 'security'.tr(),
              subtitle: 'password_security'.tr(),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SecurityScreen(currentUser: widget.user),
                ),
              ),
            ),
          ]),

          // ── Tampilan & Bahasa ─────────────────────────────
          _buildSectionHeader('appearance_language'.tr()),
          _buildSettingCard(children: [
            _buildSwitchTile(
              icon: Icons.dark_mode_outlined,
              iconColor: Colors.indigo,
              title: 'dark_mode'.tr(),
              subtitle: 'dark_mode_desc'.tr(),
              value: _isDarkMode,
              onChanged: _toggleDarkMode,
            ),
            const Divider(height: 1, indent: 72),
            _buildArrowTile(
              icon: Icons.language_outlined,
              iconColor: Colors.teal,
              title: 'language'.tr(),
              subtitle: currentLang,
              onTap: _showLanguageDialog,
            ),
            const Divider(height: 1, indent: 72),
            _buildArrowTile(
              icon: Icons.currency_exchange_outlined,
              iconColor: Colors.orange,
              title: 'currency'.tr(),
              subtitle: _selectedCurrency,
              onTap: _showCurrencyPicker,
            ),
          ]),

          // ── Tentang ───────────────────────────────────────
          _buildSectionHeader('about'.tr()),
          _buildSettingCard(children: [
            _buildArrowTile(
              icon: Icons.info_outline,
              iconColor: Colors.blue,
              title: 'about_profitly'.tr(),
              subtitle: '${'version'.tr()} 1.0.0',
              onTap: _showAboutDialog,
            ),

          ]),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── Helper Widgets ─────────────────────────────────────────────────────────

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade500,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildSettingCard({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildArrowTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
      subtitle:
          Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
      subtitle:
          Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      value: value,
      onChanged: onChanged,
      activeColor: _primaryColor,
    );
  }
}
