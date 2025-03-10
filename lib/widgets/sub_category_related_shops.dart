import 'package:etiop_application/services/api_services.dart';
import 'package:flutter/material.dart';

import '../modals/sub_category_related_shops_model.dart';
import '../screens/shop_details_screen.dart';

class SubCategoryRelatedShops extends StatefulWidget {
  final int subCategoryId;

  const SubCategoryRelatedShops({Key? key, required this.subCategoryId})
      : super(key: key);

  @override
  _SubCategoryRelatedShopsState createState() =>
      _SubCategoryRelatedShopsState();
}

class _SubCategoryRelatedShopsState extends State<SubCategoryRelatedShops> {
  late Future<List<SubCategoryRelatedShopModel>> _relatedShops;
  final String baseUrl = 'https://etiop.acttconnect.com/';

  @override
  void initState() {
    super.initState();
    _relatedShops =
        ApiService().fetchSubCategoryRelatedShops(widget.subCategoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Related Shops',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 18,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 1,
      ),
      body: FutureBuilder<List<SubCategoryRelatedShopModel>>(
        future: _relatedShops,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString().replaceAll('Exception: ', '')));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No shops found.'));
          } else {
            final shops = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns in the grid
                crossAxisSpacing: 10.0, // Horizontal space between items
                mainAxisSpacing: 10.0, // Vertical space between items
                childAspectRatio:
                    0.85, // Aspect ratio of each grid item (width/height)
              ),
              itemCount: shops.length,
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
                  child: Card(
                    margin: EdgeInsets.all(8),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                    // Subtle shadow
                    clipBehavior: Clip.antiAlias,
                    // Ensure rounded corners work well
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          // Make the image fill the card's width
                          height: 120,
                          // Fixed height for image
                          child: shop.shopImage != null
                              ? Image.network(
                                  '$baseUrl${shop.shopImage}',
                                  fit: BoxFit
                                      .fill, // Ensure image covers the card
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                        ),
                                      );
                                    }
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                        'assets/default_image.png');
                                  },
                                )
                              : Image.asset('assets/default_image.png'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                shop.shopName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${shop.district}, ${shop.state}',
                                style: TextStyle(
                                  fontSize: 10,
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
            );
          }
        },
      ),
    );
  }
}
