import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:etiop_application/providers/language_provider.dart';
import 'package:etiop_application/screens/language_settings_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          _buildSectionHeader(context, l10n.settings),
          _buildSettingsTile(
            context,
            icon: Icons.language,
            title: l10n.language,
            subtitle: 'Change app language',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LanguageSettingsScreen(),
                ),
              );
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.notifications,
            title: l10n.notifications,
            subtitle: 'Manage notification preferences',
            onTap: () {
              // TODO: Implement notifications settings
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Notifications settings coming soon')),
              );
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.privacy_tip,
            title: l10n.privacyPolicy,
            subtitle: 'Read our privacy policy',
            onTap: () {
              // TODO: Navigate to privacy policy
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Privacy policy coming soon')),
              );
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.description,
            title: l10n.termsConditions,
            subtitle: 'Read our terms and conditions',
            onTap: () {
              // TODO: Navigate to terms and conditions
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Terms & conditions coming soon')),
              );
            },
          ),
          const SizedBox(height: 20),
          _buildSectionHeader(context, l10n.account),
          _buildSettingsTile(
            context,
            icon: Icons.person,
            title: l10n.profile,
            subtitle: 'Edit your profile information',
            onTap: () {
              // TODO: Navigate to profile edit
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Profile edit coming soon')),
              );
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.lock,
            title: l10n.changePassword,
            subtitle: 'Update your password',
            onTap: () {
              // TODO: Navigate to password change
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Password change coming soon')),
              );
            },
          ),
          const SizedBox(height: 20),
          _buildSectionHeader(context, l10n.support),
          _buildSettingsTile(
            context,
            icon: Icons.help,
            title: 'Help & Support',
            subtitle: 'Get help and contact support',
            onTap: () {
              // TODO: Navigate to help and support
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Help & support coming soon')),
              );
            },
          ),
          _buildSettingsTile(
            context,
            icon: Icons.info,
            title: l10n.about,
            subtitle: 'App version and information',
            onTap: () {
              // TODO: Navigate to about page
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('About page coming soon')),
              );
            },
          ),
          const SizedBox(height: 20),
          _buildSectionHeader(context, 'Actions'),
          _buildSettingsTile(
            context,
            icon: Icons.logout,
            title: l10n.logout,
            subtitle: 'Sign out of your account',
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.logout),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement logout functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout functionality coming soon')),
                );
              },
              child: Text(l10n.logout),
            ),
          ],
        );
      },
    );
  }
}
