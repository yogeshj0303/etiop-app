import 'dart:convert';
import 'package:etiop_application/screens/subscription_screen.dart';
import 'package:etiop_application/widgets/shop_form.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../modals/subscription_model.dart';
import '../services/api_services.dart';
import 'package:flutter/material.dart';

class PaymentService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static const String baseUrl = 'https://etiop.acttconnect.com/api/';

  // Check if user is in trial period
  static Future<bool> isInTrialPeriod() async {
    try {
      final apiService = ApiService();
      final userId = await apiService.getUserId();

      if (userId == null) {
        return false;
      }

      final response = await http.get(
        Uri.parse('${baseUrl}get-user?user_id=$userId'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final user = data['user'];

        if (user != null) {
          final createdAt = DateTime.parse(user['created_at']);
          final oneMonthTrial = createdAt.add(const Duration(days: 30));

          // Check if within trial period
          return DateTime.now().isBefore(oneMonthTrial);
        }
      }

      return false;
    } catch (e) {
      print('Error checking trial period: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> purchasePackage({
    required double amount,
    required String durationType, // 'annual' or 'monthly'
    required String orderId,
    required String transactionId,
  }) async {
    try {
      // Get user ID
      final apiService = ApiService();
      final userId = await apiService.getUserId();

      if (userId == null) {
        return {'success': false, 'message': 'User ID not found'};
      }

      print('Purchasing package: $durationType for user $userId');
      print(
          'Transaction details: Order ID: $orderId, Transaction ID: $transactionId');

      // Prepare request body
      final body = jsonEncode({
        'user_id': int.parse(userId),
        'amount': amount,
        'duration_type': durationType,
        'order_id': orderId,
        'trasaction_id': transactionId,
      });

      // Make API request
      final response = await http.post(
        Uri.parse('https://etiop.acttconnect.com/api/purchase-package'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body,
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        // Save subscription status to preferences for local access
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('has_subscription', true);
        prefs.setString('subscription_type', durationType);
        prefs.setString(
            'subscription_expiry',
            DateTime.now()
                .add(durationType == 'annual'
                    ? const Duration(days: 365)
                    : const Duration(days: 30))
                .toIso8601String());

        return {
          'success': true,
          'message':
              'Your ${durationType == 'annual' ? 'annual' : 'monthly'} subscription has been activated successfully!',
          'data': responseData
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to purchase package. Please try again later.'
        };
      }
    } catch (e) {
      print('Error during package purchase: $e');
      return {'success': false, 'message': 'Error purchasing package: $e'};
    }
  }
}
