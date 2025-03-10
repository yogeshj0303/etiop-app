import 'package:etiop_application/screens/shop_details_screen.dart';
import 'package:etiop_application/services/api_services.dart';
import 'package:flutter/material.dart';

import '../modals/shop_model.dart';

class ShopsCarousel extends StatefulWidget {
  @override
  _ShopsCarouselState createState() => _ShopsCarouselState();
}

class _ShopsCarouselState extends State<ShopsCarousel> {
  late Future<List<Shop>> _shopsFuture;

  @override
  void initState() {
    super.initState();
    _shopsFuture = ApiService().fetchShops();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Shop>>(
        future: _shopsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.stackTrace);
            return Center(child: Text('Failed to load shops'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No shops available'));
          } else {
            final shops = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListView.builder(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                // Horizontal scrolling
                itemCount: (shops.length > 6) ? 6 : shops.length,
                // Limit to 3 items
                itemBuilder: (context, index) {
                  final shop = shops[index];
                  return GestureDetector(
                    onTap: () {
                      // Implement action on shop tap if needed
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ShopDetailsScreen(shopId: shop.id),
                        ),
                      );
                    },
                    child: Container(
                      width: 120, // Width of each card
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Apply border radius here
                        ),
                        elevation: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              (shop.shopImage ?? "").isNotEmpty
                                  ? Image.network(
                                      "https://etiop.acttconnect.com/${shop.shopImage}",
                                      fit: BoxFit.fill,
                                      height: 120,
                                      width: double.infinity,
                                    )
                                  : Icon(Icons.shop, size: 50),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  shop.shopName ?? "Shop Name",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
