import 'package:flutter/material.dart';
import 'package:activityapp/services//theme_animations_updates.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData = AppThemes.lightTheme;

  ThemeData get themeData => _themeData;

  void setTheme(String theme) {
    switch (theme) {
      case 'Dark':
        _themeData = AppThemes.darkTheme;
        break;
      case 'Custom':
        _themeData = AppThemes.customTheme;
        break;
      case 'Light':
      default:
        _themeData = AppThemes.lightTheme;
    }
    notifyListeners();
  }
}
