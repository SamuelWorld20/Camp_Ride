import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import 'package:url_launcher/url_launcher.dart';
import 'dart:async'; // Required for the Timer class

const  supabaseUrl = 'https://yhmprtprcjoeimpaieeq.supabase.co';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlobXBydHByY2pvZWltcGFpZWVxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU3MDE1MDUsImV4cCI6MjA3MTI3NzUwNX0.vqlLE218TSLFKZVKkpKmyxt9Xc9ECJ06gGVzARM_2gE';
// Initialize Supabase client
final supabase = Supabase.instance.client;

class KekeContactsListScreen extends StatefulWidget {
  const KekeContactsListScreen({super.key});

  @override
  State<KekeContactsListScreen> createState() => _KekeContactsListScreenState();
}

class _KekeContactsListScreenState extends State<KekeContactsListScreen> {
  // A static list of riders with their Supabase IDs.
  // NOTE: You must replace these IDs with the actual IDs from your Supabase 'profiles' table.
  List<KekeRider> _riders = [
    KekeRider(id: '849c5798-04cc-4ee5-b184-e70e6e80e655', name: 'Emeka Eze', contact: '08033334444', review: 'Emeka is a very reliable driver, always punctual and friendly!', isBooked: false),
    KekeRider(id: '339722de-e500-4250-beda-c395c90f1a77', name: 'Aisha Bello', contact: '09022225555', review: 'Aisha is great! Her Keke is always clean and she knows the best routes to avoid traffic.', isBooked: false),
    KekeRider(id: '138626fd-ce44-4c2d-9a07-d53cb8982900', name: 'Femi Adebayo', contact: '07088881111', review: 'Femi is a calm and safe driver. A pleasure to ride with.', isBooked: false),
    KekeRider(id: '648476d3-d136-4536-8f8f-46a58d7eae5e', name: 'Ngozi Okoro', contact: '08144445555', review: 'Ngozi is booked often for a reason! She is the best and always has her cool in traffic.', isBooked: false),
    KekeRider(id: '63cab08f-5853-4871-a765-9fc35b08fd32', name: 'Kingsley Uche', contact: '07066667777', review: 'Kingsley is new but very professional. Highly recommended!', isBooked: false),
  ];
  Timer? _statusCheckTimer;

  @override
  void initState() {
    super.initState();
    // Start a periodic timer to check for status updates and revert them if necessary.
    _startStatusCheckTimer();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to prevent memory leaks
    _statusCheckTimer?.cancel();
    super.dispose();
  }

  /// Starts a periodic timer to fetch and check rider statuses.
  void _startStatusCheckTimer() {
    // This timer will run every 30 seconds to refresh the local list with latest status from Supabase.
    _statusCheckTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _fetchRiderStatuses();
    });
    // Call it once immediately to load the initial data
    _fetchRiderStatuses();
  }

  /// Fetches the latest statuses from Supabase and updates the local list.
  Future<void> _fetchRiderStatuses() async {
    try {
      final List<String> riderIds = _riders.map((rider) => rider.id).toList();

      final response = await supabase
          .from('profiles')
          .select('id, status, status_updated_at')
          .in_('id', riderIds);

      // Create a map for quick lookup
      final Map<String, dynamic> statusMap = {};
      List<String> ridersToRevert = [];

      for (var row in response) {
        statusMap[row['id']] = row;
        final status = row['status'] as String? ?? 'available';
        final lastUpdatedString = row['status_updated_at'] as String?;
        final twentyMinutesAgo = DateTime.now().subtract(const Duration(minutes: 20));

        if (status == 'booked' && lastUpdatedString != null) {
          final lastUpdated = DateTime.parse(lastUpdatedString);
          if (lastUpdated.isBefore(twentyMinutesAgo)) {
            ridersToRevert.add(row['id'] as String);
          }
        }
      }

      // If there are riders to revert, perform the update in the database.
      if (ridersToRevert.isNotEmpty) {
        await supabase
            .from('profiles')
            .update({'status': 'available'})
            .in_('id', ridersToRevert);
      }

      // Update the local list with the latest data from the map
      setState(() {
        _riders = _riders.map((rider) {
          final riderData = statusMap[rider.id];
          if (riderData != null) {
            final newStatus = riderData['status'] as String? ?? 'available';
            rider.isBooked = newStatus == 'booked';
          }
          return rider;
        }).toList();
      });

    } catch (e) {
      print('Error fetching rider statuses: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load status updates from server.')),
      );
    }
  }

  /// Toggles the rider's status in the database.
  Future<void> _toggleBookedStatus(KekeRider rider) async {
    final newStatus = rider.isBooked ? 'available' : 'booked';
    try {
      await supabase
          .from('profiles')
          .update({
            'status': newStatus,
            'status_updated_at': DateTime.now().toIso8601String()
          })
          .eq('id', rider.id);

      // Update the local state immediately for a smooth UI
      setState(() {
        rider.isBooked = !rider.isBooked;
      });

      // Show a snackbar to confirm the action
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${rider.name} is now ${newStatus.toUpperCase()}')),
      );
    } catch (e) {
      print('Error updating status for ${rider.name}: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update status.')),
      );
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch phone dialer.')),
      );
    }
  }

  /// Displays a pop-up dialog with the rider's details.
  void _showRiderDetailsDialog(KekeRider rider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Determine avatar background color based on current theme brightness
        final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final Color avatarBgColor = isDarkMode ? Colors.black : Colors.white;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Center(
            child: Text(
              'Rider Details',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // The big round picture in the pop-up
                CircleAvatar(
                  radius: 50,
                  backgroundColor: avatarBgColor, // Dynamic background
                  child: Icon(
                    Icons.electric_rickshaw,
                    size: 60,
                    color: Theme.of(context).primaryColor, // Yellow icon
                  ),
                ),
                const SizedBox(height: 16),
                // Rider's Full Name
                Text(
                  rider.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                // Rider's Phone Number
                Text(
                  rider.contact,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                // Availability Status
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: rider.isBooked ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    rider.isBooked ? 'Booked' : 'Available',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Review Section
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'Review',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  rider.review,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Close',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine avatar background color based on current theme brightness
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color avatarBgColor = isDarkMode ? Colors.black : Colors.white;

    return ListView.builder(
      itemCount: _riders.length,
      itemBuilder: (context, index) {
        final rider = _riders[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            // The small round picture on the left
            leading: GestureDetector(
              onTap: () => _showRiderDetailsDialog(rider),
              child: CircleAvatar(
                backgroundColor: avatarBgColor, // Dynamic background
                child: Icon(
                  Icons.electric_rickshaw,
                  size: 24,
                  color: Theme.of(context).primaryColor, // Yellow icon
                ),
              ),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.call,
                    color: Theme.of(context).primaryColor,
                    size: 28.0,
                  ),
                  onPressed: () => _makePhoneCall(rider.contact),
                  tooltip: 'Call ${rider.name}',
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () => _toggleBookedStatus(rider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rider.isBooked ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
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
    );
  }
}

class KekeRider {
  final String id;
  final String name;
  final String contact;
  final String review;
  bool isBooked;

  KekeRider({
    required this.id,
    required this.name,
    required this.contact,
    required this.review,
    this.isBooked = false,
  });
}
