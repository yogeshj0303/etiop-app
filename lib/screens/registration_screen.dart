import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_services.dart';
import 'login_screen.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  // Variables to store user data
  String _gender = 'Male';
  bool _isLoading = false;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variables to store selected image
  File? _avatarImage;

  // Function to pick an image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _avatarImage = File(pickedFile.path);
      });
    }
  }

  // Function to show full image preview
  void _showFullImagePreview() {
    if (_avatarImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No image selected to preview.")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.file(_avatarImage!, fit: BoxFit.contain),
        ),
      ),
    );
  }

  // Registration function
  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await ApiService.registerUser(
          _nameController.text.trim(),
          _lastNameController.text.trim(),
          _emailController.text.trim(),
          _mobileController.text.trim(),
          _gender,
          _addressController.text.trim(),
          _passwordController.text.trim(),
        );

        if (response.containsKey('user') &&
            response['user'].containsKey('id')) {
          String userId = response['user']['id'].toString();
          // Save user data to SharedPreferences
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('name', _nameController.text.trim());
          await prefs.setString('last_name', _lastNameController.text.trim());
          await prefs.setString('email', _emailController.text.trim());
          await prefs.setString('mobile_number', _mobileController.text.trim());
          await prefs.setString('gender', _gender);
          await prefs.setString('address', _addressController.text.trim());
          await prefs.setString('id', userId); // Save user ID

          // getstring user id
          final String? Id = prefs.getString('id');
          print('User ID: $Id');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration successful!")),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else {
          throw Exception("Invalid response from the server");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error registering user: $e")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(4292815168),
        title: const Text(
          'Create Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 10,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: PageScrollPhysics(),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _avatarImage != null
                          ? FileImage(_avatarImage!)
                          : null,
                      child: _avatarImage == null
                          ? const Icon(
                              Icons.camera_alt,
                              size: 20,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                      _nameController, "First Name", "Enter your first name"),
                  const SizedBox(height: 14),
                  _buildTextField(
                      _lastNameController, "Last Name", "Enter your last name"),
                  const SizedBox(height: 14),
                  _buildTextField(
                      _emailController, "Email", "Enter a valid email",
                      isEmail: true),
                  const SizedBox(height: 14),
                  _buildTextField(_mobileController, "Mobile Number",
                      "Enter your mobile number",
                      isMobile: true),
                  const SizedBox(height: 14),
                  _buildTextField(
                      _addressController, "Address", "Enter your address"),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: _gender,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: const [
                      DropdownMenuItem(value: "Male", child: Text("Male")),
                      DropdownMenuItem(value: "Female", child: Text("Female")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                      _passwordController, "Password", "Enter your password",
                      isPassword: true),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _registerUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(4292815168),
                            // padding: const EdgeInsets.symmetric(vertical: 15),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Register',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 0,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(fontSize: 14),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            color: Color(4292815168),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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

  // Reusable text field widget
  Widget _buildTextField(
      TextEditingController controller, String label, String validatorMessage,
      {bool isEmail = false, bool isMobile = false, bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isMobile
          ? TextInputType.phone
          : (isEmail ? TextInputType.emailAddress : TextInputType.text),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMessage;
        }
        if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return "Invalid email format";
        }
        if (isMobile && !RegExp(r'^\d{10}$').hasMatch(value)) {
          return "Enter a valid 10-digit mobile number";
        }
        return null;
      },
    );
  }
}
