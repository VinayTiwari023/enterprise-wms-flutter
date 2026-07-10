import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeViewModelProvider = ChangeNotifierProvider((ref) => ThemeViewModel());

class ThemeViewModel with ChangeNotifier {
  bool _isDarkMode = false;
  Color _currentThemeColor = const Color(0xFF635BFF);
  Locale _currentLocale = const Locale('en');

  bool get isDarkMode => _isDarkMode;
  Color get currentThemeColor => _currentThemeColor;
  Locale get currentLocale => _currentLocale;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _currentLocale = locale;
    notifyListeners();
  }

  void setThemeColor(Color color) {
    _currentThemeColor = color;
    notifyListeners();
  }

  ThemeData get themeData {
    return _isDarkMode ? _darkTheme : _lightTheme;
  }

  ThemeData get _lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: _currentThemeColor,
        scaffoldBackgroundColor: const Color(0xFFF4F7FA), // Soft blue-grey background
        colorScheme: ColorScheme.light(
          primary: _currentThemeColor,
          secondary: _currentThemeColor.withOpacity(0.8),
          surface: Colors.white,
          onSurface: const Color(0xFF1A1C1E),
          background: const Color(0xFFF4F7FA),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFFF4F7FA),
          foregroundColor: const Color(0xFF1A1C1E),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: const Color(0xFF1A1C1E),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );

  ThemeData get _darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: _currentThemeColor,
        scaffoldBackgroundColor: const Color(0xFF12121A),
        colorScheme: ColorScheme.dark(
          primary: _currentThemeColor,
          surface: const Color(0xFF1E1E26),
          onSurface: Colors.white,
          background: const Color(0xFF12121A),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1E26),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );
}
