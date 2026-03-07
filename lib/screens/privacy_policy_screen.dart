import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('privacy_policy'.tr()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Last updated: March 2026\n\n'
              'Thank you for using Profitly. We are committed to protecting your personal information and your right to privacy. '
              'If you have any questions or concerns about this privacy notice or our practices with regard to your personal information, please contact us.\n\n'
              '1. Information We Collect\n'
              'We collect personal information that you voluntarily provide to us when you register on the App, express an interest in obtaining information about us or our products and Services, when you participate in activities on the App or otherwise when you contact us.\n\n'
              '2. How We Use Your Information\n'
              'We use personal information collected via our App for a variety of business purposes described below. We process your personal information for these purposes in reliance on our legitimate business interests, in order to enter into or perform a contract with you, with your consent, and/or for compliance with our legal obligations.\n\n'
              '3. Will Your Information Be Shared With Anyone?\n'
              'We only share information with your consent, to comply with laws, to provide you with services, to protect your rights, or to fulfill business obligations.\n\n'
              '4. How Long Do We Keep Your Information?\n'
              'We keep your information for as long as necessary to fulfill the purposes outlined in this privacy notice unless otherwise required by law.\n\n'
              '5. Contact Us\n'
              'If you have questions or comments about this notice, you may email us at support@profitly.com.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
