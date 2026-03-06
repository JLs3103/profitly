import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  String? _selectedCategory;

  static const _primaryColor = Color(0xFF166835);
  static const _supportEmail = 'JoanLase10@gmail.com';

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _faqItems => [
        {'q': 'faq_q1'.tr(), 'a': 'faq_a1'.tr()},
        {'q': 'faq_q2'.tr(), 'a': 'faq_a2'.tr()},
        {'q': 'faq_q3'.tr(), 'a': 'faq_a3'.tr()},
        {'q': 'faq_q4'.tr(), 'a': 'faq_a4'.tr()},
        {'q': 'faq_q5'.tr(), 'a': 'faq_a5'.tr()},
      ];

  List<String> get _categories => [
        'contact_cat_question'.tr(),
        'contact_cat_bug'.tr(),
        'contact_cat_suggestion'.tr(),
      ];

  Future<void> _sendMessage() async {
    if (_formKey.currentState!.validate()) {
      final String category = _selectedCategory ?? 'Bantuan & Dukungan';
      final String message = _messageController.text.trim();

      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: _supportEmail,
        queryParameters: {
          'subject': '[Profitly] $category',
          'body': message,
        },
      );

      bool launched = false;
      try {
        launched = await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      } catch (_) {
        launched = false;
      }

      if (!mounted) return;

      if (launched) {
        _messageController.clear();
        setState(() => _selectedCategory = null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('contact_sent_success'.tr()),
            backgroundColor: _primaryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      } else {
        // No email app installed – show dialog with email address
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Icon(Icons.email_outlined, color: _primaryColor),
                const SizedBox(width: 8),
                const Text('Kirim Email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tidak ada aplikasi email yang terdeteksi. Silakan hubungi kami langsung di:',
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                SelectableText(
                  _supportEmail,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('OK', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('help_support'.tr()),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFaqSection(),
            const SizedBox(height: 24),
            _buildContactFormSection(),
            const SizedBox(height: 24),
            _buildContactInfoSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────── FAQ ───────────────────────────

  Widget _buildFaqSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.quiz_outlined,
          title: 'faq_title'.tr(),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: List.generate(_faqItems.length, (index) {
                final item = _faqItems[index];
                return Column(
                  children: [
                    _FaqTile(
                      question: item['q']!,
                      answer: item['a']!,
                      primaryColor: _primaryColor,
                    ),
                    if (index < _faqItems.length - 1)
                      Divider(height: 1, color: Colors.grey.shade200),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────── CONTACT FORM ───────────────────────────

  Widget _buildContactFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.mail_outline_rounded,
          title: 'contact_us_title'.tr(),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Category Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'contact_category'.tr(),
                      labelStyle: TextStyle(color: Colors.grey.shade600),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _primaryColor, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedCategory = value),
                  ),
                  const SizedBox(height: 16),
                  // Message Field
                  TextFormField(
                    controller: _messageController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'contact_message'.tr(),
                      hintText: 'contact_message_hint'.tr(),
                      labelStyle: TextStyle(color: Colors.grey.shade600),
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _primaryColor, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'contact_validation_message'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Send Button
                  ElevatedButton.icon(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: Text(
                      'contact_send'.tr(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────── CONTACT INFO ───────────────────────────

  Widget _buildContactInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          icon: Icons.info_outline_rounded,
          title: 'contact_info_title'.tr(),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow(
                  icon: Icons.email_outlined,
                  label: 'contact_email_label'.tr(),
                  value: 'contact_email_value'.tr(),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1),
                ),
                _buildInfoRow(
                  icon: Icons.access_time_rounded,
                  label: 'contact_hours_label'.tr(),
                  value: 'contact_hours_value'.tr(),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(height: 1),
                ),
                _buildSocialRow(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: _primaryColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.group_outlined, color: _primaryColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'contact_follow_us'.tr(),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  _SocialChip(
                    label: 'Instagram',
                    color: Colors.purple.shade400,
                    url: 'https://www.instagram.com/jls3103/',
                  ),
                  const SizedBox(width: 8),
                  _SocialChip(
                    label: 'LinkedIn',
                    color: Colors.blue.shade700,
                    url: 'https://www.linkedin.com/in/joan-putra-feodora-lase-64abb428a/',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────── HELPERS ───────────────────────────

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _primaryColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: _primaryColor, size: 20),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────── WIDGET FAQ TILE ───────────────────────────

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;
  final Color primaryColor;

  const _FaqTile({
    required this.question,
    required this.answer,
    required this.primaryColor,
  });

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;
  late Animation<double> _iconTurn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _iconTurn = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.question,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: _expanded ? widget.primaryColor : Colors.black87,
                    ),
                  ),
                ),
                RotationTransition(
                  turns: _iconTurn,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: _expanded ? widget.primaryColor : Colors.grey,
                  ),
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: _expanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        widget.answer,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────── WIDGET SOCIAL CHIP ───────────────────────────

class _SocialChip extends StatelessWidget {
  final String label;
  final Color color;
  final String url;

  const _SocialChip({
    required this.label,
    required this.color,
    required this.url,
  });

  Future<void> _launch() async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launch,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ),
    );
  }
}
