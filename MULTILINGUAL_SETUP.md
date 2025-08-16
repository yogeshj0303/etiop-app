# Multilingual Support Setup Guide

This guide explains how to set up and use multilingual support for English and Hindi in the Etiop Application.

## Overview

The app now supports two languages:
- **English (en)** - Default language
- **Hindi (hi)** - Secondary language

## Files Structure

```
lib/
├── l10n/
│   ├── app_en.arb          # English localization strings
│   └── app_hi.arb          # Hindi localization strings
├── providers/
│   └── language_provider.dart  # Language state management
├── screens/
│   ├── language_settings_screen.dart  # Language selection UI
│   └── settings_screen.dart           # Main settings screen
└── main.dart                # App entry point with localization setup
```

## Setup Instructions

### 1. Dependencies

The following dependencies have been added to `pubspec.yaml`:

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  provider: ^6.1.2

flutter:
  generate: true  # Enable localization generation
```

### 2. Localization Files

#### English (app_en.arb)
Contains all English strings used in the app.

#### Hindi (app_hi.arb)
Contains Hindi translations for all strings.

### 3. Language Provider

The `LanguageProvider` class manages:
- Current language selection
- Language persistence using SharedPreferences
- Language change notifications

### 4. Main App Configuration

The `main.dart` file has been updated to include:
- Provider setup for state management
- Localization delegates
- Supported locales configuration
- Dynamic locale switching

## Usage

### 1. Accessing Localized Strings

Once the localization files are generated, you can access localized strings using:

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// In a widget build method
final l10n = AppLocalizations.of(context)!;
Text(l10n.welcome);  // Will show "Welcome" in English or "स्वागत है" in Hindi
```

### 2. Language Switching

Users can change the language through:
1. **Settings Screen** → **Language** → **Language Settings Screen**
2. Select desired language (English or Hindi)
3. Language changes are applied immediately and saved

### 3. Adding New Strings

To add new localized strings:

1. **Add to English file** (`app_en.arb`):
```json
{
  "newString": "New string in English"
}
```

2. **Add to Hindi file** (`app_hi.arb`):
```json
{
  "newString": "हिंदी में नई स्ट्रिंग"
}
```

3. **Use in code**:
```dart
Text(l10n.newString)
```

### 4. String Parameters

For strings with parameters, use placeholders:

```json
// English
{
  "greeting": "Hello, {name}!"
}

// Hindi
{
  "greeting": "नमस्ते, {name}!"
}
```

Usage:
```dart
Text(l10n.greeting('John'))  // "Hello, John!" or "नमस्ते, John!"
```

## Implementation Steps

### Step 1: Generate Localization Files

Run the following command to generate the localization files:

```bash
flutter gen-l10n
```

This will create the necessary Dart files in `lib/generated/`.

### Step 2: Update Existing Screens

Replace hardcoded strings with localized versions:

**Before:**
```dart
Text('Welcome')
```

**After:**
```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.welcome)
```

### Step 3: Test Language Switching

1. Run the app
2. Navigate to Settings → Language
3. Switch between English and Hindi
4. Verify that all text changes accordingly

## Best Practices

### 1. String Organization
- Group related strings together
- Use descriptive keys
- Maintain consistent naming conventions

### 2. Context-Aware Translations
- Consider cultural differences
- Ensure translations make sense in context
- Test with native speakers when possible

### 3. Fallback Handling
- Always provide English fallbacks
- Handle missing translations gracefully
- Log missing translations for debugging

### 4. Performance
- Localization files are loaded once at startup
- String lookups are efficient
- No performance impact during language switching

## Troubleshooting

### Common Issues

1. **Strings not updating**
   - Ensure `flutter gen-l10n` has been run
   - Check that the app is wrapped with `ChangeNotifierProvider`
   - Verify locale changes are triggering rebuilds

2. **Missing translations**
   - Check both `.arb` files have the same keys
   - Ensure proper JSON formatting
   - Verify locale codes match exactly

3. **Build errors**
   - Clean and rebuild the project
   - Check dependency versions
   - Verify `pubspec.yaml` configuration

### Debug Tips

1. **Check current locale:**
```dart
print('Current locale: ${context.locale}');
```

2. **Verify provider state:**
```dart
print('Language: ${context.read<LanguageProvider>().currentLanguageCode}');
```

3. **Test string access:**
```dart
try {
  final text = l10n.someString;
  print('String found: $text');
} catch (e) {
  print('String missing: $e');
}
```

## Future Enhancements

### 1. Additional Languages
To add more languages:
1. Create new `.arb` file (e.g., `app_es.arb` for Spanish)
2. Add locale to `supportedLocales` in `main.dart`
3. Translate all strings

### 2. RTL Support
For languages like Arabic or Hebrew:
1. Add RTL locale support
2. Update UI layouts for RTL
3. Test text alignment and navigation

### 3. Dynamic Language Loading
- Load languages from server
- Support for language packs
- Automatic language detection

## Support

For issues or questions regarding multilingual support:
1. Check this documentation
2. Review the example implementations
3. Check Flutter localization documentation
4. Contact the development team

---

**Note:** This implementation provides a solid foundation for multilingual support. The system is designed to be easily extensible for additional languages and features.
