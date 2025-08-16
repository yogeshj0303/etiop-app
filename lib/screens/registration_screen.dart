import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'login_screen.dart';
import '../utils/location_data.dart';

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

  // Add these variables with the other state variables
  String? _selectedState;
  String? _selectedDistrict;

  // Add a boolean to track password visibility
  bool _isPasswordVisible = false;

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

  // Add this method to handle state change
  void _onStateChanged(String? state) {
    setState(() {
      _selectedState = state;
      _selectedDistrict = null; // Reset district when state changes
    });
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
          _selectedState ?? '',
          _selectedDistrict ?? '',
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
          await prefs.setString('state', _selectedState ?? '');
          await prefs.setString('district', _selectedDistrict ?? '');
          await prefs.setString('id', userId); // Save user ID

          // getstring user id
          final String? Id = prefs.getString('id');
          print('User ID: $Id');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.registrationSuccessful)),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else {
          throw Exception(AppLocalizations.of(context)!.invalidResponse);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errorRegisteringUser(e.toString()))),
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
        title: Text(
          AppLocalizations.of(context)!.createAccount,
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
                      _nameController, AppLocalizations.of(context)!.firstName, AppLocalizations.of(context)!.firstNameHint),
                  const SizedBox(height: 14),
                  _buildTextField(
                      _lastNameController, AppLocalizations.of(context)!.lastName, AppLocalizations.of(context)!.lastNameHint),
                  const SizedBox(height: 14),
                  _buildTextField(
                      _emailController, AppLocalizations.of(context)!.email, AppLocalizations.of(context)!.invalidEmailFormat,
                      isEmail: true),
                  const SizedBox(height: 14),
                  _buildTextField(_mobileController, AppLocalizations.of(context)!.mobileNumber,
                      AppLocalizations.of(context)!.mobileNumberHint,
                      isMobile: true),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: _selectedState,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.state,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                    ),
                    items: IndianLocation.states.map((String state) {
                      return DropdownMenuItem<String>(
                        value: state,
                        child: Text(state),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.stateRequired;
                      }
                      return null;
                    },
                    onChanged: _onStateChanged,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: _selectedDistrict,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.city,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                    ),
                    items: _selectedState == null
                        ? []
                        : IndianLocation.getDistricts(_selectedState!).map((String district) {
                            return DropdownMenuItem<String>(
                              value: district,
                              child: Text(district),
                            );
                          }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.districtRequired;
                      }
                      return null;
                    },
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDistrict = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                      _addressController, AppLocalizations.of(context)!.address, AppLocalizations.of(context)!.addressHint),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: _gender,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.gender,
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: [
                      DropdownMenuItem(value: "Male", child: Text(AppLocalizations.of(context)!.male)),
                      DropdownMenuItem(value: "Female", child: Text(AppLocalizations.of(context)!.female)),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  _buildTextField(
                    _passwordController,
                    AppLocalizations.of(context)!.password,
                    AppLocalizations.of(context)!.passwordHint,
                    isPassword: true,
                    isPasswordVisible: _isPasswordVisible,
                    togglePasswordVisibility: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
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
                          child: Text(AppLocalizations.of(context)!.register,
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
                      Text(
                        AppLocalizations.of(context)!.alreadyHaveAccount,
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
                        child: Text(
                          AppLocalizations.of(context)!.logIn,
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
      {bool isEmail = false, bool isMobile = false, bool isPassword = false, bool isPasswordVisible = false, VoidCallback? togglePasswordVisibility}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
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
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: togglePasswordVisibility,
              )
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMessage;
        }
        if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return AppLocalizations.of(context)!.invalidEmailFormat;
        }
        if (isMobile && !RegExp(r'^\d{10}$').hasMatch(value)) {
          return AppLocalizations.of(context)!.validMobileRequired;
        }
        return null;
      },
    );
  }
}
