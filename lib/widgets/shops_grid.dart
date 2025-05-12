import 'package:etiop_application/screens/shop_details_screen.dart';
import 'package:etiop_application/services/api_services.dart';
import 'package:flutter/material.dart';

import '../modals/shop_model.dart';
import '../screens/main_screen.dart';

class ShopsGridView extends StatefulWidget {
  const ShopsGridView({
    Key? key,
    this.title,
  }) : super(key: key);

  final String? title;

  @override
  _ShopsGridViewState createState() => _ShopsGridViewState();
}

class _ShopsGridViewState extends State<ShopsGridView> {
  late Future<List<Shop>> _shopsFuture;

  @override
  void initState() {
    super.initState();
    _shopsFuture = ApiService().fetchShops(); // Fetching the shops data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: Colors.black,
          ),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen())),
        ),
        elevation: 1,
        centerTitle: true,
        title: Text(
          widget.title ?? 'BUSINESS',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
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
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns in the grid
                  crossAxisSpacing: 8.0, // Horizontal spacing between items
                  mainAxisSpacing: 8.0, // Vertical spacing between items
                  childAspectRatio: 0.7, // Adjusted for better visibility
                ),
                itemCount: shops.length,
                itemBuilder: (context, index) {
                  final shop = shops[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the shop details screen when tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ShopDetailsScreen(shopId: shop.id),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 4,
                              child: (shop.shopImage ?? "").isNotEmpty
                                  ? Container(
                                      width: double.infinity,
                                      child: Image.network(
                                        "https://etiop.in/${shop.shopImage}",
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                  : Icon(Icons.shop, size: 50),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 4.0),
                                child: Text(
                                  shop.shopName ?? "Shop Name",
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
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
        },
      ),
    );
  }
}
