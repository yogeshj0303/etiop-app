import 'package:flutter/material.dart';
  import '../services/api_services.dart'; // Import the ApiService

import 'main_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final notifications = await _apiService.fetchNotifications(29); // Use the correct user ID
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error, e.g., show a snackbar
    }
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationItem(_notifications[index]);
              },
              separatorBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                    height: 1,
                  ),
                );
              },
            ),
    );
  }

  // Notification item widget
  Widget _buildNotificationItem(dynamic notification) {
    return ListTile(
      leading: const Icon(
        Icons.notifications,
      ),
      title: Text(
        notification['title'],
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        notification['message'],
      ),
      trailing: Text(
        '12:00 PM', // Replace with actual timestamp if available
        style: const TextStyle(fontSize: 12),
      ),
      onTap: () {
        // Handle notification click, navigate to a detail page if needed
      },
    );
  }
}
