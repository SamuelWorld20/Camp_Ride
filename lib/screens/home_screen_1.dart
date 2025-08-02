import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For making phone calls

// This is the standalone KekeContactsListScreen page.
// You can place this code in a separate file (e.g., 'keke_contacts_list_screen.dart')
// and import it into your main.dart or any other file where you want to use it.

class KekeContactsListScreen extends StatefulWidget {
  const KekeContactsListScreen({super.key});

  @override
  State<KekeContactsListScreen> createState() => _KekeContactsListScreenState();
}

class _KekeContactsListScreenState extends State<KekeContactsListScreen> {
  // In a real app, this data would typically come from a backend (like Firebase)
  // or a local database, and would be dynamically updated.
  // For this standalone example, it's hardcoded.
  final List<KekeRider> _riders = [
    KekeRider(name: 'Emeka Eze', contact: '08033334444', isBooked: false),
    KekeRider(name: 'Aisha Bello', contact: '09022225555', isBooked: false),
    KekeRider(name: 'Femi Adebayo', contact: '07088881111', isBooked: false),
    KekeRider(name: 'Ngozi Okoro', contact: '08144445555', isBooked: true), // Example booked rider
    KekeRider(name: 'Kingsley Uche', contact: '07066667777', isBooked: false),
    // Add more riders here as needed for testing
  ];

  /// Initiates a phone call to the given [phoneNumber].
  /// Uses the `url_launcher` package.
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    // Check if the URI can be launched before attempting to launch it
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // Show an error message if the phone app cannot be launched
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch phone dialer.')),
      );
    }
  }

  /// Toggles the booking status of a rider at a given [index].
  /// This update is local to the device in this example.
  /// For real-time updates across devices, Firebase integration is needed.
  void _toggleBookedStatus(int index) {
    setState(() {
      _riders[index].isBooked = !_riders[index].isBooked;
      // In a real app, you would also update this status in your Firebase database
      // or other backend here, along with a timestamp for auto-unbooking.
      // Example: _firebaseDatabaseRef.child(_riders[index].id).update({'isBooked': _riders[index].isBooked, 'bookedAt': ServerValue.timestamp});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keke Rider Contacts'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor, // Use app's primary color
        foregroundColor: Colors.white, // White text/icons on app bar
      ),
      body: ListView.builder(
        itemCount: _riders.length,
        itemBuilder: (context, index) {
          final rider = _riders[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0), // Rounded corners for cards
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: Icon(
                Icons.electric_rickshaw, // Keke icon
                size: 40,
                color: Theme.of(context).primaryColor, // Yellow icon
              ),
              title: Text(
                rider.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Contact: ${rider.contact}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.0,
                  ),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min, // Make the row take minimum space
                children: [
                  // Call Button
                  IconButton(
                    icon: Icon(
                      Icons.call,
                      color: Theme.of(context).primaryColor, // Yellow call icon
                      size: 28.0,
                    ),
                    onPressed: () => _makePhoneCall(rider.contact),
                    tooltip: 'Call ${rider.name}',
                  ),
                  const SizedBox(width: 8.0), // Spacer between buttons
                  // Booked/Available Button
                  ElevatedButton(
                    onPressed: () => _toggleBookedStatus(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: rider.isBooked ? Colors.grey[600] : Colors.green, // Grey if booked, green if available
                      foregroundColor: Colors.white, // White text on button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Slightly rounded button corners
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      elevation: 2.0,
                    ),
                    child: Text(
                      rider.isBooked ? 'Booked' : 'Available',
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A simple data model for a Keke Rider.
class KekeRider {
  final String name;
  final String contact;
  bool isBooked; // Represents the booking status

  KekeRider({required this.name, required this.contact, this.isBooked = false});
}
