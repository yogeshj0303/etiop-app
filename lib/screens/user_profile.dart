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

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String firstName = "First Name";
  String lastName = "Last Name";
  String email = "example@example.com";
  String mobileNumber = "000-000-0000";
  String gender = "Not specified";
  String dob = "Not specified";
  String address = "No address provided";
  String avatar = "assets/user_profile.jpg"; // Default avatar path
  List<Shop> shops = []; // List to hold shop data

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('name') ?? "User";
      lastName = prefs.getString('last_name') ?? "Name";
      email = prefs.getString('email') ?? "example@example.com";
      mobileNumber = prefs.getString('mobile_number') ?? "Not available";
      gender = prefs.getString('gender') ?? "Not specified";
      dob = prefs.getString('dob') ?? "Not specified";
      address = prefs.getString('address') ?? "No address provided";
      avatar = prefs.getString('avatar') ?? "assets/images/app_logo.jpg";
    });
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
        Uri.parse('https://etiop.acttconnect.com/api/requirements-get-byowner/$userId'),
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
            // Profile Picture and Name Section
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 55, // Increased size for profile picture
                      backgroundImage: AssetImage(avatar),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 20,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 18,
                          ),
                          onPressed: () {
                            // Add functionality for updating profile picture
                          },
                        ),
                      ),
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
              value,
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
