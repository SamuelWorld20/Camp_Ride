import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:futaride/theme_provider.dart';
import 'package:futaride/bottom_nav_bar.dart'; // Ensure this file exists
import 'package:futaride/screens/auth_screen.dart'; // Ensure this file exists

// Define your Supabase constants outside of the main function for clarity
const supabaseUrl = 'https://yhmprtprcjoeimpaieeq.supabase.co';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlobXBydHByY2pvZWltcGFpZWVxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU3MDE1MDUsImV4cCI6MjA3MTI3NzUwNX0.vqlLE218TSLFKZVKkpKmyxt9Xc9ECJ06gGVzARM_2gE';

Future<void> main() async {
  // Ensure the Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase. This must be done inside an async function.
  // Note the corrected syntax with a comma separating the named parameters.
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  
  // The runApp call should wrap the entire widget tree, including the provider.
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
    // Access the ThemeProvider from the widget tree
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Define your app's custom light theme
    final lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.yellow, // This is the primary yellow for accents
      scaffoldBackgroundColor: Colors.white, // Default background for scaffolds
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white, // AppBar background is WHITE in light mode
        foregroundColor: Colors.black, // Icons/text on AppBar are BLACK
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
      initialRoute: '/auth', // Use initialRoute for navigation
      routes: {
        '/home': (context) => const HomeScreenWithNavBar(),
        '/auth': (context) => const AuthScreen(),
      },
      // You can remove the home property since you are using routes
      // home: const AuthScreen(),
    );
  }
}

// NOTE: You will need to make sure the files home_screen.dart, auth_screen.dart,
// and theme_provider.dart exist in your lib/ folder for this to compile correctly.
// You also need to have `provider` and `supabase_flutter` in your pubspec.yaml.
