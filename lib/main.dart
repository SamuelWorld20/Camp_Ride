import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:futaride/bottom_nav_bar.dart';
import 'package:futaride/theme_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();
 await Supabase.initialize(
     url: 'https://yhmprtprcjoeimpaieeq.supabase.co';
     anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlobXBydHByY2pvZWltcGFpZWVxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU3MDE1MDUsImV4cCI6MjA3MTI3NzUwNX0.vqlLE218TSLFKZVKkpKmyxt9Xc9ECJ06gGVzARM_2gE';
 );
    routes: {
        '/home': (context) => const HomeScreenWithNavBar(),
    },
    
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
      primaryColor: Colors.yellow, // This is the primary yellow for accents
      scaffoldBackgroundColor: Colors.white, // Default background for scaffolds
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white, // AppBar background is WHITE in light mode
        foregroundColor: Colors.yellow, // Icons/text on AppBar are BLACK
        elevation: 4, // Add a slight shadow
      ),
      colorScheme: const ColorScheme.light(
        primary: Colors.yellow, // Yellow for primary elements
        onPrimary: Colors.black, // Text/icons on yellow elements
        surface: Colors.white, // Card/surface background color
        onSurface: Colors.black, // Text color on surfaces
        background: Colors.black, // Main background color (like the top part of auth screens)
        onBackground: Colors.white, // Text color on the background
        error: Colors.red,
        onError: Colors.white,
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
      primaryColor: Colors.yellow, // This is the primary yellow for accents
      scaffoldBackgroundColor: Colors.black, // Default background for scaffolds
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black, // AppBar background is BLACK in dark mode
        foregroundColor: Colors.yellow, // Icons/text on AppBar are WHITE
        elevation: 4, // Add a slight shadow
      ),
      colorScheme: const ColorScheme.dark(
        primary: Colors.yellow, // Yellow for primary elements
        onPrimary: Colors.black, // Text/icons on yellow elements
        surface: Colors.black, // Card/surface background color
        onSurface: Colors.white, // Text color on surfaces
        background: Colors.black, // Main background color
        onBackground: Colors.white, // Text color on the background
        error: Colors.red,
        onError: Colors.white,
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
      home: const AuthScreen(),
    );
  }
}