import 'package:flutter/material.dart';

/// A simple global theme controller used by the app to toggle light/dark mode.
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

void toggleTheme() {
  themeNotifier.value = themeNotifier.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
}
