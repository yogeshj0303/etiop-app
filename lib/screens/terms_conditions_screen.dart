import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new,size: 18,),
        ),
        title: const Text('Terms & Conditions'),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                'Acceptance of Terms',
                'By using ETIOP, you agree to comply with these Terms & '
                'Conditions. If you do not agree with any part of these terms, '
                'please refrain from using our services.',
              ),
              _buildSection(
                'Services Provided',
                'ETIOP serves as a platform for accessing various government '
                'services, private sector resources, and public utilities. We '
                'strive to provide accurate and timely information but do not '
                'guarantee the completeness or reliability of the content.',
              ),
              _buildExpandableSection(
                'User Responsibilities',
                [
                  _buildSubSection(
                    'Account Security',
                    'You are responsible for maintaining the confidentiality of '
                    'your account credentials and for all activities under your '
                    'account.',
                  ),
                  _buildSubSection(
                    'Prohibited Activities',
                    'You agree not to engage in any unlawful activities or '
                    'misuse our platform in any way that could harm others or '
                    'disrupt services.',
                  ),
                ],
              ),
              _buildSection(
                'Limitation of Liability',
                'ETIOP shall not be liable for any direct, indirect, incidental, '
                'or consequential damages arising from your use of our app or '
                'services. We do not guarantee uninterrupted access or error-free '
                'performance.',
              ),
              _buildSection(
                'Changes to Terms',
                'We reserve the right to modify these Terms & Conditions at any '
                'time. Any changes will be effective immediately upon posting in '
                'the app. Your continued use of ETIOP after such changes '
                'constitutes acceptance of the new terms.',
              ),
              _buildContactSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection(String title, List<Widget> subsections) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          ...subsections,
        ],
      ),
    );
  }

  Widget _buildSubSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• $title',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Questions About Our Terms?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'If you have any questions about our Terms & Conditions, please contact our support team:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              // Add email functionality here
            },
            child: const Text(
              'etiop2706@gmail.com',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
} 