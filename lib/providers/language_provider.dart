import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/location_data.dart';
import '../services/translation_service.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  Locale _currentLocale = const Locale('en');
  final TranslationService _translationService = TranslationService();
  
  Locale get currentLocale => _currentLocale;
  
  LanguageProvider() {
    _loadSavedLanguage();
  }
  
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey);
    if (savedLanguage != null) {
      _currentLocale = Locale(savedLanguage);
      notifyListeners();
    }
  }
  
  Future<void> changeLanguage(String languageCode) async {
    _currentLocale = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
    notifyListeners();
  }
  
  String get currentLanguageCode => _currentLocale.languageCode;
  
  bool get isEnglish => currentLanguageCode == 'en';
  bool get isHindi => currentLanguageCode == 'hi';
  
  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिंदी';
      default:
        return 'English';
    }
  }
  
  String getCurrentLanguageName() {
    return getLanguageName(currentLanguageCode);
  }

  // Get localized states list
  List<String> get localizedStates {
    return IndianLocation.getStatesDataForLanguage(currentLanguageCode)
        .map((state) => state['state'] as String)
        .toList();
  }

  // Get localized districts for a specific state
  List<String> getLocalizedDistricts(String state) {
    return IndianLocation.getDistrictsForLanguage(state, currentLanguageCode);
  }

  // Get the English equivalent of a localized state name
  String getEnglishStateName(String localizedState) {
    final hindiStates = IndianLocation.getStatesDataForLanguage('hi');
    final englishStates = IndianLocation.getStatesDataForLanguage('en');
    
    final hindiIndex = hindiStates.indexWhere((state) => state['state'] == localizedState);
    if (hindiIndex != -1) {
      return englishStates[hindiIndex]['state'] as String;
    }
    
    // If not found in Hindi, return the original (assuming it's already English)
    return localizedState;
  }

  // Get the English equivalent of a localized district name
  String getEnglishDistrictName(String localizedDistrict, String state) {
    final hindiDistricts = IndianLocation.getDistrictsForLanguage(state, 'hi');
    final englishDistricts = IndianLocation.getDistrictsForLanguage(state, 'en');
    
    final hindiIndex = hindiDistricts.indexWhere((district) => district == localizedDistrict);
    if (hindiIndex != -1) {
      return englishDistricts[hindiIndex];
    }
    
    // If not found in Hindi, return the original (assuming it's already English)
    return localizedDistrict;
  }

  // Translate dynamic API data
  Future<String> translateApiData(String text) async {
    if (currentLanguageCode == 'en') {
      return text; // Already in English
    }
    return await _translationService.translateText(text, currentLanguageCode);
  }

  // Translate a list of API data
  Future<List<String>> translateApiDataList(List<String> texts) async {
    if (currentLanguageCode == 'en') {
      return texts; // Already in English
    }
    return await _translationService.translateList(texts, currentLanguageCode);
  }

  // Translate a map of API data
  Future<Map<String, String>> translateApiDataMap(Map<String, String> textMap) async {
    if (currentLanguageCode == 'en') {
      return textMap; // Already in English
    }
    return await _translationService.translateMap(textMap, currentLanguageCode);
  }

  // Translate shop data (assuming it's a Map with string values)
  Future<Map<String, dynamic>> translateShopData(Map<String, dynamic> shopData) async {
    if (currentLanguageCode == 'en') {
      return shopData; // Already in English
    }

    Map<String, dynamic> translatedData = Map.from(shopData);
    
    // Translate common shop fields
    final fieldsToTranslate = [
      'name', 'description', 'address', 'category', 'subcategory',
      'services', 'specialties', 'about', 'highlights'
    ];

    for (String field in fieldsToTranslate) {
      if (translatedData.containsKey(field) && 
          translatedData[field] is String && 
          translatedData[field].toString().isNotEmpty) {
        translatedData[field] = await _translationService.translateText(
          translatedData[field].toString(), 
          currentLanguageCode
        );
      }
    }

    return translatedData;
  }
}
