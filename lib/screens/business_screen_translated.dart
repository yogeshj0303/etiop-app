import 'package:flutter/material.dart';
import '../generated/app_localizations.dart';
import '../services/api_services.dart';
import '../modals/shop_model.dart';
import '../widgets/translated_text.dart';
import 'shop_details_screen.dart';
import 'main_screen.dart';

class BusinessScreenTranslated extends StatefulWidget {
  const BusinessScreenTranslated({super.key});

  @override
  State<BusinessScreenTranslated> createState() => _BusinessScreenTranslatedState();
}

class _BusinessScreenTranslatedState extends State<BusinessScreenTranslated> {
  late Future<List<Shop>> _businessesFuture;
  final TextEditingController _searchController = TextEditingController();
  List<Shop> _filteredBusinesses = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _businessesFuture = ApiService().fetchShops();
  }

  void _filterBusinesses(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _filteredBusinesses.clear();
      });
      return;
    }

    setState(() {
      _isSearching = true;
      // This will be populated when we have the actual businesses
      // For now, we'll show the search state
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: Colors.black,
          ),
          onPressed: () => Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => MainScreen())
          ),
        ),
        elevation: 1,
        centerTitle: true,
        title: Text(
          l10n.business,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Show search functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: _filterBusinesses,
            ),
          ),
          
          // Business List
          Expanded(
            child: FutureBuilder<List<Shop>>(
              future: _businessesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.failedToLoadShops,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _businessesFuture = ApiService().fetchShops();
                            });
                          },
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.business_center_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noShopsAvailable,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  final businesses = snapshot.data!;
                  
                  if (_isSearching && _filteredBusinesses.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noResultsFound,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final displayBusinesses = _isSearching ? _filteredBusinesses : businesses;
                  
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: displayBusinesses.length,
                    itemBuilder: (context, index) {
                      final business = displayBusinesses[index];
                      return _buildBusinessCardTranslated(business, l10n);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessCardTranslated(Shop business, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShopDetailsScreen(shopId: business.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                color: Colors.grey[200],
              ),
              child: (business.shopImage ?? "").isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        "https://etiop.in/${business.shopImage}",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Icon(
                            Icons.business,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.business,
                        size: 64,
                        color: Colors.grey,
                      ),
                    ),
            ),
            
            // Business Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Business Name - NOW TRANSLATED AUTOMATICALLY
                  TranslatedText(
                    text: business.shopName ?? l10n.shopName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Category - NOW TRANSLATED AUTOMATICALLY
                  if (business.categoryName != null && business.categoryName!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TranslatedText(
                        text: business.categoryName!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 12),
                  
                  // Business Description - NOW TRANSLATED AUTOMATICALLY
                  if (business.description != null && business.description!.isNotEmpty)
                    TranslatedText(
                      text: business.description!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  
                  const SizedBox(height: 12),
                  
                  // Location Information - NOW TRANSLATED AUTOMATICALLY
                  if (business.area != null || business.city != null || business.state != null)
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: TranslatedText(
                            text: [
                              if (business.area != null && business.area!.isNotEmpty) business.area,
                              if (business.city != null && business.city!.isNotEmpty) business.city,
                              if (business.state != null && business.state!.isNotEmpty) business.state,
                            ].join(', '),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
