import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/payment_service.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  late Razorpay _razorpay;
  bool _isLoading = false;
  String _selectedPlan = 'monthly';
  bool _autoDebit = true;
  
  // Plan details
  final Map<String, Map<String, dynamic>> _planDetails = {
    'monthly': {
      'price': 100,
      'period': 'month',
      'discount': 0,
      'features': [
        'Register up to 5 businesses',
        'Business compliance monitoring',
        'Document management system',
        'Priority customer support',
        'Basic analytics dashboard',
      ],
    },
    'yearly': {
      'price': 1200,
      'period': 'year',
      'discount': 200,
      'features': [
        'Register unlimited businesses',
        'Advanced compliance monitoring',
        'Document management system',
        'Priority customer support 24/7',
        'Advanced analytics & reporting',
        'Bulk registration discount',
        'Dedicated account manager',
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  //get user id from shared preferences
  Future<String?> getUserMobileNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('mobile_number');
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    setState(() => _isLoading = true);
    
    try {
      final planDetails = _planDetails[_selectedPlan]!;
      final price = planDetails['price'];
      final discount = planDetails['discount'];
      final finalPrice = price - discount;

      final result = await PaymentService.purchasePackage(
        amount: finalPrice.toDouble(),
        durationType: _selectedPlan == 'monthly' ? 'monthly' : 'annual',
        orderId: response.orderId ?? 'ORD${DateTime.now().millisecondsSinceEpoch}',
        transactionId: response.paymentId ?? 'TXN${DateTime.now().millisecondsSinceEpoch}',
      );
      
      if (result['success'] == true) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: Text(result['message'] ?? 'Subscription activated successfully'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Payment failed')),
        );
      }
    } catch (e) {
      print('Payment error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing payment: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External wallet selected: ${response.walletName}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Subscription'),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSubscriptionCard(),
              const SizedBox(height: 24),
              _buildSubscriptionDetails(),
              const SizedBox(height: 32),
              _buildPaymentButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified,
                    size: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Official Registration',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Choose Your Plan',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select the perfect registration package for your business',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            _buildPlanSelector(),
            const SizedBox(height: 32),
            _buildFeaturesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanSelector() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          _buildPlanOption('monthly', isSelected: _selectedPlan == 'monthly'),
          _buildPlanOption('yearly', isSelected: _selectedPlan == 'yearly'),
        ],
      ),
    );
  }

  Widget _buildPlanOption(String plan, {required bool isSelected}) {
    final details = _planDetails[plan]!;
    final price = details['price'];
    final discount = details['discount'];
    final finalPrice = price - discount;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = plan),
      child: AnimatedContainer(
        
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected 
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                plan == 'monthly' ? Icons.business : Icons.business_center,
                color: isSelected 
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        plan == 'monthly' ? 'Professional' : 'Enterprise',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isSelected 
                            ? Theme.of(context).primaryColor
                            : Colors.black87,
                        ),
                      ),
                      if (plan == 'yearly') ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'SAVE 20%',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹$finalPrice/${plan == 'monthly' ? 'month' : 'year'}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Radio(
              value: plan,
              groupValue: _selectedPlan,
              onChanged: (value) => setState(() => _selectedPlan = value as String),
              activeColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = _planDetails[_selectedPlan]?['features'] as List<String>? ?? [];
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Included Features',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 20),
          ...features.map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.check,
                    color: Theme.of(context).primaryColor,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    feature,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildSubscriptionDetails() {
    final selectedPlanDetails = _planDetails[_selectedPlan]!;
    final price = selectedPlanDetails['price'];
    final discount = selectedPlanDetails['discount'];
    final finalPrice = price - discount;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subscription Detail',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Base Price:', '₹$price'),
            if (discount > 0) _buildDetailRow('Discount:', '-₹$discount'),
            _buildDetailRow(
              'Total:',
              '₹$finalPrice',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentButton() {
    return Container(
      width: double.infinity,
      height: 56,
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: ElevatedButton(
        onPressed: _isLoading ? null : () => _processPayment(),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: _isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Continue to Payment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 20),
              ],
            ),
      ),
    );
  }

  Future<void> _processPayment() async {
    try {
      final planDetails = _planDetails[_selectedPlan]!;
      final price = planDetails['price'];
      final discount = planDetails['discount'];
      final finalPrice = price - discount;
      
      var options = {
        'key': 'rzp_test_JyaG2v7ojg9mwa',  // Replace with your actual Razorpay key
        'amount': finalPrice * 100, // Amount in smallest currency unit (paise)
        'name': 'ETIOP Subscription',
        'description': '${_selectedPlan.toUpperCase()} Plan',
        'prefill': {
          'contact': await getUserMobileNumber(),
          'email': await getUserEmail(),
        },
      };

      _razorpay.open(options);
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _buildPlanTitle(String title, String price, bool isPro) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color(0xFF281717),
            fontSize: 16,
            fontFamily: 'Poppins_regular',
            fontWeight: FontWeight.w700,
            letterSpacing: 0.10,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            color: Color(0xFF757575),
            fontSize: 14,
            fontFamily: 'Poppins_regular',
            fontWeight: FontWeight.w500,
            letterSpacing: 0.10,
          ),
        ),
      ],
    );
  }

  Widget _buildEnterpriseHeader() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "Enterprise",
              style: TextStyle(
                color: Colors.black.withOpacity(0.87),
                fontSize: 16,
                fontFamily: 'Poppins_regular',
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
                height: 1.4,
              ),
            ),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "SAVE 20%",
              style: TextStyle(
                color: Color(0xFF388E3C),
                fontSize: 12,
                fontFamily: 'Poppins_regular',
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}  