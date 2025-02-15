import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  // List of widgets for each tab page
  final List<Widget> _pages = [
    const Center(child: Text('Home', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Shops', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Notifications', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Profile', style: TextStyle(fontSize: 24))),
  ];

  // Method to handle bottom navigation item selection
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: _buildBottomNavigationBar(context), // Pass context to the bottom bar builder
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
          onTap: _onItemTapped, // Update current index when tapped
          showSelectedLabels: true,
          showUnselectedLabels: false,
          elevation: 12, // Added more elevation for depth
          backgroundColor: Colors.white, // Background color for the bottom bar
          selectedItemColor: CupertinoColors.activeBlue, // Selected icon color
          unselectedItemColor: CupertinoColors.inactiveGray, // Unselected icon color
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home, size: 30),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.building_2_fill, size: 30),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: SizedBox.shrink(), // Empty widget to create space for the floating button
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.bell, size: 30),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.profile_circled, size: 30),
              label: 'Profile',
            ),
          ],
        ),
        Positioned(
          bottom: 20,
          left: MediaQuery.of(context).size.width / 2 - 30, // Center the button
          child: AnimatedScale(
            scale: _currentIndex == 2 ? 1.1 : 1.0, // Slight scale effect when FAB is selected
            duration: const Duration(milliseconds: 250),
            child: FloatingActionButton(
              onPressed: () {
                // Handle the action for the Add button
                print("Add button pressed");
              },
              backgroundColor: CupertinoColors.activeBlue, // Custom color for FAB
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50), // Fully rounded button
              ),
              elevation: 8, // Elevation for depth
              child: Icon(
                CupertinoIcons.add, // Cupertino icon for add
                size: 30, // Slightly bigger icon for the FAB
                color: Colors.white, // White icon color
              ),
            ),
          ),
        ),
      ],
    );
  }
}
