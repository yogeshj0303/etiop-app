import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Uncomment after running flutter gen-l10n

/// Example of how to implement localization in existing screens
/// 
/// This file shows the before and after implementation of localization
/// in various parts of the app.

class LocalizationExample extends StatelessWidget {
  const LocalizationExample({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Uncomment after running flutter gen-l10n
    // final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localization Example'), // TODO: Replace with l10n.localizationExample
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildExampleSection(
              context,
              'Login Screen Example',
              'Before (Hardcoded):',
              'Text(\'Login\')',
              'After (Localized):',
              'Text(l10n.login)',
            ),
            const SizedBox(height: 20),
            _buildExampleSection(
              context,
              'Welcome Message Example',
              'Before (Hardcoded):',
              'Text(\'Welcome Back!\')',
              'After (Localized):',
              'Text(l10n.welcome)',
            ),
            const SizedBox(height: 20),
            _buildExampleSection(
              context,
              'Form Labels Example',
              'Before (Hardcoded):',
              'labelText: \'Email or Mobile\'',
              'After (Localized):',
              'labelText: l10n.email',
            ),
            const SizedBox(height: 20),
            _buildExampleSection(
              context,
              'Button Text Example',
              'Before (Hardcoded):',
              'ElevatedButton(\n  child: Text(\'Submit\'),\n  onPressed: () {},\n)',
              'After (Localized):',
              'ElevatedButton(\n  child: Text(l10n.submit),\n  onPressed: () {},\n)',
            ),
            const SizedBox(height: 20),
            _buildExampleSection(
              context,
              'Error Messages Example',
              'Before (Hardcoded):',
              'return \'Please enter your email\';',
              'After (Localized):',
              'return l10n.requiredField;',
            ),
            const SizedBox(height: 40),
            _buildImplementationSteps(context),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleSection(
    BuildContext context,
    String title,
    String beforeLabel,
    String beforeCode,
    String afterLabel,
    String afterCode,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            beforeLabel,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(top: 4, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              beforeCode,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
          Text(
            afterLabel,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.green,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              afterCode,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImplementationSteps(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border.all(color: Colors.blue[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Implementation Steps:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 12),
          _buildStep(context, '1', 'Run flutter gen-l10n to generate localization files'),
          _buildStep(context, '2', 'Import AppLocalizations in your screen file'),
          _buildStep(context, '3', 'Get l10n instance: final l10n = AppLocalizations.of(context)!'),
          _buildStep(context, '4', 'Replace hardcoded strings with l10n.stringKey'),
          _buildStep(context, '5', 'Test language switching in the app'),
        ],
      ),
    );
  }

  Widget _buildStep(BuildContext context, String number, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue[600],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: Colors.blue[800],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Example of how to implement localization in a real screen
/// 
/// This shows the complete implementation for a login screen
class LocalizedLoginScreenExample extends StatefulWidget {
  const LocalizedLoginScreenExample({super.key});

  @override
  State<LocalizedLoginScreenExample> createState() => _LocalizedLoginScreenExampleState();
}

class _LocalizedLoginScreenExampleState extends State<LocalizedLoginScreenExample> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: Uncomment after running flutter gen-l10n
    // final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'), // TODO: Replace with l10n.login
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome Back!', // TODO: Replace with l10n.welcome
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email', // TODO: Replace with l10n.email
                  hintText: 'Enter your email', // TODO: Add to localization files
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required'; // TODO: Replace with l10n.requiredField
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password', // TODO: Replace with l10n.password
                  hintText: 'Enter your password', // TODO: Add to localization files
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required'; // TODO: Replace with l10n.requiredField
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Implement login logic
                    }
                  },
                  child: const Text('Login'), // TODO: Replace with l10n.login
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to forgot password
                },
                child: const Text('Forgot Password?'), // TODO: Replace with l10n.forgotPassword
              ),
            ],
          ),
        ),
      ),
    );
  }
}
