import 'package:etiop_application/widgets/shop_requirment.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

import '../modals/shop_model.dart';
import '../services/api_services.dart'; // Import the API services
import 'edit_screen.dart';

class UserShopScreen extends StatefulWidget {
  final List<Shop> shops;

  const UserShopScreen({super.key, required this.shops});

  @override
  _UserShopScreenState createState() => _UserShopScreenState();
}

class _UserShopScreenState extends State<UserShopScreen> {
  // Function to retrieve user_id from SharedPreferences
  Future<String?> _getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('id'); // Get the user ID from SharedPreferences
  }

  // Function to delete the shop
  Future<void> _deleteShop(BuildContext context, int shopId) async {
    final String? userId =
        await _getUserId(); // Get user ID from SharedPreferences
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User ID not found. Please log in again.')));
      return;
    }

    try {
      final responseBody = await ApiService.deleteShop(shopId);

      if (responseBody['status'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Shop deleted successfully')));

        // Update the shop list by removing the deleted shop from the list
        setState(() {
          widget.shops.removeWhere((shop) => shop.id == shopId);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Failed to delete shop: ${responseBody['message']}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
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
        title: const Text(
          'My Shops',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 1,
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two columns in the grid
          crossAxisSpacing: 14.0, // Space between columns
          mainAxisSpacing: 14.0, // Space between rows
          childAspectRatio: 1, // Aspect ratio for grid items
        ),
        padding: const EdgeInsets.all(12.0),
        itemCount: widget.shops.length,
        itemBuilder: (context, index) {
          Shop shop = widget.shops[index];
          // Update the image URL construction
          String imageUrl = shop.fullImageUrl ?? '';

          return GestureDetector(
            onTap: () {
              // Navigate to Shop Requirements screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShopRequirementsScreen(
                      shopId: shop.id, // Pass shop ID to the next screen
                      requirements: widget.shops[index].requirements ?? []),
                ),
              );
            },
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              elevation: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // Clip image corners
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl, // Use image URL
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 50,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.broken_image,
                            size: 50,
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            child: Text(
                              shop.shopName ?? 'Shop Name',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis, // Handle text overflow
                            ),
                          ),
                        ),
                        // Popup menu for Edit and Delete options
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              print('Edit shop');
                              print(shop);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditShopScreen(shop: shop),
                                ),
                              );
                            } else if (value == 'delete') {
                              // Delete the shop
                              _deleteShop(context, shop.id);
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ];
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
