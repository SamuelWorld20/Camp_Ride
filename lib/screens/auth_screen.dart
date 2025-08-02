import 'package:flutter/material.dart';

// You might need to add these imports if you plan to use Firebase later
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';

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

  // Text editing controllers for input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // State variables for UI interactions
  bool _rememberMe = false;
  bool _obscurePassword = true;

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
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // This method will be called when the main button (Login/Register) is pressed
  void _handleAuthAction() {
    if (_formType == AuthFormType.login) {
      _showSnackBar('Login button pressed!');
      // TODO: Implement Firebase login logic here
    } else {
      if (_passwordController.text != _confirmPasswordController.text) {
        _showSnackBar('Passwords do not match!');
        return;
      }
      _showSnackBar('Register button pressed!');
      // TODO: Implement Firebase sign-up logic here
    }
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
                          color: onBackgroundColor, // White text
                        ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    _formType == AuthFormType.login
                        ? 'Sign in to access Keke rider contacts' // Login sub-heading
                        : 'Sign up to enjoy the best managing experience', // Register sub-heading
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: onBackgroundColor.withOpacity(0.7), // Faded white text
                        ),
                  ),
                ],
              ),
            ),
          ),
          // Main content card containing the form
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
                      // Confirm Password Input Field (only for Register)
                      if (_formType == AuthFormType.register) ...[
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
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
                      ],
                      const SizedBox(height: 16.0),
                      // Remember Me Checkbox and Forgot Password Link (only for Login)
                      if (_formType == AuthFormType.login)
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
                      // Main Action Button (Login or Register)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleAuthAction, // Calls the unified handler
                          child: Text(_formType == AuthFormType.login ? 'Login' : 'Register'),
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
                      // Social Login/Register Buttons (Google and Facebook)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                _showSnackBar('Google ${_formType == AuthFormType.login ? 'Login' : 'Register'} pressed!');
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
                                _showSnackBar('Facebook ${_formType == AuthFormType.login ? 'Login' : 'Register'} pressed!');
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
