class Subscription {
  final int id;
  final String userId;
  final String planType; // 'monthly' or 'yearly'
  final double amount;
  final bool autoDebit;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // 'active', 'expired', 'cancelled'
  final String paymentMethod;

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
    );
  }
}