import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:futaride/theme_provider.dart';
import 'dart:io';

// Import the Supabase package
import 'package:supabase_flutter/supabase_flutter.dart';

// Initialize Supabase. You'll need to get these values from your Supabase project settings.
// It's recommended to use environment variables for these in a real app.
const supabaseUrl = 'https://yhmprtprcjoeimpaieeq.supabase.co';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlobXBydHByY2pvZWltcGFpZWVxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU3MDE1MDUsImV4cCI6MjA3MTI3NzUwNX0.vqlLE218TSLFKZVKkpKmyxt9Xc9ECJ06gGVzARM_2gE';
final supabase = Supabase.instance.client;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State variables for user profile data
  String _fullName = 'Loading...';
  String _email = 'Loading...';
  String _phoneNumber = 'Loading...';
  File? _image;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialize Supabase and then fetch the user profile.
    _initializeAndFetchProfile();
  }

  /// Initializes Supabase and fetches user profile data.
  Future<void> _initializeAndFetchProfile() async {
    try {
      // Ensure Supabase is initialized before any operations
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );

      _fetchUserProfile();
    } catch (e) {
      print('Error initializing Supabase: $e');
      setState(() {
        _isLoading = false;
        _fullName = 'Initialization Error';
        _email = 'Initialization Error';
        _phoneNumber = 'Initialization Error';
      });
    }
  }

  /// Asynchronously fetches user profile data from Supabase.
  Future<void> _fetchUserProfile() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Get the current authenticated user
      final user = supabase.auth.currentUser;

      if (user != null) {
        // Get email and phone directly from the user object
        _email = user.email ?? 'Not available';
        _phoneNumber = user.phone ?? 'Not available';

        // Fetch the full name from the 'profiles' table
        // This assumes you have a 'profiles' table with a 'full_name' column
        // and a row for the current user.
        final response = await supabase
            .from('profiles')
            .select('full_name') // Select the full_name column
            .eq('id', user.id) // Filter by the user's ID
            .single(); // Expect a single result

        _fullName = response['full_name'] ?? 'Name not set';
      } else {
        // Handle the case where the user is not authenticated
        _fullName = 'No user logged in';
        _email = 'No user logged in';
        _phoneNumber = 'No user logged in';
      }
    } catch (e) {
      // Handle any errors that occur during fetching
      print('Error fetching user data from Supabase: $e');
      _fullName = 'Error fetching data';
      _email = 'Error fetching data';
      _phoneNumber = 'Error fetching data';
    } finally {
      // Set loading to false once fetching is complete (or has failed)
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Handles image selection from the phone's gallery.
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider using Provider.of
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Theme.of(context).primaryColor,
                          backgroundImage: _image != null ? FileImage(_image!) : null,
                          child: _image == null
                              ? Icon(
                                  Icons.person,
                                  size: 70,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                shape: BoxShape.circle,
                                border: Border.all(color: Theme.of(context).colorScheme.onSurface, width: 2),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Detail Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Full Name',
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _fullName,
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Divider(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _email,
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Divider(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Phone Number',
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _phoneNumber,
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Divider(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Change screen theme',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Switch(
                          value: isDarkMode,
                          onChanged: (value) {
                            themeProvider.toggleTheme(value);
                          },
                          activeColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
