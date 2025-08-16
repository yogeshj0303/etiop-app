import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new,size: 18,),
        ),
        title: Text(l10n.termsConditions),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                context,
                l10n.acceptanceOfTerms,
                l10n.termsAcceptanceDescription,
              ),
              _buildSection(
                context,
                l10n.servicesProvided,
                l10n.servicesDescription,
              ),
              _buildExpandableSection(
                context,
                l10n.userResponsibilities,
                [
                  _buildSubSection(
                    context,
                    l10n.accountSecurity,
                    l10n.accountSecurityDescription,
                  ),
                  _buildSubSection(
                    context,
                    l10n.prohibitedActivities,
                    l10n.prohibitedActivitiesDescription,
                  ),
                ],
              ),
              _buildSection(
                context,
                l10n.limitationOfLiability,
                l10n.liabilityDescription,
              ),
              _buildSection(
                context,
                l10n.changesToTerms,
                l10n.changesDescription,
              ),
              _buildContactSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
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

  Widget _buildExpandableSection(BuildContext context, String title, List<Widget> subsections) {
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
          ...subsections,
        ],
      ),
    );
  }

  Widget _buildSubSection(BuildContext context, String title, String content) {
    final l10n = AppLocalizations.of(context)!;
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
          const SizedBox(height: 8),
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
            l10n.questionsAboutTerms,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.contactSupportTeam,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
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