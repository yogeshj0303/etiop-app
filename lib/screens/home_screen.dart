import 'dart:async';
import 'dart:convert';
import 'package:etiop_application/screens/login_screen.dart';
import 'package:etiop_application/screens/main_screen.dart';
import 'package:etiop_application/screens/service_category_screen.dart';
import 'package:etiop_application/screens/shop_details_screen.dart';
import 'package:etiop_application/screens/sub_category_screen.dart';
import 'package:etiop_application/screens/support_screen.dart';
import 'package:etiop_application/services/api_services.dart';
import 'package:etiop_application/widgets/shops_card.dart';
import 'package:etiop_application/widgets/shops_grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

    final url = 'https://etiop.acttconnect.com/api/shop-search/$query';
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // Now using 'data' instead of 'results'
        setState(() {
          _searchResults = data['data'] != null && data['data'].isNotEmpty
              ? data['data']
              : []; // Check for null or empty data
          _isSearching = true;
        });
      } else {
        setState(() {
          _searchResults = [];
          _errorMessage =
              'Error: Unable to fetch results (${response.statusCode})';
        });
      }
    } catch (e) {
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
    // TODO: implement initState
    super.initState();
    _fetchCategories();
    _loadUserData();
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

  @override
  Widget build(BuildContext context) {
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
              else
                const Expanded(
                  child: Center(
                    child: Text(
                      'No results found',
                      style: TextStyle(
                        fontSize: 16,
                      ),
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
                        _buildSponsoredSection(),
                        SizedBox(height: 8),
                        // const CityButtonsWidget(),
                        // _buildOffersAndSales(context),
                        _buildCategoriesSection(),
                        SizedBox(height: 8),
                        _buildPremiumBusinesses(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      drawer: _buildDrawer(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
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
          _buildSearchField(),
        ],
      ),
    );
  }

  // Build drawer with navigation options
  Drawer _buildDrawer() {
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
                _buildDrawerItem(CupertinoIcons.home, 'Home', 0),
                _buildDrawerItem(CupertinoIcons.cube_box, 'Category', 1),
                _buildDrawerItem(CupertinoIcons.person, 'Profile', 2),
                _buildDrawerItem(
                    Icons.privacy_tip_outlined, 'Privacy Policy', 3),
                _buildDrawerItem(Icons.add_to_drive, 'Terms & Conditions', 4),
                _buildDrawerItem(Icons.logout, 'Logout', 5),
              ],
            ),
          ),
          // Bottom Text
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Unit of Act T Connect (P) Ltd.",
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
              builder: (context) => ComingSoonScreen(),
            ),
          );
        } else if (index == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ComingSoonScreen(),
            ),
          );
        } else if (index == 5) {
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

  Widget _buildSearchField() {
    return Expanded(
      child: Row(
        children: [
          if (_searchController.text.isNotEmpty)
            _buildAppBarIcon(Icons.arrow_back, onTap: () {
              _searchController.clear();
              _search('');
            }),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(
                  Icons.search,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _search('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
              onChanged: _onSearchChanged, // Use debounce here
            ),
          ),
        ],
      ),
    );
  }

  String baseUrl =
      'https://etiop.acttconnect.com/'; // Replace with your actual base URL

  Widget _buildSearchResultsGrid() {
    return GridView.builder(
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

        // Construct the image URL
        final imageUrl = result['shop_image'] != null
            ? '$baseUrl${result['shop_image']}'
            : 'https://via.placeholder.com/150';

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                10), // More rounded corners for a soft look
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
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image,
                      size: 50,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    result['shop_name'] ?? 'Unknown',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

  Widget _buildOffersAndSales(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCategoryButton(context, 'Offers'),
          _buildCategoryButton(context, 'Sales'),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(BuildContext context, String text) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ComingSoonScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ));
  }

  Widget _buildSponsoredSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Text(
            'Sponsored',
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

  Widget _buildPremiumBusinesses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Text(
                'Highlights of Banda',
                style: TextStyle(
                  fontSize: 16,
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
                            title: 'Highlights of Banda',
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'See all',
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

  Widget _buildCategoriesSection() {
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
              const Text(
                'Categories',
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
                      'See all',
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
