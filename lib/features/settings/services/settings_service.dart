import 'package:flutter/material.dart';

class SettingsService {
  // To be implemented with Hive or SharedPreferences
  Future<void> saveThemeMode(bool isDark) async {}
  Future<bool> getThemeMode() async => false;
  
  Future<void> saveLanguage(String languageCode) async {}
  Future<String> getLanguage() async => 'en';
}
