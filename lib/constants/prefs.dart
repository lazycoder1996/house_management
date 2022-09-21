import 'package:flutter/material.dart';
import 'package:house_management/constants/constanst.dart';
import 'package:house_management/utils/parse_theme.dart';

import '../main.dart';

class Prefs extends ChangeNotifier {
  ThemeMode _themeMode =
      parseTheme(prefs.getString(AppConstants.theme) ?? "light");

  ThemeMode get themeMode => _themeMode;
  final bool _loggedIn = false;

  bool get loggedIn => _loggedIn;

  switchTheme() async {
    String theme = prefs.getString(AppConstants.theme) ?? "light";
    await prefs.setString(
        AppConstants.theme, theme == "light" ? "dark" : "light");
    getTheme();
  }

  getTheme() {
    String theme = prefs.getString(AppConstants.theme) ?? "light";
    _themeMode = parseTheme(theme);
    notifyListeners();
    return _themeMode;
  }

  isLoggedIn() {
    return prefs.getBool(AppConstants.loggedIn) ?? false;
  }
}
