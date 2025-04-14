import 'dart:convert'; // For parsing JSON

import 'package:etiop_application/modals/shop_model.dart';
import 'package:etiop_application/screens/support_screen.dart';
import 'package:etiop_application/widgets/user_shops.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/shop_form.dart';
import 'login_screen.dart';
import 'main_screen.dart';
import 'edit_profile_screen.dart';
import 'order_history_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String firstName = '';
  String lastName = '';
  String email = '';
  String mobileNumber = '';
  String gender = '';
  String dob = '';
  String address = '';
  String avatar = '';
  String state = '';
  String district = '';
  List<Shop> shops = []; // List to hold shop data

  // Add these controllers at the top of your _UserProfileScreenState class
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  String? _selectedGender;
  DateTime? _selectedDate;

  // Add this at the class level
  final String baseUrl = 'https://etiop.acttconnect.com';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? avatarPath = prefs.getString('avatar');
      print('Raw avatar path from SharedPreferences: $avatarPath');

      setState(() {
        firstName = prefs.getString('name') ?? "User";
        lastName = prefs.getString('last_name') ?? "Name";
        email = prefs.getString('email') ?? "example@example.com";
        mobileNumber = prefs.getString('mobile_number') ?? "Not available";
        gender = prefs.getString('gender') ?? "Not specified";
        dob = prefs.getString('dob') ?? "Not specified";
        address = prefs.getString('address') ?? "No address provided";
        state = prefs.getString('state') ?? "Not specified";
        district = prefs.getString('district') ?? "Not specified";
        avatar = avatarPath ?? "";
        print('Final avatar URL: $baseUrl/$avatar');

        // Set controller values
        _firstNameController.text = firstName;
        _lastNameController.text = lastName;
        _emailController.text = email;
        _mobileController.text = mobileNumber;
        _addressController.text = address;
        _selectedGender = gender;
        _stateController.text = state;
        _districtController.text = district;
        if (dob != "Not specified") {
          try {
            _selectedDate = DateTime.parse(dob);
          } catch (e) {
            print('Error parsing date: $e');
          }
        }
      });
      print(
          'Loaded user data: firstName=$firstName, lastName=$lastName, email=$email, mobile=$mobileNumber'); // Debug print
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _handleMyBusinessesClick() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');
    print('User ID: $userId');

    if (userId != null) {
      await _fetchShops(userId); // Extract fetch logic to separate method

      if (shops.isNotEmpty) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserShopScreen(shops: shops),
          ),
        );

        // Reload shops data when returning from UserShopScreen
        if (result == true) {
          await _fetchShops(userId);
        }
      } else {
        _showCreateShopPrompt();
      }
    } else {
      print('User ID not found in SharedPreferences');
    }
  }

  Future<void> _fetchShops(String userId) async {
    try {
      var response = await http.get(
        Uri.parse(
            'https://etiop.acttconnect.com/api/requirements-get-byowner/$userId'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);

        if (data['success']) {
          setState(() {
            final List shopsList = data['data']['shops'];
            shops = shopsList.map((shopData) {
              return Shop.fromJson({
                ...shopData['shop'],
                'requirements': shopData['requirements'],
                'category_name': shopData['shop']['category_name'],
              });
            }).toList();
          });
        } else {
          print('No shops found.');
        }
      } else if (response.statusCode == 404) {
        setState(() => shops = []);
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  void _showCreateShopPrompt() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10.0), // Rounded corners for the dialog
          ),
          title: Text(
            'No Shops Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'You have not created any shops yet. Would you like to create one?',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                // Light grey background for the button
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // Rounded corners for button
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddShop()),
                ); // Navigate to AddShop screen
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // Rounded corners for button
                ),
              ),
              child: const Text(
                'Create Shop',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Add this helper method to format the date
  String _formatDate(String dateString) {
    if (dateString == "Not specified" || dateString.isEmpty) {
      return "Not specified";
    }
    try {
      DateTime date;
      if (dateString.contains('T')) {
        date = DateTime.parse(dateString.split('T')[0]);
      } else {
        date = DateTime.parse(dateString);
      }
      return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
    } catch (e) {
      print('Error parsing date: $e');
      return "Not specified";
    }
  }

  @override
  Widget build(BuildContext context) {
    String fullName = "$firstName $lastName";

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 18,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(),
              ),
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          "PROFILE",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 4,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 18.0,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SupportScreen(),
                  ),
                );
              },
              child: Image.asset(
                'assets/images/customer-service.png',
                width: 25,
                height: 25,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          clipBehavior: Clip.none,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundImage: avatar.isNotEmpty
                          ? NetworkImage(
                              'https://etiop.acttconnect.com/$avatar')
                          : const AssetImage(
                                  'assets/images/profile_placeholder.png')
                              as ImageProvider,
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(
                                currentAvatar: avatar,
                                userData: {
                                  'name': firstName,
                                  'last_name': lastName,
                                  'email': email,
                                  'mobile_number': mobileNumber,
                                  'gender': gender,
                                  'dob': dob,
                                  'address': address,
                                  'state': state ?? '',
                                  'district': district ?? '',
                                  'category_name': shops.isNotEmpty
                                      ? shops[0].categoryName ?? ''
                                      : '',
                                },
                              ),
                            ),
                          );

                          if (result == true) {
                            await _loadUserData(); // Reload user data if profile was updated
                          }
                        },
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Edit Profile'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          textStyle: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Card-style Section for My Businesses
            Card(
              clipBehavior: Clip.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Businesses',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _handleMyBusinessesClick,
                      // Trigger API on click
                      icon: const Icon(
                        Icons.view_list,
                        size: 20,
                      ),
                      label: const Text(
                        'View All',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrderHistoryScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(4292815168).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.history,
                          color: Color(4292815168),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Order History',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[400],
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Profile Info Sections
            _buildProfileInfoSection("Mobile Number", mobileNumber),
            _buildProfileInfoSection("Gender", gender),
            _buildProfileInfoSection("Date of Birth", dob),
            Card(
              clipBehavior: Clip.none,
              margin: const EdgeInsets.only(bottom: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      address,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Order History Section

            // Sign Out Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Color(4292815168)),
                onPressed: () {
                  _logout(context);
                },
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoSection(String title, String value) {
    // Format the date if this is the date of birth section
    String displayValue = title == "Date of Birth" ? _formatDate(value) : value;

    return Card(
      clipBehavior: Clip.none,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              displayValue,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all shared preferences

    // Navigate back to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
