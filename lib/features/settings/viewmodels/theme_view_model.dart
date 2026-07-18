import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents the immutable state of the application's theme and localization.
class ThemeState {
  final bool isDarkMode;
  final Color currentThemeColor;
  final Locale currentLocale;

  const ThemeState({
    this.isDarkMode = false,
    this.currentThemeColor = const Color(0xFF635BFF),
    this.currentLocale = const Locale('en'),
  });

  ThemeState copyWith({
    bool? isDarkMode,
    Color? currentThemeColor,
    Locale? currentLocale,
  }) {
    return ThemeState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      currentThemeColor: currentThemeColor ?? this.currentThemeColor,
      currentLocale: currentLocale ?? this.currentLocale,
    );
  }

  /// Returns the computed ThemeData based on current state.
  ThemeData get themeData => isDarkMode ? _darkTheme : _lightTheme;

  ThemeData get _lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: currentThemeColor,
        scaffoldBackgroundColor: const Color(0xFFF4F7FA),
        colorScheme: ColorScheme.light(
          primary: currentThemeColor,
          secondary: currentThemeColor.withValues(alpha: 0.8),
          surface: const Color(0xFFF4F7FA),
          onSurface: const Color(0xFF1A1C1E),
          outline: Colors.black.withValues(alpha: 0.05),
        ),
        dividerTheme: DividerThemeData(
          color: Colors.black.withValues(alpha: 0.05),
          thickness: 1,
          space: 1,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF4F7FA),
          foregroundColor: Color(0xFF1A1C1E),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF1A1C1E),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
          ),
        ),
      );

  ThemeData get _darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: currentThemeColor,
        scaffoldBackgroundColor: const Color(0xFF12121A),
        colorScheme: ColorScheme.dark(
          primary: currentThemeColor,
          surface: const Color(0xFF12121A),
          onSurface: Colors.white,
          outline: Colors.white.withValues(alpha: 0.1),
        ),
        dividerTheme: DividerThemeData(
          color: Colors.white.withValues(alpha: 0.1),
          thickness: 1,
          space: 1,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1E26),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
        ),
      );
}

/// A Notifier-based ViewModel for managing global theme and localization settings.
class ThemeViewModel extends Notifier<ThemeState> {
  @override
  ThemeState build() {
    return const ThemeState();
  }

  void toggleTheme() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void setLocale(Locale locale) {
    state = state.copyWith(currentLocale: locale);
  }

  void setThemeColor(Color color) {
    state = state.copyWith(currentThemeColor: color);
  }
}

/// Provider for the ThemeViewModel using the modern NotifierProvider.
final themeViewModelProvider = NotifierProvider<ThemeViewModel, ThemeState>(() {
  return ThemeViewModel();
});
