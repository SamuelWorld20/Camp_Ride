import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // App's main background color
      body: SafeArea( // Ensures content is not behind the status bar
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
                    color: Colors.yellow, // Using the yellow color
                  ),
                  const SizedBox(height: 24),
                  // "No notifications yet" text
                  Text(
                    'No notifications yet',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Using black text
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle text
                  Text(
                    'Your notification will appear here once you\'ve received them.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
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
                color: Colors.yellow, // Back button color is black
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
