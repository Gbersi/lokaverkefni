import 'package:flutter/material.dart';
import 'package:spilakvold/services/theme_animations_updates.dart';


class ThemeNotifier extends ChangeNotifier {
  ThemeData _currentTheme;
  bool _isDarkMode = false;
  bool _isCustomTheme = false;

  ThemeNotifier()
      : _currentTheme = AppThemes.lightTheme;

  ThemeData get currentTheme => _currentTheme;
  bool get isDarkTheme => _isDarkMode;
  bool get isLightTheme => !_isDarkMode && !_isCustomTheme;
  bool get isCustomTheme => _isCustomTheme;

  void setThemeMode(ThemeMode mode) {
    if (mode == ThemeMode.dark) {
      _isDarkMode = true;
      _isCustomTheme = false;
      _currentTheme = AppThemes.darkTheme;
    } else if (mode == ThemeMode.light) {
      _isDarkMode = false;
      _isCustomTheme = false;
      _currentTheme = AppThemes.lightTheme;
    }
    notifyListeners();
  }

  void setCustomTheme() {
    _isCustomTheme = true;
    _isDarkMode = false;
    _currentTheme = AppThemes.customTheme;
    notifyListeners();
  }

  void toggleTheme() {
    if (_isDarkMode) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.dark);
    }
  }
}