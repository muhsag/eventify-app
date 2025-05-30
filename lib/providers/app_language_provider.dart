import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class AppLanguageProvider extends ChangeNotifier {
  Locale _locale;
  
  AppLanguageProvider(this._locale);
  
  Locale get locale => _locale;
  
  Future<void> changeLanguage(Locale locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    
    // Save language preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    
    notifyListeners();
  }
  
  // Check if current locale is RTL
  bool get isRtl => _locale.languageCode == 'ar' || 
                    ui.window.locale.languageCode == 'ar';
}
