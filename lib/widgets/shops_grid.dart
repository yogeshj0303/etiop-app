import 'package:etiop_application/screens/shop_details_screen.dart';
import 'package:etiop_application/services/api_services.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../generated/app_localizations.dart';

import '../modals/shop_model.dart';
import '../screens/main_screen.dart';
import 'translated_text.dart';

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
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;
  Timer? _debounce; // Timer for debouncing

  @override
  void initState() {
    super.initState();
  }

  // Method to fetch search results from the API
  Future<void> _search(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
        _isSearching = false;
        _errorMessage = null;
      });
      return;
    }

    // Check if the query looks like a city name
    bool isCitySearch = query.length > 2 && !query.contains(' ');
    print('Search query: "$query"');
    print('Is city search: $isCitySearch');

    if (isCitySearch) {
      // Use city-specific search API
      print('Using city search API');
      await _searchByCity(query);
    } else {
      // Use general shop search API
      print('Using general search API');
      await _searchGeneral(query);
    }
  }

  // Method to search by city
  Future<void> _searchByCity(String cityName) async {
    final url = 'https://etiop.in/api/shop-by-city/$cityName';
    print('Searching by city: $cityName');
    print('URL: $url');

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await http.get(Uri.parse(url));
      print('City search response status: ${response.statusCode}');
      print('City search response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          print('City search successful, found ${data['data'].length} shops');
          setState(() {
            _searchResults = data['data'];
            _isSearching = true;
          });
        } else {
          print('City search failed: ${data['message']}');
          setState(() {
            _searchResults = [];
            _errorMessage = data['message'] ?? 'No shops found in this city';
          });
        }
      } else {
        print('City search HTTP error: ${response.statusCode}');
        setState(() {
          _searchResults = [];
          _errorMessage =
              'Error: Unable to fetch results (${response.statusCode})';
        });
      }
    } catch (e) {
      print('City search exception: $e');
      setState(() {
        _searchResults = [];
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to search generally
  Future<void> _searchGeneral(String query) async {
    final url = 'https://etiop.in/api/shop-search/$query';
    print('General search: $query');
    print('URL: $url');

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await http.get(Uri.parse(url));
      print('General search response status: ${response.statusCode}');
      print('General search response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print(
            'General search successful, found ${data['data']?.length ?? 0} shops');
        setState(() {
          _searchResults = data['data'] != null && data['data'].isNotEmpty
              ? data['data']
              : [];
          _isSearching = true;
        });
      } else {
        print('General search HTTP error: ${response.statusCode}');
        setState(() {
          _searchResults = [];
          _errorMessage =
              'Error: Unable to fetch results (${response.statusCode})';
        });
      }
    } catch (e) {
      print('General search exception: $e');
      setState(() {
        _searchResults = [];
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to clear search and results
  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults.clear();
      _isSearching = false;
      _errorMessage = null;
    });
  }

  // Method to handle search input with debouncing
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      _search(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
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
        title: TranslatedText(
          text: widget.title ?? AppLocalizations.of(context)!.business,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  if (_searchController.text.isNotEmpty)
                    _buildAppBarIcon(Icons.arrow_back, onTap: _clearSearch),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: _searchController.text.isEmpty
                            ? '${AppLocalizations.of(context)!.searchHint}'
                            : AppLocalizations.of(context)!.searchHint,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: _clearSearch,
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      onChanged: _onSearchChanged,
                      onSubmitted: (query) {
                        if (query.isNotEmpty) {
                          _search(query);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Content based on search state
            if (_isSearching) ...[
              if (_isLoading)
                const Expanded(
                    child: Center(child: CircularProgressIndicator()))
              else if (_searchResults.isNotEmpty)
                Expanded(child: _buildSearchResultsGrid())
              else if (_errorMessage != null)
                Expanded(
                  child: Center(
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
                          _errorMessage!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try searching for a different city or shop name',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No results found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try searching for a different city or shop name',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
            ] else ...[
              // Initial state - show search prompt
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Search for shops',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter a city name or shop name to find shops',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultsGrid() {
    // Check if this is a city search (query doesn't contain spaces and is longer than 2 chars)
    final isCitySearch = _searchController.text.length > 2 &&
        !_searchController.text.contains(' ');

    return Column(
      children: [
        // Search type indicator
        if (_searchResults.isNotEmpty)
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: Colors.blue[50],
            child: Row(
              children: [
                Icon(
                  isCitySearch ? Icons.location_city : Icons.search,
                  color: Colors.blue[700],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  isCitySearch
                      ? 'Showing shops in ${_searchController.text}'
                      : 'Search results for "${_searchController.text}"',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_searchResults.length} ${_searchResults.length == 1 ? 'shop' : 'shops'}',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        // Search results grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of columns in the grid
                crossAxisSpacing: 8.0, // Horizontal spacing between items
                mainAxisSpacing: 8.0, // Vertical spacing between items
                childAspectRatio: 0.7, // Adjusted for better visibility
              ),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final result = _searchResults[index];

                // Construct the image URL - handle both shop_image and shopImage fields
                String? imageUrl;
                if (result['shop_image'] != null &&
                    result['shop_image'].toString().isNotEmpty) {
                  imageUrl = 'https://etiop.in/${result['shop_image']}';
                } else if (result['shopImage'] != null &&
                    result['shopImage'].toString().isNotEmpty) {
                  imageUrl = 'https://etiop.in/${result['shopImage']}';
                } else {
                  imageUrl = 'https://via.placeholder.com/150';
                }

                // Get shop name from different possible fields
                final shopName =
                    result['shop_name'] ?? result['shopName'] ?? 'Unknown';

                return GestureDetector(
                  onTap: () {
                    // Navigate to the shop details screen when tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ShopDetailsScreen(shopId: result['id']),
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
                            child: imageUrl != 'https://via.placeholder.com/150'
                                ? Container(
                                    width: double.infinity,
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.fill,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Container(
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.shop,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Container(
                                          color: Colors.grey[200],
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Icon(Icons.shop, size: 50),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 4.0),
                              child: TranslatedText(
                                text: shopName,
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
          ),
        ),
      ],
    );
  }

  Widget _buildAppBarIcon(IconData icon, {VoidCallback? onTap}) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onTap,
    );
  }
}
