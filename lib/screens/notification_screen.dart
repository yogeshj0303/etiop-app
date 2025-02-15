import 'package:flutter/material.dart';

import 'main_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 18,
            ),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainScreen()))),
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'NOTIFICATIONS',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: ListView.separated(
        itemCount: 10, // Number of notifications
        itemBuilder: (context, index) {
          return _buildNotificationItem(index);
        },
        separatorBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              color: Colors.grey, // Subtle grey color for the divider
              thickness: 0.5, // Thinner line for a more professional look
              height: 1, // Space between the list item and the divider
            ),
          );
        },
      ),
    );
  }

  // Notification item widget
  Widget _buildNotificationItem(int index) {
    return ListTile(
      leading: const Icon(
        Icons.notifications,
      ),
      title: Text(
        'Notification Title $index',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        'This is the description of the notification $index',
      ),
      trailing: Text(
        '12:00 PM', // Replace with actual timestamp
        style: const TextStyle(fontSize: 12),
      ),
      onTap: () {
        // Handle notification click, navigate to a detail page if needed
      },
    );
  }
}
