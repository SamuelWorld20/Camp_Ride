import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthSession();
  }

  Future<void> _checkAuthSession() async {
    // Add a small delay to show the splash screen before navigating
    await Future.delayed(const Duration(seconds: 3));

    try {
      // Get the current user session
      final session = Supabase.instance.client.auth.currentSession;

      // Navigate to the appropriate screen based on the session
      if (session != null) {
        // If a session exists, navigate to the home screen
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // If no session, navigate to the auth screen
        Navigator.of(context).pushReplacementNamed('/auth');
      }
    } catch (e) {
      // Handle any potential errors, e.g., if Supabase isn't initialized
      print('Splash screen navigation error: $e');
      Navigator.of(context).pushReplacementNamed('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    // The UI for your splash screen. You can customize this.
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
