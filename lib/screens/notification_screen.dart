import 'package:flutter/material.dart';
import '../services/api_services.dart'; // Import the ApiService
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('id');
      
      if (userId == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final notifications = await _apiService.fetchNotifications(int.parse(userId));
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
        title: Text(
          AppLocalizations.of(context)!.notifications,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.noNotifications,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.noNotificationsMessage,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
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
        _formatTimestamp(notification['created_at']), // Use created_at for timestamp
        style: const TextStyle(fontSize: 12),
      ),
      onTap: () {            },
    );
  }

  // Update the method to format the created_at timestamp
  String _formatTimestamp(String? createdAt) {
    if (createdAt == null) {
      return AppLocalizations.of(context)!.noTimestamp;
    }
    try {
      final DateTime dateTime = DateTime.parse(createdAt);
      final String formattedTime = TimeOfDay.fromDateTime(dateTime).format(context);
      return formattedTime;
    } catch (e) {
      return AppLocalizations.of(context)!.invalidDate;
    }
  }
}
