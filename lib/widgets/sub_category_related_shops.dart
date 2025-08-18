import 'package:etiop_application/services/api_services.dart';
import 'package:flutter/material.dart';

import '../modals/sub_category_related_shops_model.dart';
import '../screens/shop_details_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'translated_text.dart';

class SubCategoryRelatedShops extends StatefulWidget {
  final int subCategoryId;

  const SubCategoryRelatedShops({Key? key, required this.subCategoryId})
      : super(key: key);

  @override
  _SubCategoryRelatedShopsState createState() =>
      _SubCategoryRelatedShopsState();
}

class _SubCategoryRelatedShopsState extends State<SubCategoryRelatedShops> {
  final ApiService _apiService = ApiService();
  List<SubCategoryRelatedShopModel> _relatedShops = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _hasError = false;
  final String baseUrl = 'https://etiop.in/';

  @override
  void initState() {
    super.initState();
    _loadRelatedShops();
  }

  Future<void> _loadRelatedShops() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _errorMessage = null;
      });
      
      final data = await _apiService.fetchSubCategoryRelatedShops(widget.subCategoryId);
      setState(() {
        _relatedShops = data;
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
      print('Error loading related shops: $e');
    }
  }

  Future<void> _retry() async {
    await _loadRelatedShops();
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_hasError) {
      return _buildErrorState();
    }
    
    if (_relatedShops.isEmpty) {
      return _buildEmptyState();
    }
    
    return _buildShopsGrid();
  }

  Widget _buildErrorState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? l10n.networkError,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _retry,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.store_outlined,
            size: 60,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noShopsAvailable,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const Text(
            'No shops found for this subcategory.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildShopsGrid() {
    return RefreshIndicator(
      onRefresh: _loadRelatedShops,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 10.0, // Horizontal space between items
          mainAxisSpacing: 10.0, // Vertical space between items
          childAspectRatio: 0.85, // Aspect ratio of each grid item (width/height)
        ),
        itemCount: _relatedShops.length,
        itemBuilder: (context, index) {
          final shop = _relatedShops[index];
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
              margin: const EdgeInsets.all(8),
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
                        TranslatedText(
                          text: //if it is government then show office name
                          shop.categoryId == 6
                              ? shop.officeName ?? AppLocalizations.of(context)!.noData
                              : shop.shopName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        TranslatedText(
                          text: '${shop.district}, ${shop.state}',
                          style: const TextStyle(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.relatedServices,
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
      body: _buildBody(),
    );
  }
}
