import 'package:etiop_application/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/api_services.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;

  // Your toll-free number
  final String tollFreeNumber =
      "+91 9696353638"; // Change this to your actual toll-free number

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Support',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(4292815168), // Red color consistent with theme
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Need Help? We\'re here to assist you!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Phone Number Field
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    hintText: 'Enter your email address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    } else if (!RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Message Field
                TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    // Ensures the label stays at the top
                    labelText: 'Message...',
                    labelStyle: const TextStyle(color: Colors.black),
                    hintText: 'Enter your enquiry or issue',
                    border: const OutlineInputBorder(),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 90),
                      // Aligns the prefix icon to the top
                      child: const Icon(Icons.message),
                    ),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your message';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Submit Button
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _submitEnquiry,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Color(4292815168), // Red background
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Submit Enquiry',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // White text
                          ),
                        ),
                      ),
                const SizedBox(height: 20),

                // Toll-Free Number
                Center(
                  child: GestureDetector(
                    onTap: () => launch('tel:$tollFreeNumber'),
                    child: Text(
                      'Call Us: $tollFreeNumber',
                      style: TextStyle(
                        color: Color(4292815168),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitEnquiry() async {
    // Check if form is valid
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      final String phone = _phoneController.text.trim();
      final String email = _emailController.text.trim();
      final String message = _messageController.text.trim();

      try {
        // Retrieve the username and user ID from SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();

        final String? username = prefs.getString('name');
        final String? userId = prefs.getString('id');

        if (username == null || userId == null) {
          setState(() {
            _isLoading = false;
          });
          _showErrorDialog('User information is not available.');
          return; // Exit if no user data is found
        }

        // Call the API with the retrieved data
        final response = await ApiService.submitEnquiry(
          name: username,
          phoneNo: phone,
          email: email,
          message: message,
          userId: userId,
        );

        setState(() {
          _isLoading = false;
        });

        // Check if response contains 'id', indicating success
        if (response['id'] != null) {
          _showSuccessDialog('Your enquiry has been submitted successfully!');
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MainScreen()));
          });
        } else {
          _showErrorDialog('Failed to submit the enquiry.');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('An error occurred: $e');
      }
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
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
