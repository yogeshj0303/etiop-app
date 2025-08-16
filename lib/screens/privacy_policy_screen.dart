import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 18,
          ),
        ),
        title: Text(l10n.privacyPolicy),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIntroduction(context),
              const SizedBox(height: 24),
              _buildSection(
                context,
                l10n.informationWeCollect,
                [
                  _buildBulletPoint(
                    context,
                    l10n.personalInformation,
                    l10n.personalInfoDescription,
                  ),
                  _buildBulletPoint(
                    context,
                    l10n.usageData,
                    l10n.usageDataDescription,
                  ),
                ],
              ),
              _buildSection(
                context,
                l10n.howWeUseYourInformation,
                [
                  _buildBulletPoint(
                    context,
                    l10n.serviceDelivery,
                    l10n.serviceDeliveryDescription,
                  ),
                  _buildBulletPoint(
                    context,
                    l10n.communication,
                    l10n.communicationDescription,
                  ),
                  _buildBulletPoint(
                    context,
                    l10n.improvement,
                    l10n.improvementDescription,
                  ),
                ],
              ),
              _buildSection(
                context,
                l10n.dataSharing,
                [
                  Text(
                    l10n.dataSharingDescription,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              _buildSection(
                context,
                l10n.securityOfYourInformation,
                [
                  Text(
                    l10n.securityDescription,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              _buildSection(
                context,
                l10n.yourRights,
                [
                  Text(
                    l10n.rightsDescription,
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

  Widget _buildIntroduction(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
          l10n.privacyPolicyIntro,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> content) {
    final l10n = AppLocalizations.of(context)!;
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
          const SizedBox(height: 8),
          ...content,
        ],
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String title, String content) {
    final l10n = AppLocalizations.of(context)!;
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
    final l10n = AppLocalizations.of(context)!;
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
          Text(
            l10n.contact,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.questionsAboutPrivacy,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'ETIOP\n'
            'Ayushman Bhavan, Near Sri Nath Vihar\n'
            'Sarvodaya Nagar, Chilla Road\n'
            'Banda, UP - 210001\n\n'
            'Email: etiop2706@gmail.com',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              // Add email functionality here
            },
            child: Text(
              'etiop2706@gmail.com',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
