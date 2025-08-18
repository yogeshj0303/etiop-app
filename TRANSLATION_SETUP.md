# Dynamic API Data Translation Setup

This document explains how to implement dynamic API data translation in your Flutter app using the Google Translate service.

## Overview

The translation system automatically translates dynamic content from your API (which comes in English) to Hindi when the user selects Hindi as their language preference.

## Components

### 1. TranslationService (`lib/services/translation_service.dart`)
- Handles all translation operations using Google Translate
- Provides methods for translating individual strings, lists, and maps
- Automatically falls back to original text if translation fails

### 2. LanguageProvider (`lib/providers/language_provider.dart`)
- Manages language selection and persistence
- Integrates with TranslationService for API data translation
- Provides convenient methods for translating different data types

### 3. Translation Widgets (`lib/widgets/translated_text.dart`)
- `TranslatedText`: Automatically translates individual text strings
- `TranslatedList`: Translates lists of strings
- Handles loading states and fallbacks gracefully

### 4. Example Implementation (`lib/widgets/translated_shop_card.dart`)
- Shows how to use translation widgets in shop cards
- Demonstrates best practices for translating dynamic content

## Usage Examples

### Basic Text Translation

```dart
// Instead of regular Text widget
Text(shop.name)

// Use TranslatedText widget
TranslatedText(
  text: shop.name,
  style: TextStyle(fontSize: 16),
)
```

### List Translation

```dart
// Instead of regular ListView
ListView.builder(
  itemCount: shopNames.length,
  itemBuilder: (context, index) => Text(shopNames[index]),
)

// Use TranslatedList widget
TranslatedList(
  texts: shopNames,
  itemBuilder: (context, text, index) => Text(text),
)
```

### Programmatic Translation

```dart
// In your provider or service
final languageProvider = context.read<LanguageProvider>();

// Translate single text
String translated = await languageProvider.translateApiData(shop.name);

// Translate list
List<String> translated = await languageProvider.translateApiDataList(shopNames);

// Translate shop data
Map<String, dynamic> translatedShop = await languageProvider.translateShopData(shopData);
```

## How It Works

1. **Language Selection**: User selects Hindi in language settings
2. **API Data**: Your API returns data in English
3. **Automatic Translation**: Translation widgets automatically detect the current language
4. **Google Translate**: If Hindi is selected, text is sent to Google Translate API
5. **Display**: Translated text is displayed to the user

## Supported Languages

- **English** (en) - Default, no translation needed
- **Hindi** (hi) - Automatically translated from English

## Error Handling

- If translation fails, the original English text is displayed
- Loading states are handled gracefully
- Network errors don't crash the app

## Performance Considerations

- Translations are performed on-demand
- Consider implementing caching for frequently used translations
- Batch translations when possible using `translateApiDataList`

## Integration Steps

1. **Add Dependencies**: The `translator` package is already added to `pubspec.yaml`
2. **Import Widgets**: Import translation widgets where needed
3. **Replace Text Widgets**: Replace `Text` widgets with `TranslatedText` for dynamic content
4. **Test**: Change language settings and verify translations work

## Example: Shop Card Implementation

```dart
class ShopCard extends StatelessWidget {
  final Shop shop;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // Shop name - automatically translated
          TranslatedText(
            text: shop.shopName ?? 'Shop Name',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          
          // Description - automatically translated
          if (shop.description != null)
            TranslatedText(
              text: shop.description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          
          // Category - automatically translated
          if (shop.categoryName != null)
            TranslatedText(
              text: shop.categoryName!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),
    );
  }
}
```

## Notes

- The Google Translate API key is configured in the TranslationService
- Translations happen asynchronously to avoid blocking the UI
- The system automatically detects when language changes and re-translates content
- Static UI text (like button labels) should use the existing localization system
- Only dynamic API content should use the translation widgets
