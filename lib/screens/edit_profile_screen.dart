import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/location_data.dart'; // Ensure this import is present for location data

class EditProfileScreen extends StatefulWidget {
  final String currentAvatar;
  final Map<String, String> userData;

  const EditProfileScreen({
    Key? key,
    required this.currentAvatar,
    required this.userData,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  String? _selectedGender;
  DateTime? _selectedDate;
  File? _imageFile;
  bool _isLoading = false;
  String? _selectedState;
  String? _selectedDistrict;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _firstNameController.text = widget.userData['name'] ?? '';
    _lastNameController.text = widget.userData['last_name'] ?? '';
    _emailController.text = widget.userData['email'] ?? '';
    _mobileController.text = widget.userData['mobile_number'] ?? '';
    _addressController.text = widget.userData['address'] ?? '';
    _selectedGender = widget.userData['gender'];
    _selectedState = widget.userData['state'];
    _selectedDistrict = widget.userData['district'];
    
    if (widget.userData['dob'] != null && widget.userData['dob']!.isNotEmpty && widget.userData['dob'] != "Not specified") {
      try {
        String dobString = widget.userData['dob']!;
        if (dobString.contains('T')) {
          _selectedDate = DateTime.parse(dobString.split('T')[0]);
        } else {
          _selectedDate = DateTime.parse(dobString.split(' ')[0]);
        }
      } catch (e) {
        print('Error parsing date: $e');
        _selectedDate = null;
      }
    }
  }

  void _onStateChanged(String? state) {
    setState(() {
      _selectedState = state;
      _selectedDistrict = null; // Reset district when state changes
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick image')),
      );
    }
  }

  Future<void> _updateProfile() async {
    try {
      setState(() => _isLoading = true);
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('id');

      if (userId == null) {
        throw Exception('User ID not found');
      }

      // Create multipart request with the correct API endpoint
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://etiop.in/api/user/update/$userId'),
      );

      // Add text fields
      request.fields.addAll({
        'name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'email': _emailController.text,
        'mobile_number': _mobileController.text,
        'gender': _selectedGender ?? '',
        'dob': _selectedDate != null ? "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}" : '',
        'address': _addressController.text,
        'state': _selectedState ?? '',
        'district': _selectedDistrict ?? '',
      });

      // Add image if selected
      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'avatar',
          _imageFile!.path,
        ));
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      print('Response: $responseData'); // Debug print
      var decodedResponse = jsonDecode(responseData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Update SharedPreferences
        await prefs.setString('name', _firstNameController.text);
        await prefs.setString('last_name', _lastNameController.text);
        await prefs.setString('email', _emailController.text);
        await prefs.setString('mobile_number', _mobileController.text);
        await prefs.setString('gender', _selectedGender ?? '');
        await prefs.setString('dob', _selectedDate?.toIso8601String() ?? '');
        await prefs.setString('address', _addressController.text);
        await prefs.setString('state', _selectedState ?? '');
        await prefs.setString('district', _selectedDistrict ?? '');
        
        // Check if avatar was updated in the response
        if (decodedResponse['user'] != null && decodedResponse['user']['avatar'] != null) {
          await prefs.setString('avatar', decodedResponse['user']['avatar']);
        }

        Navigator.pop(context, true); // Return true to indicate successful update
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        throw Exception(decodedResponse['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0, // Modern design often uses less elevation
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Image Section with gradient background
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).primaryColor.withOpacity(0.2),
                            width: 4,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.white,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!) as ImageProvider
                              : (widget.currentAvatar.isNotEmpty
                                  ? NetworkImage('https://etiop.in/${widget.currentAvatar}')
                                  : const AssetImage('assets/images/default_avatar.png')) as ImageProvider,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                            onPressed: _pickImage,
                            constraints: const BoxConstraints(
                              minHeight: 40,
                              minWidth: 40,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            // Form Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Name Row
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Contact Information
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _mobileController,
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.phone_outlined),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  // Gender Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    items: ['Male', 'Female', 'Other']
                        .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _selectedGender = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  // Date of Birth
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              dialogBackgroundColor: Colors.white,
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                      ),
                      child: Text(
                        _formatDate(_selectedDate),
                        style: TextStyle(
                          color: _selectedDate == null ? Colors.grey.shade600 : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  // State Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedState,
                    decoration: InputDecoration(
                      labelText: 'State',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.map_outlined),
                    ),
                    items: IndianLocation.states.map((String state) {
                      return DropdownMenuItem<String>(
                        value: state,
                        child: Text(state),
                      );
                    }).toList(),
                    onChanged: _onStateChanged,
                  ),
                  const SizedBox(height: 16),
                  // District Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedDistrict,
                    decoration: InputDecoration(
                      labelText: 'District',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.location_city_outlined),
                    ),
                    items: _selectedState == null
                        ? []
                        : IndianLocation.getDistricts(_selectedState!).map((String district) {
                            return DropdownMenuItem<String>(
                              value: district,
                              child: Text(district),
                            );
                          }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDistrict = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Address
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.location_on_outlined),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),
                  // Update Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updateProfile,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Update Profile',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    super.dispose();
  }
} 