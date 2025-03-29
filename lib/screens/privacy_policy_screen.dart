import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

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
        title: const Text('Privacy Policy'),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIntroduction(),
              const SizedBox(height: 24),
              _buildSection(
                'Information We Collect',
                [
                  _buildBulletPoint(
                    'Personal Information',
                    'We may collect personal details such as your name, email '
                    'address, phone number, and location when you register or '
                    'use our services.',
                  ),
                  _buildBulletPoint(
                    'Usage Data',
                    'We gather data on how you access and interact with our app, '
                    'including device information, IP address, and browsing patterns.',
                  ),
                ],
              ),
              _buildSection(
                'How We Use Your Information',
                [
                  _buildBulletPoint(
                    'Service Delivery',
                    'To provide you with seamless access to government services, '
                    'private sector resources, and public utilities.',
                  ),
                  _buildBulletPoint(
                    'Communication',
                    'To send you updates, notifications, and promotional '
                    'materials related to our services.',
                  ),
                  _buildBulletPoint(
                    'Improvement',
                    'To analyze usage patterns and enhance user experience.',
                  ),
                ],
              ),
              _buildSection(
                'Data Sharing',
                [
                  Text(
                    'We do not sell or rent your personal information to third '
                    'parties. We may share your information with trusted partners '
                    'who assist us in providing our services while ensuring that '
                    'they comply with privacy regulations.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              _buildSection(
                'Security of Your Information',
                [
                  Text(
                    'We implement appropriate security measures to protect your '
                    'data from unauthorized access or disclosure. However, no '
                    'method of transmission over the internet or electronic '
                    'storage is 100% secure.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              _buildSection(
                'Your Rights',
                [
                  Text(
                    'You have the right to access, correct, or delete your '
                    'personal information at any time. For any inquiries '
                    'regarding your data, please contact us through the app.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              _buildContactSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroduction() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: const Text(
        'At ETIOP, we value your privacy and are committed to protecting your '
        'personal information. This Privacy Policy outlines how we collect, use, '
        'disclose, and safeguard your information when you use our app.',
        style: TextStyle(
          fontSize: 16,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> content) {
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
          ...content,
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: '$title: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: content),
          ],
        ),
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
            'Contact Us',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'If you have any questions about our Privacy Policy, please contact us at:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'ETIOP\n'
            'Ayushman Bhavan, Near Sri Nath Vihar\n'
            'Sarvodaya Nagar, Chilla Road\n'
            'Banda, UP - 210001\n\n'
            'Phone: +91 8299003168\n'
            'Email: etiop2706@gmail.com',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
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