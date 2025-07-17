import 'package:flutter/material.dart';
import 'package:etiop_application/widgets/related_shops.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import '../modals/shop_details.dart';
import '../services/api_services.dart';
import '../widgets/contact_form.dart';

class ShopDetailsScreen extends StatefulWidget {
  final int shopId;

  const ShopDetailsScreen({super.key, required this.shopId});

  @override
  State<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen> {
  late Future<ShopDetails?> _shopDetailsFuture;

  @override
  void initState() {
    super.initState();
    _shopDetailsFuture = ApiService().fetchShopDetails(widget.shopId);
  }

  Widget _buildCatalogImages(ShopDetails shopDetails) {
    List<String?> catalogImages = [
      shopDetails.catlog_0,
      shopDetails.catlog_1,
      shopDetails.catlog_2,
      shopDetails.catlog_3,
      shopDetails.catlog_4,
    ].where((image) => image != null).toList();

    if (catalogImages.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catalog Images:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: catalogImages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://etiop.in/${catalogImages[index]}',
                    width: 160,
                    height: 160,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Shop Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<ShopDetails?>(
          future: _shopDetailsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text('Failed to load shop details.'));
            } else {
              final shopDetails = snapshot.data!;
              _debugPrintCatalogData(shopDetails);

              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (shopDetails.shopImage != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              color: Colors.white,
                              child: Image.network(
                                'https://etiop.in/${shopDetails.shopImage}',
                                width: double.infinity,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    color: Colors.white,
                                    child: const Icon(Icons.error),
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    height: 200,
                                    color: Colors.white,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              Text(
                                shopDetails.categoryName?.toLowerCase() ==
                                        'government'
                                    ? shopDetails.officeName ??
                                        'No Office Name Available'
                                    : shopDetails.shopName ??
                                        'No Name Available',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),
                              HtmlWidget(shopDetails.description),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${shopDetails.area}${shopDetails.city != null && shopDetails.city!.isNotEmpty ? ', ${shopDetails.city}' : ''}, ${shopDetails.state}, ${shopDetails.country}, ${shopDetails.zipcode}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SingleChildScrollView(
                                clipBehavior: Clip.none,
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        final phone = shopDetails.mobile_no;
                                        print(phone);
                                        if (phone != null && phone.isNotEmpty) {
                                          Uri uri = Uri.parse('tel:$phone');
                                          launch(uri.toString());
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'No phone number available'),
                                            ),
                                          );
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.call,
                                      ),
                                      label: const Text(
                                        'Contact',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        final email = shopDetails.email;
                                        if (email != null && email.isNotEmpty) {
                                          Uri uri = Uri.parse('mailto:$email');
                                          launch(uri.toString());
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('No email available'),
                                            ),
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.mail),
                                      label: const Text('Email',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        final website =
                                            shopDetails.website_link;
                                        print(website);
                                        if (website != null &&
                                            website.isNotEmpty) {
                                          Uri uri = Uri.parse(website);
                                          launch(uri.toString());
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('No website available'),
                                            ),
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.link),
                                      label: const Text('Website',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        final url = shopDetails.google_map_link;
                                        if (url != null && url.isNotEmpty) {
                                          Uri uri = Uri.parse(url);
                                          launch(uri.toString());
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'No direction available'),
                                            ),
                                          );
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.map,
                                      ),
                                      label: const Text('Direction',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Category:",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              const SizedBox(height: 8),
                              // Add category and subcategory information
                              Row(
                                children: [
                                  const Icon(Icons.category, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${shopDetails.categoryName ?? 'N/A'}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Sub Category:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.category, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(
                                    '${shopDetails.subCategoryName ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  )),
                                ],
                              ),
                              const SizedBox(height: 4),
                              //if shopDetails.categoryName?.toLowerCase() == 'government' then show department name and officer name
                              if (shopDetails.categoryName?.toLowerCase() ==
                                  'government') ...[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Department:',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        shopDetails.departmentName ??
                                            'No Department Name Available',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Officer:',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        shopDetails.officerName ??
                                            'No Officer Name Available',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              // const Text(
                              //   'Services:',
                              //   style: TextStyle(
                              //       fontSize: 18, fontWeight: FontWeight.bold),
                              // ),
                              // if (shopDetails.services != null)
                              //   HtmlWidget(shopDetails.services!,
                              //       textStyle: const TextStyle(fontSize: 16))
                              // else
                              //   const Text('No services available'),
                              const SizedBox(height: 8),
                              // Catalog Images Section
                              if ([
                                shopDetails.catlog_0,
                                shopDetails.catlog_1,
                                shopDetails.catlog_2,
                                shopDetails.catlog_3,
                                shopDetails.catlog_4
                              ].any((img) => img != null)) ...[
                                const Text(
                                  'Catalogue Images:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 160,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      if (shopDetails.catlog_0 != null)
                                        _buildCatalogImage(
                                            shopDetails.catlog_0!),
                                      if (shopDetails.catlog_1 != null)
                                        _buildCatalogImage(
                                            shopDetails.catlog_1!),
                                      if (shopDetails.catlog_2 != null)
                                        _buildCatalogImage(
                                            shopDetails.catlog_2!),
                                      if (shopDetails.catlog_3 != null)
                                        _buildCatalogImage(
                                            shopDetails.catlog_3!),
                                      if (shopDetails.catlog_4 != null)
                                        _buildCatalogImage(
                                            shopDetails.catlog_4!),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                              const Text(
                                'Related Services:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: 220,
                                child: RelatedShopsScreen(
                                  categoryId: shopDetails.categoryId,
                                ),
                              ),
                              const SizedBox(
                                  height: 100), // Add extra padding here
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 12,
                    right: 12,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.send),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16.0)),
                          ),
                          builder: (context) => DraggableScrollableSheet(
                            initialChildSize:
                                0.9, // Takes up 90% of screen height
                            minChildSize: 0.5, // Minimum 50% of screen height
                            maxChildSize: 0.95, // Maximum 95% of screen height
                            expand: false,
                            builder: (context, scrollController) => Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: ContactForm(shopId: widget.shopId),
                              ),
                            ),
                          ),
                        );
                      },
                      label: const Text('Send Requirement',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCatalogImage(String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 160,
          height: 160,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.network(
            'https://etiop.in/$imagePath',
            fit: BoxFit.scaleDown,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 160,
                height: 160,
                color: Colors.grey[300],
                child: const Icon(Icons.error),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 160,
                height: 160,
                color: Colors.grey[200],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Add this debug method to check catalog data
  void _debugPrintCatalogData(ShopDetails shopDetails) {
    print('Catalog Images Data:');
    print('catlog_0: ${shopDetails.catlog_0}');
    print('catlog_1: ${shopDetails.catlog_1}');
    print('catlog_2: ${shopDetails.catlog_2}');
    print('catlog_3: ${shopDetails.catlog_3}');
    print('catlog_4: ${shopDetails.catlog_4}');
  }
}
