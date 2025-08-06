import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine if the current theme is dark mode
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define colors based on the current theme
    final Color backgroundColor = Theme.of(context).colorScheme.surface; // White for light, Black for dark
    final Color primaryIconColor = Theme.of(context).primaryColor; // Yellow for icon
    final Color mainTextColor = Theme.of(context).colorScheme.onSurface; // Black for light, White for dark
    final Color backButtonColor = Theme.of(context).colorScheme.onSurface; // Black for light, White for dark
    final Color subtitleColor = Colors.grey[600]!; // Subtitle remains grey

    return Scaffold(
      backgroundColor: backgroundColor, // Dynamic background color
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mailbox Icon
                  Icon(
                    Icons.mark_email_unread_outlined,
                    size: 100,
                    color: primaryIconColor, // Yellow icon in both modes
                  ),
                  const SizedBox(height: 24),
                  // "No notifications yet" text
                  Text(
                    'No notifications yet',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: mainTextColor, // Dynamic text color
                        ),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle text
                  Text(
                    'Your notification will appear here once you\'ve received them.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: subtitleColor, // Grey subtitle in both modes
                        ),
                  ),
                ],
              ),
            ),
            // Custom back button positioned at the top-left corner
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: backButtonColor, // Dynamic back button color
                iconSize: 28,
                onPressed: () {
                  Navigator.pop(context); // Navigate back to the home screen
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
