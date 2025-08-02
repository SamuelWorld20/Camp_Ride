import 'package:flutter/material.dart';
import 'package:futaride/screens/login.dart';
import 'package:futaride/screens/sign_up.dart';
import 'package:futaride/screens/home_screen.dart';
import 'package:futaride/screens/auth_screen.dart';

void main() {

  runApp(const KekeApp());

}

class KekeApp extends StatefulWidget {

  const KekeApp({super.key});

  @override

  State<KekeApp> createState() => _KekeAppState();

}

class _KekeAppState extends State<KekeApp> {

  // Define light theme: White and Yellow

  final ThemeData lightTheme = ThemeData(

    brightness: Brightness.light,

    primarySwatch: Colors.yellow, // Primary color for the app

    colorScheme: const ColorScheme.light(

      primary: Color(0xFFFFD700), // A bright yellow for primary elements

      secondary: Color(0xFFFFD700), // Secondary also yellow

      surface: Colors.white, // Card/surface background color

      onSurface: Colors.black, // Text color on surfaces

      background: Colors.black, // Main background color (like the top part of auth screens)

      onBackground: Colors.white, // Text color on the background

      error: Colors.red,

      onError: Colors.white,

    ),

    appBarTheme: const AppBarTheme(

      backgroundColor: Color(0xFFFFD700), // Yellow AppBar for main screens

      elevation: 4, // Add a slight shadow

      foregroundColor: Colors.black, // Icons/text on AppBar are black

    ),

    // Define default input decoration theme

    inputDecorationTheme: InputDecorationTheme(

      filled: true,

      fillColor: Colors.grey[200], // Light grey fill for input fields

      border: OutlineInputBorder(

        borderRadius: BorderRadius.circular(15.0),

        borderSide: BorderSide.none, // No default border line

      ),

      focusedBorder: OutlineInputBorder(

        borderRadius: BorderRadius.circular(15.0),

        borderSide: const BorderSide(color: Color(0xFFFFD700), width: 2.0), // Yellow focus border

      ),

      labelStyle: TextStyle(color: Colors.black.withOpacity(0.7)), // Label text color

      prefixIconColor: Colors.black.withOpacity(0.7), // Prefix icon color

      suffixIconColor: Colors.black.withOpacity(0.7), // Suffix icon color

    ),

    // Define default elevated button theme

    elevatedButtonTheme: ElevatedButtonThemeData(

      style: ElevatedButton.styleFrom(

        backgroundColor: const Color(0xFFFFD700), // Yellow button background

        foregroundColor: Colors.black, // Black text on button

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(15.0),

        ),

        padding: const EdgeInsets.symmetric(vertical: 16.0),

      ),

    ),

    // Define default outlined button theme

    outlinedButtonTheme: OutlinedButtonThemeData(

      style: OutlinedButton.styleFrom(

        foregroundColor: Colors.black, // Black text for outlined buttons

        side: BorderSide(color: Colors.black.withOpacity(0.5)), // Grey border

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(15.0),

        ),

        padding: const EdgeInsets.symmetric(vertical: 12.0),

      ),

    ),

    // Define checkbox theme

    checkboxTheme: CheckboxThemeData(

      fillColor: MaterialStateProperty.resolveWith((states) {

        if (states.contains(MaterialState.selected)) {

          return const Color(0xFFFFD700); // Yellow when selected

        }

        return Colors.grey[400]; // Grey when unselected

      }),

      checkColor: MaterialStateProperty.all(Colors.black), // Black checkmark

    ),

    // Define text button theme

    textButtonTheme: TextButtonThemeData(

      style: TextButton.styleFrom(

        foregroundColor: const Color(0xFFFFD700), // Yellow text for text buttons

      ),

    ),

  );

  // Define dark theme: Black and Yellow

  final ThemeData darkTheme = ThemeData(

    brightness: Brightness.dark,

    primarySwatch: Colors.yellow, // Primary color for the app

    colorScheme: const ColorScheme.dark(

      primary: Color(0xFFFFD700), // A bright yellow for primary elements

      secondary: Color(0xFFFFD700), // Secondary also yellow

      surface: Colors.black, // Card/surface background color

      onSurface: Colors.white, // Text color on surfaces

      background: Colors.black, // Main background color

      onBackground: Colors.white, // Text color on the background

      error: Colors.red,

      onError: Colors.white,

    ),

    appBarTheme: const AppBarTheme(

      backgroundColor: Color(0xFFFFD700), // Yellow AppBar for main screens

      elevation: 4, // Add a slight shadow

      foregroundColor: Colors.black, // Icons/text on AppBar are black

    ),

    // Define default input decoration theme

    inputDecorationTheme: InputDecorationTheme(

      filled: true,

      fillColor: Colors.grey[800], // Dark grey fill for input fields

      border: OutlineInputBorder(

        borderRadius: BorderRadius.circular(15.0),

        borderSide: BorderSide.none,

      ),

      focusedBorder: OutlineInputBorder(

        borderRadius: BorderRadius.circular(15.0),

        borderSide: const BorderSide(color: Color(0xFFFFD700), width: 2.0),

      ),

      labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),

      prefixIconColor: Colors.white.withOpacity(0.7),

      suffixIconColor: Colors.white.withOpacity(0.7),

    ),

    // Define default elevated button theme

    elevatedButtonTheme: ElevatedButtonThemeData(

      style: ElevatedButton.styleFrom(

        backgroundColor: const Color(0xFFFFD700), // Yellow button background

        foregroundColor: Colors.black, // Black text on button

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(15.0),

        ),

        padding: const EdgeInsets.symmetric(vertical: 16.0),

      ),

    ),

    // Define default outlined button theme

    outlinedButtonTheme: OutlinedButtonThemeData(

      style: OutlinedButton.styleFrom(

        foregroundColor: Colors.white, // White text for outlined buttons

        side: BorderSide(color: Colors.white.withOpacity(0.5)), // Grey border

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(15.0),

        ),

        padding: const EdgeInsets.symmetric(vertical: 12.0),

      ),

    ),

    // Define checkbox theme

    checkboxTheme: CheckboxThemeData(

      fillColor: MaterialStateProperty.resolveWith((states) {

        if (states.contains(MaterialState.selected)) {

          return const Color(0xFFFFD700); // Yellow when selected

        }

        return Colors.grey[600]; // Dark grey when unselected

      }),

      checkColor: MaterialStateProperty.all(Colors.black), // Black checkmark

    ),

    // Define text button theme

    textButtonTheme: TextButtonThemeData(

      style: TextButton.styleFrom(

        foregroundColor: const Color(0xFFFFD700), // Yellow text for text buttons

      ),

    ),

  );

  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'Keke App',

      theme: lightTheme, // Default light theme

      darkTheme: darkTheme, // Dark theme

      themeMode: ThemeMode.system, // Automatically switch based on system settings

      debugShowCheckedModeBanner: false, // Remove debug banner

      // Set KekeContactsListScreen as the home page directly

      home: const KekeContactsListScreen(),

    );

  }

}