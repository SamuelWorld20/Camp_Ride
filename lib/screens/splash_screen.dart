import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async'; // Required for the Timer class
import 'package:futaride/main.dart';

// Import the next screen you want to navigate to after the splash screen.
// You will need to replace this with your actual next screen's import path.
// For example: import 'package:futaride/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _textAnimation;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller with a duration of 2 seconds
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );

    // Create a slide animation for the text, from below the screen to the center
    _textAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start from bottom
      end: const Offset(0.0, 0.0),   // End at its final position
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.5, curve: Curves.easeInOut), // Start halfway through the animation
    ));

    // Create a fade animation for the icon, fading from full opacity to zero
    _iconAnimation = Tween<double>(
      begin: 1.0, // Fully opaque
      end: 0.0,   // Fully transparent
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 3.0, curve: Curves.easeInOut), // Fade out in the first half
    ));

    // Start the animation when the widget is first loaded
    _controller.forward();

    // Call your existing authentication logic after a delay
    _checkAuthSession();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkAuthSession() async {
    // Add a small delay to show the splash screen before navigating
    // This is now based on the total animation duration plus a bit extra
    await Future.delayed(const Duration(milliseconds: 5500));

    try {
      final session = Supabase.instance.client.auth.currentSession;

      if (mounted) { // Check if the widget is still in the tree before navigating
        if (session != null) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          Navigator.of(context).pushReplacementNamed('/auth');
        }
      }
    } catch (e) {
      print('Splash screen navigation error: $e');
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/auth');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Use a clean, white background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated builder for the icon fade animation
            FadeTransition(
              opacity: _iconAnimation,
              child: Icon(
                Icons.electric_rickshaw,
                size: 80,
                color: Colors.yellow, // Use a black color for the icon
              ),
            ),
            SizedBox(height: 16),
            // Animated builder for the text slide animation
            SlideTransition(
              position: _textAnimation,
              child: Text(
                'Camp Ride',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Use a black color for the text
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
