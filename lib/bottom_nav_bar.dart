import 'package:flutter/material.dart';
import 'package:futaride/screens/home_screen.dart';
// import 'package:your_app_name/school_map_screen.dart';
import 'package:futaride/screens/notification_screen.dart';
import 'package:futaride/screens/profile_screen.dart'; // Ensure ProfileScreen is imported

// Placeholder screens for other navigation bar items
// Note: ProfileScreen and SettingsScreen are now proper widgets
// that will inherit the Scaffold from HomeScreenWithNavBar.
// Their internal Scaffold and AppBar should be removed if they had them,
// similar to how KekeContactsListScreen was adjusted.
// For this example, I'll make them return just a Center widget.

class SchoolMapScreen extends StatelessWidget {
  const SchoolMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
          'School Map Screen Content',
          style: TextStyle(fontSize: 24),
        ),
      );
  }
}

class HomeScreenWithNavBar extends StatefulWidget {
  const HomeScreenWithNavBar({super.key});

  @override
  State<HomeScreenWithNavBar> createState() => _HomeScreenWithNavBarState();
}

class _HomeScreenWithNavBarState extends State<HomeScreenWithNavBar> {
  int _selectedIndex = 0; // Index of the currently selected tab

  // List of widgets (screens) to display in the body of the Scaffold
  final List<Widget> _pages = [
    const KekeContactsListScreen(), // Index 0: Keke contacts list
    const SchoolMapScreen(),        // Index 1: The new map screen
    const ProfileScreen(),          // Index 2: Profile Screen
];

  // Function to handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine the title based on the selected index
    String appBarTitle = 'Keke Rider Contacts';
    if (_selectedIndex == 1) {
      appBarTitle = 'School Map';
    } else if (_selectedIndex == 2) {
      appBarTitle = 'Profile';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
        // --- FIX START ---
        // Use the AppBarTheme's background and foreground colors defined in main.dart
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        // --- FIX END ---
        elevation: Theme.of(context).appBarTheme.elevation, // Ensure elevation is also inherited
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsScreen()),
              );
            },
            tooltip: 'Notifications',
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor, // Yellow for selected icon/label
        unselectedItemColor: Colors.grey, // Grey for unselected icon/label
        onTap: _onItemTapped,
        backgroundColor: Theme.of(context).colorScheme.surface, // White/Black background for the bar
        type: BottomNavigationBarType.fixed, // Ensures labels are always visible
      ),
    );
  }
}
