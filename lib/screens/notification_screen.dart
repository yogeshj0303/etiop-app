import 'package:flutter/material.dart';
import '../services/api_services.dart'; // Import the ApiService
import 'package:shared_preferences/shared_preferences.dart';
import '../generated/app_localizations.dart';
import '../services/translation_service.dart';
import '../providers/language_provider.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ApiService _apiService = ApiService();
  final TranslationService _translationService = TranslationService();
  List<dynamic> _notifications = [];
  bool _isLoading = true;
  bool _isTranslating = false;
  Map<String, String> _translatedNotifications = {};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen for language changes and retranslate if needed
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    if (languageProvider.currentLanguageCode != 'en' && _notifications.isNotEmpty) {
      _translateNotifications();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchNotifications() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('id');
      
      if (userId == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'User ID not found';
        });
        return;
      }

      final notifications = await _apiService.fetchNotifications(int.parse(userId));
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
      
      // Translate notifications after fetching
      await _translateNotifications();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load notifications: $e';
      });
    }
  }

  Future<void> _translateNotifications() async {
    if (_notifications.isEmpty) return;
    
    try {
      setState(() {
        _isTranslating = true;
      });

      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      final currentLanguage = languageProvider.currentLanguageCode;
      
      // Only translate if not in English
      if (currentLanguage == 'en') {
        setState(() {
          _translatedNotifications = {};
          _isTranslating = false;
        });
        return;
      }

      Map<String, String> translated = {};
      
      for (int i = 0; i < _notifications.length; i++) {
        final notification = _notifications[i];
        final title = notification['title']?.toString() ?? '';
        final message = notification['message']?.toString() ?? '';
        
        if (title.isNotEmpty) {
          try {
            final translatedTitle = await _translationService.translateText(title, currentLanguage);
            translated['title_$i'] = translatedTitle;
          } catch (e) {
            // If translation fails, use original title
            translated['title_$i'] = title;
            print('Failed to translate title for notification $i: $e');
          }
        }
        
        if (message.isNotEmpty) {
          try {
            final translatedMessage = await _translationService.translateText(message, currentLanguage);
            translated['message_$i'] = translatedMessage;
          } catch (e) {
            // If translation fails, use original message
            translated['message_$i'] = message;
            print('Failed to translate message for notification $i: $e');
          }
        }
      }
      
      setState(() {
        _translatedNotifications = translated;
        _isTranslating = false;
      });
    } catch (e) {
      setState(() {
        _isTranslating = false;
        _errorMessage = 'Translation failed: $e';
      });
    }
  }

  // Method to retranslate a specific notification
  Future<void> _retranslateNotification(int index) async {
    if (index >= _notifications.length) return;
    
    try {
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      final currentLanguage = languageProvider.currentLanguageCode;
      
      if (currentLanguage == 'en') return;
      
      final notification = _notifications[index];
      final title = notification['title']?.toString() ?? '';
      final message = notification['message']?.toString() ?? '';
      
      if (title.isNotEmpty) {
        final translatedTitle = await _translationService.translateText(title, currentLanguage);
        setState(() {
          _translatedNotifications['title_$index'] = translatedTitle;
        });
      }
      
      if (message.isNotEmpty) {
        final translatedMessage = await _translationService.translateText(message, currentLanguage);
        setState(() {
          _translatedNotifications['message_$index'] = translatedMessage;
        });
      }
    } catch (e) {
      print('Failed to retranslate notification $index: $e');
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
            onPressed: () => Navigator.pop(context)),
        elevation: 1,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.notifications,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          if (_notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _fetchNotifications,
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.red[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchNotifications,
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      );
    }

    if (_notifications.isEmpty) {
      return Center(
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
      );
    }

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _fetchNotifications,
          child: ListView.separated(
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              return _buildNotificationItem(_notifications[index], index);
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
        ),
      ],
    );
  }

  // Notification item widget
  Widget _buildNotificationItem(dynamic notification, int index) {
    final title = _translatedNotifications['title_$index'] ?? notification['title']?.toString() ?? '';
    final message = _translatedNotifications['message_$index'] ?? notification['message']?.toString() ?? '';
    
    return GestureDetector(
      onLongPress: () {
        // Show retranslate option on long press
        _showRetranslateDialog(index);
      },
      child: ListTile(
        leading: const Icon(
          Icons.notifications,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          message,
        ),
        trailing: Text(
          _formatTimestamp(notification['created_at']), // Use created_at for timestamp
          style: const TextStyle(fontSize: 12),
        ),
        onTap: () {
          // Handle notification tap if needed
        },
      ),
    );
  }

  // Show dialog for retranslating notification
  void _showRetranslateDialog(int index) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    if (languageProvider.currentLanguageCode == 'en') return;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notification'),
          content: Text('Retranslate this notification?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _retranslateNotification(index);
              },
              child: Text('Retranslate'),
            ),
          ],
        );
      },
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
