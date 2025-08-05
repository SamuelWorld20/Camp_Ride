import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:futaride/bottom_nav_bar.dart';
import 'package:futaride/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Define your app's custom light theme
    final lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.yellow,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
      ),
      colorScheme: const ColorScheme.light(
        primary: Colors.yellow,
        onPrimary: Colors.black,
        surface: Colors.white,
        onSurface: Colors.black,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(color: Colors.black),
        titleMedium: TextStyle(color: Colors.black),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white; // White thumb when selected (dark mode)
          }
          return Colors.yellow; // Yellow thumb when unselected (light mode)
        }),
        trackColor: MaterialStateProperty.all(Colors.grey),
      ),
    );

    // Define your app's custom dark theme
    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.yellow,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
      ),
      colorScheme: const ColorScheme.dark(
        primary: Colors.yellow,
        onPrimary: Colors.black,
        surface: Colors.black,
        onSurface: Colors.white,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.black; // Black thumb when selected (dark mode)
          }
          return Colors.white; // White thumb when unselected (light mode)
        }),
        trackColor: MaterialStateProperty.all(Colors.grey),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Keke Riders',
      themeMode: themeProvider.themeMode, // Controlled by the provider
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const HomeScreenWithNavBar(),
    );
  }
}
