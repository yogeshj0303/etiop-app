import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:etiop_application/providers/language_provider.dart';
import '../generated/app_localizations.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.language),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return ListView(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  l10n.language,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildLanguageOption(
                context,
                languageProvider,
                'en',
                'English',
                '🇺🇸',
                l10n.english,
                l10n,
              ),
              _buildLanguageOption(
                context,
                languageProvider,
                'hi',
                'हिंदी',
                '🇮🇳',
                l10n.hindi,
                l10n,
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Note: Language changes will be applied immediately and saved for future app launches.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    LanguageProvider languageProvider,
    String languageCode,
    String languageName,
    String flag,
    String localizedName,
    AppLocalizations l10n,
  ) {
    final isSelected = languageProvider.currentLanguageCode == languageCode;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.white,
      ),
      child: ListTile(
        leading: Text(
          flag,
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(
          languageName,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
          ),
        ),
        subtitle: Text(
          localizedName,
          style: TextStyle(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
          ),
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).primaryColor,
                size: 24,
              )
            : null,
        onTap: () {
          languageProvider.changeLanguage(languageCode);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.languageChangedTo(localizedName)),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }
}
