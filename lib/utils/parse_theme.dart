import 'package:fluent_ui/fluent_ui.dart';

parseTheme(String theme) {
  switch (theme) {
    case "light":
      return ThemeMode.light;
    case "dark":
      return ThemeMode.dark;
  }
}
