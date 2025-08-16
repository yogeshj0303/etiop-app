import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/location_data.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  Locale _currentLocale = const Locale('en');
  
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
}
