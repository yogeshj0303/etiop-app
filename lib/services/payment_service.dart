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
  static const String baseUrl = 'https://etiop.in/api/';

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

        if (user != null && user['created_at'] != null) {
          try {
            // Parse the created_at date from the API response
            final createdAt = DateTime.parse(user['created_at']);
            final oneMonthTrial = createdAt.add(const Duration(days: 30));
            final now = DateTime.now();

            // Check if within trial period
            final isInTrial = now.isBefore(oneMonthTrial);
            
            print('Trial period check:');
            print('Account created at: $createdAt');
            print('Trial ends at: $oneMonthTrial');
            print('Current time: $now');
            print('Is in trial: $isInTrial');

            return isInTrial;
          } catch (e) {
            print('Error parsing dates: $e');
            return false;
          }
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
    required String durationType, // 'monthly', 'yearly', '3years', '5years', '10years'
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

      // Calculate expiry date based on duration type
      final now = DateTime.now();
      final expiryDate = _calculateExpiryDate(now, durationType);

      // Prepare request body
      final body = jsonEncode({
        'user_id': int.parse(userId),
        'amount': amount,
        'duration_type': durationType,
        'order_id': orderId,
        'transaction_id': transactionId,
        'expiry_date': expiryDate.toIso8601String(),
        'start_date': now.toIso8601String(),
      });

      // Make API request
      final response = await http.post(
        Uri.parse('https://etiop.in/api/purchase-package'),
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
        prefs.setString('subscription_expiry', expiryDate.toIso8601String());
        prefs.setString('subscription_start', now.toIso8601String());
        prefs.setString('subscription_status', 'active');

        return {
          'success': true,
          'message':
              'Your ${durationType.replaceAll('years', ' year').replaceAll('3', '3-').replaceAll('5', '5-').replaceAll('10', '10-')} subscription has been activated successfully!',
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

  // Calculate expiry date based on duration type
  static DateTime _calculateExpiryDate(DateTime startDate, String durationType) {
    switch (durationType) {
      case 'monthly':
        return startDate.add(const Duration(days: 30));
      case 'yearly':
        return startDate.add(const Duration(days: 365));
      case '3years':
        return startDate.add(const Duration(days: 3 * 365));
      case '5years':
        return startDate.add(const Duration(days: 5 * 365));
      case '10years':
        return startDate.add(const Duration(days: 10 * 365));
      default:
        return startDate.add(const Duration(days: 30)); // Default to monthly
    }
  }

  static Future<bool> hasActiveSubscription() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasSubscription = prefs.getBool('has_subscription') ?? false;
      final subscriptionExpiry = prefs.getString('subscription_expiry');
      final subscriptionStatus = prefs.getString('subscription_status');
      
      if (!hasSubscription || subscriptionExpiry == null) {
        return false;
      }

      // Check if subscription is cancelled
      if (subscriptionStatus == 'cancelled') {
        return false;
      }

      final expiryDate = DateTime.parse(subscriptionExpiry);
      final isActive = DateTime.now().isBefore(expiryDate);
      
      // If subscription has expired, update the status
      if (!isActive && subscriptionStatus == 'active') {
        prefs.setString('subscription_status', 'expired');
      }
      
      return isActive;
    } catch (e) {
      print('Error checking subscription status: $e');
      return false;
    }
  }

  // Get subscription expiry date
  static Future<DateTime?> getSubscriptionExpiryDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final subscriptionExpiry = prefs.getString('subscription_expiry');
      
      if (subscriptionExpiry == null) {
        return null;
      }

      return DateTime.parse(subscriptionExpiry);
    } catch (e) {
      print('Error getting subscription expiry date: $e');
      return null;
    }
  }

  // Get subscription type
  static Future<String?> getSubscriptionType() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('subscription_type');
    } catch (e) {
      print('Error getting subscription type: $e');
      return null;
    }
  }

  // Check if business should be visible based on subscription status
  static Future<bool> shouldShowBusiness() async {
    try {
      // First check if user has active subscription
      final hasSubscription = await hasActiveSubscription();
      if (hasSubscription) {
        return true;
      }

      // If no subscription, check trial period
      final isInTrial = await isInTrialPeriod();
      return isInTrial;
    } catch (e) {
      print('Error checking business visibility: $e');
      return false;
    }
  }

  // Get remaining trial days
  static Future<int> getRemainingTrialDays() async {
    try {
      final apiService = ApiService();
      final userId = await apiService.getUserId();

      if (userId == null) {
        return 0;
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

        if (user != null && user['created_at'] != null) {
          try {
            final createdAt = DateTime.parse(user['created_at']);
            final trialEnd = createdAt.add(const Duration(days: 30));
            final now = DateTime.now();

            if (now.isAfter(trialEnd)) {
              return 0;
            }

            return trialEnd.difference(now).inDays;
          } catch (e) {
            print('Error parsing trial dates: $e');
            return 0;
          }
        }
      }

      return 0;
    } catch (e) {
      print('Error getting remaining trial days: $e');
      return 0;
    }
  }
}
