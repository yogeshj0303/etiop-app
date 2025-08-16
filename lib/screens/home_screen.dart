import 'dart:async';
import 'dart:convert';
import 'package:etiop_application/screens/login_screen.dart';
import 'package:etiop_application/screens/main_screen.dart';
import 'package:etiop_application/screens/privacy_policy_screen.dart';
import 'package:etiop_application/screens/service_category_screen.dart';
import 'package:etiop_application/screens/shop_details_screen.dart';
import 'package:etiop_application/screens/sub_category_screen.dart';
import 'package:etiop_application/screens/subscription_screen.dart';
import 'package:etiop_application/screens/support_screen.dart';
import 'package:etiop_application/screens/terms_conditions_screen.dart';
import 'package:etiop_application/services/api_services.dart';
import 'package:etiop_application/widgets/shop_form.dart';
import 'package:etiop_application/widgets/shops_card.dart';
import 'package:etiop_application/widgets/shops_grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/all_categories.dart';
import '../widgets/comming_soon.dart';
import '../widgets/sponsored_card.dart';
import 'user_profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  List<dynamic> _categories = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String? _errorMessage;
  Timer? _debounce; // Timer for debouncing
  String firstName = "User";
  String lastName = "Name";
  String email = "";
  String mobileNumber = "";
  String _selectedDistrict = '';

  String baseUrl =
      'https://etiop.in/'; // Fixed base URL for images

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

    // Check if the query looks like a city name (you can enhance this logic)
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
          _errorMessage = 'Error: Unable to fetch results (${response.statusCode})';
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
        print('General search successful, found ${data['data']?.length ?? 0} shops');
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
          _errorMessage = 'Error: Unable to fetch results (${response.statusCode})';
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

  // Fetch categories on screen load
  Future<void> _fetchCategories() async {
    try {
      final categories = await ApiService().fetchCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching categories: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _loadUserData();
    _loadSelectedDistrict();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('name') ?? "User";
      lastName = prefs.getString('last_name') ?? "Name";
      email = prefs.getString('email') ?? "example@example.com";
      mobileNumber = prefs.getString('mobile_number') ?? "Not available";
    });
  }

  Future<void> _loadSelectedDistrict() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedDistrict = prefs.getString('district') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
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
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSponsoredSection(l10n),
                        SizedBox(height: 8),
                        // const CityButtonsWidget(),
                        // _buildOffersAndSales(context, l10n),
                        _buildCategoriesSection(l10n),
                        SizedBox(height: 8),
                        _buildPremiumBusinesses(l10n),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      drawer: _buildDrawer(l10n),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            right: 18.0,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SupportScreen(),
                ),
              );
            },
            child: Image.asset(
              'assets/images/customer-service.png',
              width: 25,
              height: 25,
            ),
          ),
        ),
      ],
      automaticallyImplyLeading: false,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(
            Icons.menu,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSearchField(l10n),
        ],
      ),
    );
  }

  // Build drawer with navigation options
  Drawer _buildDrawer(AppLocalizations l10n) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // Push content to top and bottom
        children: <Widget>[
          // Drawer Header
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(4292815168)),
            accountName: Text(
              '$firstName $lastName',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(email, style: const TextStyle(fontSize: 16)),
            currentAccountPicture: CircleAvatar(
              //give primary color
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                firstName[0].toUpperCase(),
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          // Drawer items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                _buildDrawerItem(CupertinoIcons.home, l10n.home, 0),
                _buildDrawerItem(CupertinoIcons.cube_box, l10n.category, 1),
                _buildDrawerItem(CupertinoIcons.person, l10n.profile, 2),
                //supscription screen
                _buildDrawerItem(Icons.subscriptions, l10n.subscription, 3),
                _buildDrawerItem(
                    Icons.privacy_tip_outlined, l10n.privacyPolicy, 4),
                _buildDrawerItem(Icons.add_to_drive, l10n.termsConditions, 5),
                _buildDrawerItem(Icons.logout, l10n.logout, 6),
              ],
            ),
          ),
          // Bottom Text
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "ETIOP\n A unit of Etiop Private Limited",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          )
        ],
      ),
    );
  }

  // Build individual drawer item
  ListTile _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, size: 22, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(),
            ),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceCategoryScreen(),
            ),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfileScreen(),
            ),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddShop(),
            ),
          );
        } else if (index == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PrivacyPolicyScreen(),
            ),
          );
        } else if (index == 5) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TermsConditionsScreen(),
            ),
          );
        } else if (index == 6) {
          //use shared preference to clear the user data
          SharedPreferences.getInstance().then((prefs) {
            prefs.clear();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          });
        }
      },
    );
  }

  Widget _buildSearchField(AppLocalizations l10n) {
    return Expanded(
      child: Row(
        children: [
          if (_searchController.text.isNotEmpty)
            _buildAppBarIcon(Icons.arrow_back, onTap: _clearSearch),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: _searchController.text.isEmpty 
                    ? '${l10n.searchHint}' 
                    : l10n.searchHint,
                prefixIcon: const Icon(
                  Icons.search,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                        ),
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
    );
  }

  Widget _buildSearchResultsGrid() {
    // Check if this is a city search (query doesn't contain spaces and is longer than 2 chars)
    final isCitySearch = _searchController.text.length > 2 && !_searchController.text.contains(' ');
    
    return Column(
      children: [
        // Search type indicator
        if (_searchResults.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final result = _searchResults[index];

              // Construct the image URL - handle both shop_image and shopImage fields
              String? imageUrl;
              if (result['shop_image'] != null && result['shop_image'].toString().isNotEmpty) {
                imageUrl = '$baseUrl${result['shop_image']}';
                print('Using shop_image: ${result['shop_image']} -> $imageUrl');
              } else if (result['shopImage'] != null && result['shopImage'].toString().isNotEmpty) {
                imageUrl = '$baseUrl${result['shopImage']}';
                print('Using shopImage: ${result['shopImage']} -> $imageUrl');
              } else {
                imageUrl = 'https://via.placeholder.com/150';
                print('No image found, using placeholder');
              }
              print('Final image URL: $imageUrl');

              // Get shop name from different possible fields
              final shopName = result['shop_name'] ?? result['shopName'] ?? 'Unknown';
              final city = result['city'] ?? 'Unknown City';
              final area = result['area'] ?? 'Unknown Area';

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShopDetailsScreen(
                          shopId: result['id'],
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.store,
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
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shopName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$area, $city',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
        ),
      ],
    );
  }

  Widget _buildAppBarIcon(IconData icon, {VoidCallback? onTap}) {
    return IconButton(
      icon: Icon(
        icon,
      ),
      onPressed: onTap,
    );
  }



  Widget _buildSponsoredSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Text(
            l10n.sponsored,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SponsoredCarousel(),
      ],
    );
  }

  Widget _buildPremiumBusinesses(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
                              Text(
                  l10n.highlightsOf(_selectedDistrict),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const Spacer(),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                                                  builder: (context) => ShopsGridView(
                          title: l10n.highlightsOf(_selectedDistrict),
                        ),
                        ),
                      );
                    },
                    child: Text(
                      l10n.seeAll,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 200, child: ShopsCarousel()),
      ],
    );
  }

  Widget _buildCategoriesSection(AppLocalizations l10n) {
    if (_categories.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Get the screen width to calculate the width of each card
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = (screenWidth - 32) /
        3; // Subtract padding and divide by 3 to fit 3 cards

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.categories,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllCategories(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      l10n.seeAll,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Using ListView to display categories in a horizontal scrolling list
          Container(
            height: 140, // Adjust the height to make the cards taller if needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              // Make the list scroll horizontally
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return GestureDetector(
                  onTap: () {
                    // When a category is tapped, navigate to SubcategoryScreen
                    int categoryId = category['id']; // Category ID
                    String categoryName =
                        category['category_name']; // Category Name
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubcategoryScreen(
                          categoryId: categoryId,
                          categoryName: categoryName,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: cardWidth,
                    // Set width to calculated value
                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    // Space between cards
                    child: Card(
                      elevation: 1,
                      // Slightly higher elevation for a more prominent look
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // More rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        // Increased padding
                        child: Center(
                          child: Text(
                            category['category_name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14, // Font size for the category name
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
