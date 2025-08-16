class Subscription {
  final int id;
  final String userId;
  final String planType; // 'monthly', 'yearly', '3years', '5years', '10years'
  final double amount;
  final bool autoDebit;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // 'active', 'expired', 'cancelled', 'trial'
  final String paymentMethod;
  final int durationInDays; // Duration in days for easy calculation

  Subscription({
    required this.id,
    required this.userId,
    required this.planType,
    required this.amount,
    required this.autoDebit,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.paymentMethod,
    required this.durationInDays,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      userId: json['user_id'],
      planType: json['plan_type'],
      amount: json['amount'].toDouble(),
      autoDebit: json['auto_debit'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      status: json['status'],
      paymentMethod: json['payment_method'],
      durationInDays: json['duration_in_days'] ?? _calculateDurationInDays(json['plan_type']),
    );
  }

  // Helper method to calculate duration in days based on plan type
  static int _calculateDurationInDays(String planType) {
    switch (planType) {
      case 'monthly':
        return 30;
      case 'yearly':
        return 365;
      case '3years':
        return 3 * 365;
      case '5years':
        return 5 * 365;
      case '10years':
        return 10 * 365;
      default:
        return 30; // Default to monthly
    }
  }

  // Check if subscription is currently active
  bool get isActive {
    if (status == 'cancelled') return false;
    if (status == 'trial') return true; // Trial is always active
    return status == 'active' && DateTime.now().isBefore(endDate);
  }

  // Check if subscription is expired
  bool get isExpired {
    return DateTime.now().isAfter(endDate);
  }

  // Get remaining days
  int get remainingDays {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return 0;
    return endDate.difference(now).inDays;
  }

  // Get trial expiry date (1 month from start)
  DateTime get trialExpiryDate {
    return startDate.add(const Duration(days: 30));
  }

  // Check if currently in trial period
  bool get isInTrial {
    return status == 'trial' && DateTime.now().isBefore(trialExpiryDate);
  }
}