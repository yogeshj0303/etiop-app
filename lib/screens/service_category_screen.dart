import 'package:etiop_application/screens/shop_details_screen.dart';
import 'package:etiop_application/widgets/shops_grid.dart';
import 'package:flutter/material.dart';
import '../modals/sub_category.dart';
import '../services/api_services.dart';
import '../modals/shop_model.dart';
import '../screens/subcategory_screen.dart';

class ServiceCategoryScreen extends StatefulWidget {
  const ServiceCategoryScreen({super.key});

  @override
  State<ServiceCategoryScreen> createState() => _ServiceCategoryScreenState();
}

class _ServiceCategoryScreenState extends State<ServiceCategoryScreen> {
  final ApiService _apiService = ApiService();
  int? selectedCategoryId;
  List<dynamic> categories = [];
  List<Subcategory> subcategories = [];
  bool isLoading = true;
  List<Shop> shops = [];
  final String baseUrl = 'https://etiop.in/';

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadShops();
  }

  Future<void> _loadCategories() async {
    try {
      setState(() => isLoading = true);
      final data = await _apiService.fetchCategories();
      setState(() {
        categories = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error loading categories: $e');
    }
  }

  Future<void> _loadSubcategories(int categoryId) async {
    try {
      setState(() => isLoading = true);
      final data = await _apiService.fetchSubcategoriesByCategoryId(categoryId);
      setState(() {
        subcategories = data;
        selectedCategoryId = categoryId;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error loading subcategories: $e');
    }
  }

  Future<void> _loadShops() async {
    try {
      final data = await _apiService.fetchShops();
      setState(() {
        shops = data;
      });
    } catch (e) {
      print('Error loading shops: $e');
    }
  }

  Widget _buildSubcategories() {
    if (selectedCategoryId == null || subcategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Subcategories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: subcategories.length,
            itemBuilder: (context, index) {
              final subcategory = subcategories[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[200]!,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    // Filter shops by subcategory and navigate to shop details
                    final filteredShops = shops.where((shop) => 
                      shop.subcategoryId == subcategory.id).toList();
                    if (filteredShops.isNotEmpty) {
                      Navigator.pushNamed(
                        context,
                        '/shop-details',
                        arguments: filteredShops[0],
                      );
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (subcategory.subcategoryImage != null)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              '$baseUrl${subcategory.subcategoryImage}',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.category, size: 30),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          subcategory.subcategoryName ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Categories',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return GestureDetector( 
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SubcategoryScreen(category: category),
                                  ),
                                );
                              },
                              child: Card(
                                surfaceTintColor: Theme.of(context).dialogBackgroundColor,
                                clipBehavior: Clip.none,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Text(
                                      category['category_name'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSubcategories(),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Services',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShopsGridView()
                                  ),
                                );
                              },
                              child: Text(
                                'See All>',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 160,
                          child: ListView.builder(
                            shrinkWrap: true,
                            clipBehavior: Clip.none,
                            scrollDirection: Axis.horizontal,
                            itemCount: shops.length,
                            itemBuilder: (context, index) {
                              final shop = shops[index];
                              return Container(
                                width: MediaQuery.of(context).size.width / 3 - 16,
                                margin: const EdgeInsets.only(right: 12),
                                
                                decoration: BoxDecoration(
                                  //PRIMARY COLOR
                                  color: Theme.of(context).dialogBackgroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShopDetailsScreen(
                                          shopId: shop.id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (shop.shopImage != null)
                                        ClipRRect(
                                          borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(12),
                                          ),
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Image.network(
                                              '$baseUrl${shop.shopImage}',
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  Container(
                                                    color: Colors.grey[100],
                                                    child: const Icon(
                                                      Icons.store,
                                                      size: 40,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            shop.shopName ?? '',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
} 