import 'package:flutter/material.dart';

import 'app_theme.dart';

class ThemeManager extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData? _lightTheme;
  ThemeData? _darkTheme;

  ThemeData get lightTheme => _lightTheme!;
  ThemeData get darkTheme => _darkTheme!;

  Future<void> initThemes() async {
    _lightTheme = await loadCustomTheme(isDark: false);
    _darkTheme = await loadCustomTheme(isDark: true);
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void toggleThemeTo(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }

  ThemeData get currentTheme => _isDarkMode ? _darkTheme! : _lightTheme!;
}