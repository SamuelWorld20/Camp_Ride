import'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// This screen now only contains the content for the Keke Rider Contacts list.

// The Scaffold and AppBar are managed by the parent HomeScreenWithNavBar.

class KekeContactsListScreen extends StatefulWidget {

  const KekeContactsListScreen({super.key});

  @override

  State<KekeContactsListScreen> createState() => _KekeContactsListScreenState();

}

class _KekeContactsListScreenState extends State<KekeContactsListScreen> {

  final List<KekeRider> _riders = [

    KekeRider(name: 'Emeka Eze', contact: '08033334444', review: 'Emeka is a very reliable driver, always punctual and friendly!', isBooked: false),

    KekeRider(name: 'Aisha Bello', contact: '09022225555', review: 'Aisha is great! Her Keke is always clean and she knows the best routes to avoid traffic.', isBooked: false),

    KekeRider(name: 'Femi Adebayo', contact: '07088881111', review: 'Femi is a calm and safe driver. A pleasure to ride with.', isBooked: false),

    KekeRider(name: 'Ngozi Okoro', contact: '08144445555', review: 'Ngozi is booked often for a reason! She is the best and always has her cool in traffic.', isBooked: true),

    KekeRider(name: 'Kingsley Uche', contact: '07066667777', review: 'Kingsley is new but very professional. Highly recommended!', isBooked: false),

  ];

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

  void _toggleBookedStatus(int index) {

    setState(() {

      _riders[index].isBooked = !_riders[index].isBooked;

    });

  }

  /// Displays a pop-up dialog with the rider's details.

  void _showRiderDetailsDialog(KekeRider rider) {

    showDialog(

      context: context,

      builder: (BuildContext context) {

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

                  backgroundColor: Theme.of(context).primaryColor,

                  child: const Icon(

                    Icons.electric_rickshaw,

                    size: 60,

                    color: Colors.yellow,

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

                backgroundColor: Theme.of(context).primaryColor,

                child: const Icon(

                  Icons.electric_rickshaw,

                  size: 24,

                  color: Colors.yellow,

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

                    color: Colors.white,

                    size: 28.0,

                  ),

                  onPressed: () => _makePhoneCall(rider.contact),

                  tooltip: 'Call ${rider.name}',

                ),

                const SizedBox(width: 8.0),

                ElevatedButton(

                  onPressed: () => _toggleBookedStatus(index),

                  style: ElevatedButton.styleFrom(

                    backgroundColor: rider.isBooked ? Colors.grey[600] : Colors.green,

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

  final String name;

  final String contact;

  final String review; // Added a review field

  bool isBooked;

  KekeRider({

    required this.name,

    required this.contact,

    required this.review,

    this.isBooked = false,

  });

}