import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Add this import for Supabase

// Enum to manage the current form type (Login or Register)
enum AuthFormType { login, register }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Default to Login form initially
  AuthFormType _formType = AuthFormType.login;
  bool _isLoading = false;

  // Text editing controllers for input fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State variables for UI interactions
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Listen for authentication state changes and navigate accordingly
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        // If the user has signed in, navigate to the home screen.
        // The pushReplacementNamed is used to prevent the user from going back to the login screen.
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  // Function to show a simple SnackBar message for user feedback
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Theme.of(context).colorScheme.primary,
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources when the widget is removed
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- SUPABASE AUTHENTICATION FUNCTIONS ---

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Sign up the user with Supabase Auth
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
      
      _showSnackBar('Sign up successful! Please check your email to confirm your account.');

    } on AuthException catch (e) {
      // Handle specific Supabase authentication errors
      _showSnackBar(e.message, isError: true);
    } catch (e) {
      // Handle other potential errors
      _showSnackBar('An unexpected error occurred.', isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Sign in the user with Supabase Auth
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      // The auth state listener in initState will handle navigation.
      
    } on AuthException catch (e) {
      // Handle specific Supabase authentication errors
      _showSnackBar(e.message, isError: true);
    } catch (e) {
      // Handle other potential errors
      _showSnackBar('An unexpected error occurred.', isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // This method will be called when the main button (Login/Register) is pressed
  void _handleAuthAction() {
    if (_formType == AuthFormType.login) {
      _signIn();
    } else {
      _signUp();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access theme colors for dynamic styling.
    final Color onBackgroundColor = Theme.of(context).colorScheme.onBackground;
    final Color onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color inputFillColor = Theme.of(context).inputDecorationTheme.fillColor ?? Colors.grey[200]!;

    return Scaffold(
      // Use the dynamic background color from your theme
      backgroundColor: Theme.of(context).colorScheme.background,
      // Extend body behind app bar to allow the background content to reach higher
      extendBodyBehindAppBar: true,
      // AppBar with transparent background and dynamic elements
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent AppBar
        elevation: 0, // No shadow
      ),
      // Use a Stack to layer the background text and the main content card
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Top section with dynamic heading and sub-heading
              Positioned(
                top: MediaQuery.of(context).padding.top + kToolbarHeight + 20, // Position below AppBar
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formType == AuthFormType.login
                            ? 'Welcome Back!' // Login heading
                            : 'Go ahead and set up your account', // Register heading
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: onBackgroundColor, // Dynamic text color
                            ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        _formType == AuthFormType.login
                            ? 'Sign in to access Keke rider contacts' // Login sub-heading
                            : 'Sign up to enjoy the best managing experience', // Register sub-heading
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: onBackgroundColor.withOpacity(0.7), // Faded dynamic text
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              // Main content card containing the form
              Positioned.fill(
                top: constraints.maxHeight * 0.3, // Dynamic top position based on screen height
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Card(
                    color: Theme.of(context).colorScheme.surface, // Dynamic card background
                    elevation: 8.0, // Card shadow
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0), // Rounded card corners
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Column takes minimum vertical space
                        children: [
                          // Login / Register Toggle Button
                          Container(
                            decoration: BoxDecoration(
                              color: inputFillColor, // Use input field's fill color for background
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _formType = AuthFormType.login; // Switch to Login
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                                      decoration: BoxDecoration(
                                        color: _formType == AuthFormType.login ? primaryColor : Colors.transparent, // Yellow if selected, transparent otherwise
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                          color: _formType == AuthFormType.login ? Colors.black : onSurfaceColor, // Black text on yellow, black on transparent
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _formType = AuthFormType.register; // Switch to Register
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                                      decoration: BoxDecoration(
                                        color: _formType == AuthFormType.register ? primaryColor : Colors.transparent, // Yellow if selected, transparent otherwise
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Register',
                                        style: TextStyle(
                                          color: _formType == AuthFormType.register ? Colors.black : onSurfaceColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          // Fields for the Register form
                          if (_formType == AuthFormType.register) ...[
                            // Full Name Input Field
                            TextField(
                              controller: _fullNameController,
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              keyboardType: TextInputType.name,
                              style: TextStyle(color: onSurfaceColor),
                            ),
                            const SizedBox(height: 16.0),
                            // Phone Number Input Field
                            TextField(
                              controller: _phoneNumberController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                prefixIcon: Icon(Icons.phone_outlined),
                              ),
                              keyboardType: TextInputType.phone,
                              style: TextStyle(color: onSurfaceColor),
                            ),
                            const SizedBox(height: 16.0),
                          ],
                          // Common fields for both Login and Register
                          TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: onSurfaceColor), // Text color inside input field
                          ),
                          const SizedBox(height: 16.0),
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword; // Toggle password visibility
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscurePassword, // Hide/show password
                            style: TextStyle(color: onSurfaceColor),
                          ),
                          const SizedBox(height: 16.0),
                          // Remember Me Checkbox and Forgot Password Link (only for Login)
                          if (_formType == AuthFormType.login)
                            FittedBox( // The widget that fixes the overflow
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _rememberMe,
                                        onChanged: (bool? newValue) {
                                          setState(() {
                                            _rememberMe = newValue!;
                                          });
                                        },
                                      ),
                                      Text('Remember me', style: TextStyle(color: onSurfaceColor.withOpacity(0.8))),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _showSnackBar('Forgot Password functionality not implemented.');
                                    },
                                    child: const Text('Forgot Password?'),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 24.0),
                          // Main Action Button (Login or Register)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleAuthAction, // Disable button while loading
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : Text(_formType == AuthFormType.login ? 'Login' : 'Register'),
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          // "Or login/register with" separator
                          Row(
                            children: [
                              Expanded(child: Divider(color: onSurfaceColor.withOpacity(0.5))),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  _formType == AuthFormType.login ? 'Or login with' : 'Or register with',
                                  style: TextStyle(color: onSurfaceColor.withOpacity(0.7)),
                                ),
                              ),
                              Expanded(child: Divider(color: onSurfaceColor.withOpacity(0.5))),
                            ],
                          ),
                          const SizedBox(height: 24.0),
                          // Social Login/Register Buttons (Google only)
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                _showSnackBar('Google ${_formType == AuthFormType.login ? 'Login' : 'Register'} pressed!');
                              },
                              icon: Icon(
                                Icons.g_mobiledata,
                                size: 28, // Using a larger size for better visibility
                                color: primaryColor, // Use the yellow primary color
                              ),
                              label: const Text('Google'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
