import 'package:flutter/material.dart';
import 'package:futaride/screens/home_screen.dart';
import'package:futaride/screens/profile_screen.dart';
// import 'package:your_app_name/school_map_screen.dart';
import 'package:futaride/screens/notification_screen.dart'; // Import the notifications screen

// Placeholder screens for other navigation bar items

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
          'Map Screen Content',
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
    const KekeContactsListScreen(),
    const MapScreen(),
    const ProfileScreen(),          // Index 2: Placeholder for Profile
            // Index 3: Placeholder for Settings
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
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.yellow,
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
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Theme.of(context).colorScheme.surface,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
