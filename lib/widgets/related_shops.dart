import 'package:flutter/material.dart';
import '../modals/related_shops.dart';
import '../screens/shop_details_screen.dart';
import '../services/api_services.dart';
import '../generated/app_localizations.dart';
import 'translated_text.dart';

class RelatedShopsScreen extends StatefulWidget {
  final int categoryId;

  const RelatedShopsScreen({Key? key, required this.categoryId}) : super(key: key);

  @override
  _RelatedShopsScreenState createState() => _RelatedShopsScreenState();
}

class _RelatedShopsScreenState extends State<RelatedShopsScreen> {
  late Future<List<RelatedShop>> _relatedShops;

  @override
  void initState() {
    super.initState();
    _relatedShops = ApiService().fetchRelatedShops(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<RelatedShop>>(
        future: _relatedShops,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.stackTrace);
            return Center(
              child: Text(
                AppLocalizations.of(context)!.networkError,
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.noShopsAvailable,
                style: TextStyle(fontSize: 16, ),
              ),
            );
          }

          final shops = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: SizedBox(
              height: 220,
              child: ListView.builder(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                itemCount: shops.length,
                itemBuilder: (context, index) {
                  final shop = shops[index];
                  return _buildShopCard(shop);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  /// Method to build a card for each shop
  Widget _buildShopCard(RelatedShop shop) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShopDetailsScreen(shopId: shop.id),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  color: Colors.white,
                  child: shop.shopImage.isNotEmpty
                      ? Image.network(
                          shop.shopImage.startsWith('http')
                              ? shop.shopImage
                              : 'https://etiop.in/${shop.shopImage}',
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.image_not_supported,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppLocalizations.of(context)!.noData,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: progress.expectedTotalBytes != null
                                    ? progress.cumulativeBytesLoaded /
                                        progress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Icon(
                            Icons.store,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TranslatedText(
                  text: shop.shopName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //   child: Text(
              //     shop.area,
              //     maxLines: 1,
              //     overflow: TextOverflow.ellipsis,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
