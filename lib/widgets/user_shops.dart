import 'package:etiop_application/widgets/shop_requirment.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../modals/shop_model.dart';
import '../services/api_services.dart'; // Import the API services
import '../screens/subscription_screen.dart';
import 'edit_screen.dart';

class UserShopScreen extends StatefulWidget {
  final List<Shop> shops;

  const UserShopScreen({super.key, required this.shops});

  @override
  _UserShopScreenState createState() => _UserShopScreenState();
}

class _UserShopScreenState extends State<UserShopScreen> {
  late List<Shop> shops;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    shops = widget.shops;
    // Check if shops is empty and navigate back
    if (shops.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    }
  }

  Future<void> _renewSubscription(Shop shop) async {
    try {
      setState(() => _isLoading = true);
      
      // Navigate to subscription screen
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SubscriptionScreen(),
        ),
      );

      // If subscription was successful, refresh the shop data
      if (result == true) {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('id');
        if (userId != null) {
          final response = await http.get(
            Uri.parse('https://etiop.in/api/requirements-get-byowner/$userId'),
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            final data = jsonDecode(response.body);
            if (data['success']) {
              setState(() {
                final List shopsList = data['data']['shops'];
                shops = shopsList.map((shopData) {
                  return Shop.fromJson({
                    ...shopData['shop'],
                    'requirements': shopData['requirements'],
                    'category_name': shopData['shop']['category_name'],
                  });
                }).toList();
              });
            }
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Function to delete the shop
  Future<void> _deleteShop(BuildContext context, int shopId) async {
    // Show confirmation dialog
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmDelete),
          content: Text(AppLocalizations.of(context)!.confirmDeleteShop),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                AppLocalizations.of(context)!.delete,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    ) ?? false;

    if (!confirmDelete) return;

    try {
      final responseBody = await ApiService.deleteShop(shopId);

      if (responseBody['success'] == true) {
        setState(() {
          shops.removeWhere((shop) => shop.id == shopId);
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.shopDeletedSuccessfully)),
          );
          
          // Check if shops list is empty after deletion
          if (shops.isEmpty) {
            Navigator.pop(context);
          } else {
            // Only refresh if there are still shops
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserShopScreen(shops: shops),
              ),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${AppLocalizations.of(context)!.failedToDeleteShop}: ${responseBody['message']}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  void _navigateToEditScreen(Shop shop) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditShopScreen(
          shop: shop,
          categoryName: shop.categoryName ?? '',
        ),
      ),
    );

    // If the shop was updated, refresh the shop data
    if (result != null && result is Shop) {
      setState(() {
        // Find and update the shop in the list
        final index = shops.indexWhere((s) => s.id == shop.id);
        if (index != -1) {
          shops[index] = result;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            // Navigate back to the previous screen
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.myShops,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: shops.length,
        itemBuilder: (context, index) {
          Shop shop = shops[index];
          String imageUrl = shop.fullImageUrl ?? '';

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : const Center(
                                child: Icon(
                                  Icons.store,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                      if (shop.paymentStatus != 'Active')
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.expired,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                shop.shopName ?? 'Shop Name',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (shop.paymentStatus == 'Active')
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert, size: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _navigateToEditScreen(shop);
                                  } else if (value == 'delete') {
                                    _deleteShop(context, shop.id);
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, size: 20),
                                          SizedBox(width: 12),
                                          Text(AppLocalizations.of(context)!.editShop),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, size: 20, color: Colors.red),
                                          SizedBox(width: 12),
                                          Text(AppLocalizations.of(context)!.deleteShop, style: TextStyle(color: Colors.red)),
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                              ),
                          ],
                        ),
                        if (shop.expiryDate != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: shop.paymentStatus == 'Active'
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: shop.paymentStatus == 'Active'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${AppLocalizations.of(context)!.expires}: ${shop.expiryDate}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: shop.paymentStatus == 'Active'
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        if (shop.paymentStatus != 'Active')
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _renewSubscription(shop),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.renewSubscription,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
