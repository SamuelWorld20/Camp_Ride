import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:futaride/theme_provider.dart';
import 'dart:io';

// Import the Supabase package and hide the Provider class to avoid conflicts
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;

// Define your Supabase constants here for use in this file.
// IMPORTANT: These are for reference only. Supabase is initialized in main.dart.
const supabaseUrl = 'https://yhmprtprcjoeimpaieeq.supabase.co';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlobXBydHByY2pvZWltcGFpZWVxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU3MDE1MDUsImV4cCI6MjA3MTI3NzUwNX0.vqlLE218TSLFKZVKkpKmyxt9Xc9ECJ06gGVzARM_2gE';

// Get the already initialized Supabase client instance.
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
  String? _imageUrl; // This will store the public URL of the image
  File? _imageFile; // This will store the selected image file before upload
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Directly fetch the user profile since Supabase is already initialized in main.dart
    _fetchUserProfile();
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

        // Fetch the full name AND avatar URL from the 'profiles' table
        final response = await supabase
            .from('profiles')
            .select('full_name, avatar_url') // Select both columns
            .eq('id', user.id)
            .single();

        _fullName = response['full_name'] ?? 'Name not set';
        _imageUrl = response['avatar_url']; // Get the image URL from the database
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

  /// Handles image selection and upload.
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final file = File(image.path);
      setState(() {
        _imageFile = file; // Update the temporary file in the UI
      });

      // Show a loading indicator while uploading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Uploading image...')),
      );

      // Upload the image to Supabase Storage and get the URL
      final imageUrl = await _uploadProfileImage(file);
      
      // Update the user's profile with the new image URL
      if (imageUrl != null) {
        await supabase
            .from('profiles')
            .update({'avatar_url': imageUrl})
            .eq('id', supabase.auth.currentUser!.id);

        setState(() {
          _imageUrl = imageUrl;
          _imageFile = null; // Clear the temporary file reference
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image upload failed.')),
        );
      }
    }
  }

  /// Uploads the given file to Supabase Storage.
  Future<String?> _uploadProfileImage(File file) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated.');
      }
      
      // The path where the image will be stored in the 'avatars' bucket
      final filePath = '${user.id}/${DateTime.now().toIso8601String()}.png';

      // Upload the file to the 'avatars' bucket
      await supabase.storage.from('avatars').upload(
        filePath,
        file,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
      );

      // Get the public URL of the uploaded image
      final publicUrl = supabase.storage.from('avatars').getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
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
                          // Use NetworkImage to display the URL from Supabase
                          backgroundImage: _imageUrl != null
                              ? NetworkImage(_imageUrl!)
                              : _imageFile != null
                                  ? FileImage(_imageFile!)
                                  : null,
                          child: _imageUrl == null && _imageFile == null
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
