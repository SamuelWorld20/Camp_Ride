import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // A list of places with their details
  final List<Map<String, dynamic>> places = [
    {'name': 'Abiola / Jibowu', 'price': '₦300', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=Abiola'},
    {'name': 'Aluta Market', 'price': '₦300', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=Aluta'},
    {'name': 'SEET', 'price': '₦300', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=SEET'},
    {'name': 'Multipurpose Hall / TI Francis', 'price': '₦300', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=Hall'},
    {'name': 'Cbt Center', 'price': '₦400', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=Cbt'},
    {'name': 'Adeniyi / Jadesola', 'price': '₦400', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=Adeniyi'},
    {'name': 'Futascoop', 'price': '₦400', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=Futascoop'},
    {'name': 'SAAT / SLS', 'price': '₦400', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=SAAT'},
    {'name': 'SEET Workshop', 'price': '₦400', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=Workshop'},
    {'name': 'SOC / 3in1 (SOC)', 'price': '₦400', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=SOC'},
    {'name': 'Adamu Adamu (CESRA)', 'price': '₦400', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=Adamu'},
    {'name': 'PG School / 2in1', 'price': '₦400', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=PG+School'},
    {'name': 'Old Set / New Set', 'price': '₦400', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=Old+Set'},
    {'name': 'Health Center / Bisi Balogun', 'price': '₦500', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=Health+Center'},
    {'name': 'Academic Building', 'price': '₦500', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=Academic'},
    {'name': 'New 2in1 (SAAT & SEET)', 'price': '₦500', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=New+2in1'},
    {'name': 'PG Hostel / 3in1', 'price': '₦500', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=PG+Hostel'},
    {'name': 'Awosika / Adeboye Hostel', 'price': '₦500', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=Awosika'},
    {'name': '1k Cap / 5PS', 'price': '₦500', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=1k+Cap'},
    {'name': 'New SEET / New SBMS', 'price': '₦500', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=New+SEET'},
    {'name': 'West Gate', 'price': '₦500', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=West+Gate'},
    {'name': 'VC Lodge / Scholars Lodge', 'price': '₦500', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=VC+Lodge'},
    {'name': 'Staff Club', 'price': '₦500', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=Staff+Club'},
    {'name': 'BisiBalogun Annex / Building Workshop', 'price': '₦600', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=BisiBalogun'},
    {'name': 'Southgate', 'price': '₦700', 'image': 'https://placehold.co/600x400/000000/FFFFFF?text=Southgate'},
  ];

  void _showPlaceDetails(BuildContext context, Map<String, dynamic> place) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                  child: Image.network(
                    place['image'],
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: Icon(Icons.location_on, size: 50),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place['name'],
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Price: ${place['price']}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 16.0),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Close',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: places.length,
        itemBuilder: (context, index) {
          final place = places[index];
          return Card(
            color: Theme.of(context).colorScheme.surface,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              title: Text(
                place['name'],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => _showPlaceDetails(context, place),
            ),
          );
        },
      ),
    );
  }
}
