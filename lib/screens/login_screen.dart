import 'package:etiop_application/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../generated/app_localizations.dart';

import '../services/api_services.dart';
import 'forgot_pass.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          l10n.login,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 10,
        backgroundColor:
            Color(4292815168), // Set app bar color to match the logo
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo (Centered, and size adjusted)
                  const SizedBox(height: 40),
                  Image.asset(
                    'assets/images/app_logo.jpg', // Your red app logo file here
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.welcome,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email Text Field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      hintText: 'Enter your email or mobile no.',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 12.0),
                      prefixIcon: Icon(
                        Icons.email,
                        //add surfacetint color from theme
                        color: Color(4292815168),
                      ), // Use red icon
                    ),
                    keyboardType: TextInputType.emailAddress,
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter your email';
                    //   } else if (!RegExp(
                    //           r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                    //       .hasMatch(value)) {
                    //     return 'Please enter a valid email address';
                    //   } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    //     return 'Please enter a valid mobile number';
                    //   }
                    //   return null;
                    // },
                  ),
                  const SizedBox(height: 16),

                  // Password Text Field
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 12.0),
                      prefixIcon: Icon(Icons.lock, color: Color(4292815168)),
                      // Use red icon
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(4292815168),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible =
                                !_isPasswordVisible; // Toggle visibility
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisible, // Toggle visibility
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.requiredField;
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  // Forgot Password Link - Moved below the password field
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          l10n.forgotPassword,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(4292815168), // Red color for the link
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Login Button
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Color(4292815168),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ), // Red button to match logo
                          ),
                          child: Text(
                            l10n.login,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // White text on red button
                            ),
                          ),
                        ),
                  const SizedBox(height: 10),
                  // Register Button with spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account?',
                        style: TextStyle(fontSize: 14),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegistrationPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Register here',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(
                                4292815168), // Red link color to match the theme
                          ),
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
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final String emailOrMobile = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      try {
        final response = await ApiService.loginUser(emailOrMobile, password);
        print('API Response: $response');
        if (response['success'] == true) {
          final user = response['user'];
          
          // Save all user data
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('id', user['id']?.toString() ?? '');
          await prefs.setString('is_admin', user['is_admin']?.toString() ?? '');
          await prefs.setString('name', user['name'] ?? '');
          await prefs.setString('last_name', user['last_name'] ?? '');
          await prefs.setString('email', user['email'] ?? '');
          await prefs.setString('mobile_number', user['mobile_number'] ?? '');
          await prefs.setString('gender', user['gender'] ?? '');
          await prefs.setString('date_of_joining', user['date_of_joining'] ?? '');
          await prefs.setString('dob', user['dob'] ?? '');
          await prefs.setString('addhar', user['addhar'] ?? '');
          await prefs.setString('state', user['state'] ?? '');
          await prefs.setString('district', user['district'] ?? '');
          await prefs.setString('email', user['email'] ?? '');
          await prefs.setString('avatar', user['avatar'] ?? '');
          await prefs.setString('address', user['address'] ?? '');
          await prefs.setString('created_at', user['created_at'] ?? '');
          await prefs.setString('updated_at', user['updated_at'] ?? '');

          // Navigate to HomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else if (response['success'] == false) {
          _showErrorDialog(response['message'] ?? 'Login failed');
        }
      }  finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
