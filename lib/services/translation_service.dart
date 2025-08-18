import 'package:translator/translator.dart';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();

  final translator = GoogleTranslator();

  /// Translate text from English to Hindi
  Future<String> translateToHindi(String text) async {
    if (text.isEmpty) return text;
    
    try {
      final translation = await translator.translate(
        text,
        from: 'en',
        to: 'hi',
      );
      return translation.text;
    } catch (e) {
      // If translation fails, return original text
      print('Translation error: $e');
      return text;
    }
  }

  /// Translate text from Hindi to English
  Future<String> translateToEnglish(String text) async {
    if (text.isEmpty) return text;
    
    try {
      final translation = await translator.translate(
        text,
        from: 'hi',
        to: 'en',
      );
      return translation.text;
    } catch (e) {
      // If translation fails, return original text
      print('Translation error: $e');
      return text;
    }
  }

  /// Translate text based on target language
  Future<String> translateText(String text, String targetLanguage) async {
    if (text.isEmpty) return text;
    
    if (targetLanguage == 'hi') {
      return await translateToHindi(text);
    } else {
      return await translateToEnglish(text);
    }
  }

  /// Translate a list of strings
  Future<List<String>> translateList(List<String> texts, String targetLanguage) async {
    List<String> translatedTexts = [];
    
    for (String text in texts) {
      String translated = await translateText(text, targetLanguage);
      translatedTexts.add(translated);
    }
    
    return translatedTexts;
  }

  /// Translate a map of strings
  Future<Map<String, String>> translateMap(Map<String, String> textMap, String targetLanguage) async {
    Map<String, String> translatedMap = {};
    
    for (MapEntry<String, String> entry in textMap.entries) {
      String translated = await translateText(entry.value, targetLanguage);
      translatedMap[entry.key] = translated;
    }
    
    return translatedMap;
  }
}
