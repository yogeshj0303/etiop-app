// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../services/api_services.dart';
// import '../screens/subscription_screen.dart';
// import 'package:flutter/services.dart';

// class SubscriptionDetailsScreen extends StatefulWidget {
//   const SubscriptionDetailsScreen({Key? key}) : super(key: key);

//   @override
//   _SubscriptionDetailsScreenState createState() => _SubscriptionDetailsScreenState();
// }

// class _SubscriptionDetailsScreenState extends State<SubscriptionDetailsScreen> {
//   bool _isLoading = true;
//   Map<String, dynamic>? _userData;
//   String _errorMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserDetails();
//   }

//   Future<void> _fetchUserDetails() async {
//     try {
//       final result = await ApiService().fetchUserDetails();
      
//       setState(() {
//         _isLoading = false;
//         if (result['success']) {
//           _userData = result['data'];
//         } else {
//           _errorMessage = result['message'];
//         }
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'Error fetching subscription details: $e';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text(
//           'Subscription Detail',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//       ),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : _errorMessage.isNotEmpty
//               ? _buildErrorState()
//               : _buildSubscriptionDetails(),
//     );
//   }

//   Widget _buildErrorState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
//           const SizedBox(height: 16),
//           Text(
//             _errorMessage,
//             style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 _isLoading = true;
//                 _errorMessage = '';
//               });
//               _fetchUserDetails();
//             },
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: const Text('Try Again'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSubscriptionDetails() {
//     final user = _userData?['user'];
//     if (user == null) {
//       return const Center(child: Text('No subscription data available'));
//     }

//     final paymentStatus = user['payment_status'] ?? 'inactive';
//     final expiryDate = user['expiry_date'] != null 
//         ? DateTime.parse(user['expiry_date']) 
//         : null;
//     final remainingDays = expiryDate != null 
//         ? expiryDate.difference(DateTime.now()).inDays 
//         : 0;
//     final isActive = paymentStatus.toLowerCase() == 'active' && 
//         expiryDate != null && 
//         expiryDate.isAfter(DateTime.now());

//     return Container(
//       color: Colors.grey[50],
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Premium Status Banner
//             Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Color(0xFF1A237E),
//                     Color(0xFF283593),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: SafeArea(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(20, 30, 20, 40),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.2),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Icon(
//                               isActive ? Icons.verified : Icons.business_center,
//                               color: Colors.white,
//                               size: 24,
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 isActive ? 'Premium Business' : 'Basic Business',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   letterSpacing: 0.5,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 isActive ? 'Active Registration' : 'Registration Required',
//                                 style: TextStyle(
//                                   color: Colors.white.withOpacity(0.9),
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // Status Card
//             Transform.translate(
//               offset: const Offset(0, -20),
//               child: Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.06),
//                       blurRadius: 16,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: _buildStatusItem(
//                               title: 'Status',
//                               value: isActive ? 'Active' : 'Inactive',
//                               icon: isActive ? Icons.check_circle : Icons.error_outline,
//                               color: isActive ? Colors.green : Colors.red,
//                             ),
//                           ),
//                           Container(
//                             width: 1,
//                             height: 40,
//                             color: Colors.grey[200],
//                           ),
//                           Expanded(
//                             child: _buildStatusItem(
//                               title: 'Days Remaining',
//                               value: isActive ? '$remainingDays days' : '0 days',
//                               icon: Icons.timer,
//                               color: Colors.blue[700]!,
//                             ),
//                           ),
//                         ],
//                       ),
//                       if (isActive) ...[
//                         const Divider(height: 32),
//                         _buildExpiryInfo(expiryDate!),
//                       ],
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // Business Details Section
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildSectionTitle('Business Information'),
//                   const SizedBox(height: 16),
//                   _buildBusinessCard(user),
//                   const SizedBox(height: 24),
//                   _buildSectionTitle('Registration Details'),
//                   const SizedBox(height: 16),
//                   _buildRegistrationDetails(remainingDays, expiryDate),
//                   const SizedBox(height: 24),
//                   if (!isActive || remainingDays < 30)
//                     _buildActionButton(isActive),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusItem({
//     required String title,
//     required String value,
//     required IconData icon,
//     required Color color,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 28),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildExpiryInfo(DateTime expiryDate) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.blue[50],
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(Icons.event, color: Colors.blue[700], size: 20),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Registration Expires',
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 14,
//                 ),
//               ),
//               Text(
//                 DateFormat('MMMM d, yyyy').format(expiryDate),
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBusinessCard(Map<String, dynamic> user) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           _buildBusinessDetailTile(
//             icon: Icons.business,
//             title: 'Business Name',
//             value: user['business_name'] ?? 'Not registered',
//           ),
//           const Divider(height: 1),
//           _buildBusinessDetailTile(
//             icon: Icons.location_on,
//             title: 'Location',
//             value: user['business_address'] ?? 'Not specified',
//           ),
//           const Divider(height: 1),
//           _buildBusinessDetailTile(
//             icon: Icons.category,
//             title: 'Business Type',
//             value: user['business_type'] ?? 'Not specified',
//             isLast: true,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBusinessDetailTile({
//     required IconData icon,
//     required String title,
//     required String value,
//     bool isLast = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.blue[50],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(icon, color: Colors.blue[700], size: 20),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//         letterSpacing: 0.5,
//       ),
//     );
//   }

//   Widget _buildRegistrationDetails(int remainingDays, DateTime? expiryDate) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           _buildBusinessDetailTile(
//             icon: Icons.assignment,
//             title: 'Registration Type',
//             value: remainingDays > 180 ? 'Annual Registration' : 'Monthly Registration',
//           ),
//           const Divider(height: 1),
//           _buildBusinessDetailTile(
//             icon: Icons.payment,
//             title: 'Payment Status',
//             value: 'Paid',
//             isLast: true,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButton(bool isActive) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: ElevatedButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => SubscriptionScreen()),
//           );
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.blue[700],
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 0,
//         ),
//         child: Text(
//           isActive ? 'Renew Registration' : 'Register Business',
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             letterSpacing: 0.5,
//           ),
//         ),
//       ),
//     );
//   }
// } 