import 'package:flutter/material.dart';
import 'package:futaride/screens/home_screen.dart'; // Adjust path

// Placeholder screens for other navigation bar items
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Profile Screen Content',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Settings Screen Content',
          style: TextStyle(fontSize: 24),
        ),
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
  // These are the pages the BottomNavigationBar will switch between.
  final List<Widget> _pages = [
    const KekeContactsListScreen(), // Your main Keke contacts list
    const ProfileScreen(), // Placeholder for Profile
    const SettingsScreen(), // Placeholder for Settings
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
      appBarTitle = 'Profile';
    } else if (_selectedIndex == 2) {
      appBarTitle = 'Settings';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor, // Use app's primary color
        foregroundColor: Colors.white, // Black text/icons on app bar
      ),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex, // Current selected item index
        selectedItemColor: Colors.yellow, // Yellow for selected icon/label
        unselectedItemColor: Colors.grey, // Grey for unselected icon/label
        onTap: _onItemTapped, // Callback when an item is tapped
        backgroundColor: Theme.of(context).colorScheme.surface, // White background for the bar
        type: BottomNavigationBarType.fixed, // Ensures labels are always visible
      ),
    );
  }
}
