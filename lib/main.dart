import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/theme_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define explicit black & white focused color schemes.
    const accentPurple = Color(0xFF9B59B6);

    final lightScheme = ColorScheme(
      brightness: Brightness.light,
      primary: const Color(0xFF212121), // appbar color as dark for contrast
      onPrimary: Colors.white,
      secondary: accentPurple,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      background: Colors.white,
      onBackground: Colors.black,
      surface: const Color(0xFFF5F5F7),
      onSurface: Colors.black,
      surfaceVariant: const Color(0xFFE0E0E0),
      onSurfaceVariant: Colors.black54,
      outline: Colors.black12,
      shadow: Colors.black,
      inverseSurface: Colors.black,
      inversePrimary: Colors.white,
    );

    final darkScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: const Color(0xFF1F1F1F),
      onPrimary: Colors.white,
      secondary: accentPurple,
      onSecondary: Colors.white,
      error: Colors.red.shade400,
      onError: Colors.black,
      background: const Color(0xFF121212),
      onBackground: Colors.white,
      surface: const Color(0xFF1C1C1E),
      onSurface: Colors.white,
      surfaceVariant: const Color(0xFF2C2C2E),
      onSurfaceVariant: Colors.white70,
      outline: Colors.white10,
      shadow: Colors.black,
      inverseSurface: Colors.white,
      inversePrimary: Colors.black,
    );

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'WHEELHOUSE',
          theme: ThemeData(colorScheme: lightScheme, useMaterial3: true),
          darkTheme: ThemeData(colorScheme: darkScheme, useMaterial3: true),
          themeMode: mode,
          home: const HomeScreen(),
        );
      },
    );
  }
}
