import 'package:etiop_application/screens/notification_screen.dart';
import 'package:etiop_application/screens/user_profile.dart';
import 'package:etiop_application/widgets/shop_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:etiop_application/services/payment_service.dart';

import '../widgets/shops_grid.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // List of widgets for each tab page (excluding the placeholder)
  final List<Widget> _pages = [
    const HomeScreen(),
    ShopsGridView(),
    const SizedBox.shrink(),
    const NotificationScreen(),
    const UserProfileScreen(),
  ];
  

  // Method to handle bottom navigation item selection
  void _onItemTapped(int index) {
    // If the middle tab (index 2) is tapped, do not update the index
    if (index == 2) {
      HomeScreen();
    }
    setState(() {
      _currentIndex = index;
      // If profile tab is selected, refresh the data
      if (index == 4) {
        // Profile tab index
        if (_pages[index] is UserProfileScreen) {
          (_pages[index] as UserProfileScreen).createState().initState();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Displays the corresponding screen
      bottomNavigationBar: SafeArea(
        child: _buildBottomNavigationBar(context), // Bottom navigation builder
      ),
    );
  }

  // Build the bottom navigation bar with Cupertino icons
  Widget _buildBottomNavigationBar(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        // Bottom Navigation Bar
        BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          // Update the current index when tapped
          showSelectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          showUnselectedLabels: false,
          selectedItemColor: Color(4292815168),
          // Purple color for selected item
          elevation: 10,
          // Added more elevation for depth
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home, size: 20),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.building_2_fill, size: 20),
              label: 'Business',
            ),
            // This is the middle placeholder item for the FAB
            BottomNavigationBarItem(
              icon: SizedBox.shrink(), // Empty widget for space
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.bell, size: 20),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.profile_circled, size: 20),
              label: 'Profile',
            ),
          ],
        ),
        // Floating Action Button (Add button in the middle)
        Positioned(
          bottom: 10,
          left: MediaQuery.of(context).size.width / 2 - 30, // Center the button
          child: AnimatedScale(
            scale: _currentIndex == 2 ? 1.1 : 1.0,
            // Slight scale effect when FAB is selected
            duration: const Duration(milliseconds: 250),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddShop()));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50), // Fully rounded button
              ),
              elevation: 8, // Elevation for depth
              child: Icon(CupertinoIcons.add, // Cupertino icon for add
                  size: 20, // Slightly bigger icon for the FAB
                  color: Colors.white,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
