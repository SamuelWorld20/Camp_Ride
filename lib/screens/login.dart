import 'package:flutter/material.dart';
// Import the SignUpScreenDesign so you can navigate to it
import 'package:futaride/screens/sign_up.dart'; // Adjust 'your_app_name'

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Text editing controllers for input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State variables for UI interactions
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoginSelected = true; // Controls the Login/Register toggle state

  // Function to show a simple SnackBar message for user feedback
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources when the widget is removed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access theme colors for dynamic styling.
    final Color onBackgroundColor = Theme.of(context).colorScheme.onBackground; // White text for background
    final Color onSurfaceColor = Theme.of(context).colorScheme.onSurface; // Black text for card surface
    final Color primaryColor = Theme.of(context).colorScheme.primary; // Yellow color
    final Color inputFillColor = Theme.of(context).inputDecorationTheme.fillColor!; // Light grey fill for input fields

    return Scaffold(
      // Extend body behind app bar to allow the background content to reach higher
      extendBodyBehindAppBar: true,
      // AppBar with transparent background and white elements
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back arrow icon
          onPressed: () {
            _showSnackBar('Back button pressed!');
            // In a real app, this would typically be Navigator.pop(context);
          },
        ),
      ),
      // Use a Stack to layer the background text and the main content card
      body: Stack(
        children: [
          // Top section with "Welcome Back!" text and description
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
                    'Welcome Back!', // Main heading for login
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: onBackgroundColor, // White text
                        ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Sign in to access Keke rider contacts', // Sub-heading for login
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: onBackgroundColor.withOpacity(0.7), // Faded white text
                        ),
                  ),
                ],
              ),
            ),
          ),
          // Main content card containing the login form
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.3, // Position the card lower on the screen
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Card(
                color: Theme.of(context).colorScheme.surface, // Card background (white)
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
                                    _isLoginSelected = true; // Select Login
                                  });
                                  // This is already the Login screen, so no navigation needed
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  decoration: BoxDecoration(
                                    color: _isLoginSelected ? primaryColor : Colors.transparent, // Yellow if selected, transparent otherwise
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      color: _isLoginSelected ? Colors.black : onSurfaceColor, // Black text on yellow, black on transparent
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
                                    _isLoginSelected = false; // Select Register
                                  });
                                  // Navigate to the SignUpScreenDesign when Register is tapped
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  decoration: BoxDecoration(
                                    color: !_isLoginSelected ? primaryColor : Colors.transparent, // Yellow if selected, transparent otherwise
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Register',
                                    style: TextStyle(
                                      color: !_isLoginSelected ? Colors.black : onSurfaceColor,
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
                      // Email Input Field
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
                      // Password Input Field
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
                      // Remember Me Checkbox and Forgot Password Link
                      Row(
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
                      const SizedBox(height: 24.0),
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _showSnackBar('Login button pressed!');
                            // Add your login authentication logic here
                          },
                          child: const Text('Login'),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      // "Or login with" separator
                      Row(
                        children: [
                          Expanded(child: Divider(color: onSurfaceColor.withOpacity(0.5))),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('Or login with', style: TextStyle(color: onSurfaceColor.withOpacity(0.7))),
                          ),
                          Expanded(child: Divider(color: onSurfaceColor.withOpacity(0.5))),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      // Social Login Buttons (Google and Facebook)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                _showSnackBar('Google Login pressed!');
                              },
                              icon: Image.asset(
                                'assets/google_logo.png', // Placeholder: Add your Google logo to assets/
                                height: 24.0,
                                width: 24.0,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, size: 24, color: Colors.blue), // Fallback icon
                              ),
                              label: const Text('Google'),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                _showSnackBar('Facebook Login pressed!');
                              },
                              icon: Image.asset(
                                'assets/facebook_logo.png', // Placeholder: Add your Facebook logo to assets/
                                height: 24.0,
                                width: 24.0,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.facebook, size: 24, color: Colors.blue), // Fallback icon
                              ),
                              label: const Text('Facebook'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black, // The overall background color of the screen
    );
  }
}
