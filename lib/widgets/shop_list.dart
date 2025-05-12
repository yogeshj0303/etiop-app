import 'package:flutter/material.dart';
import '../modals/shop_by_city_model.dart'; // Import ShopByCity model
import '../screens/shop_details_screen.dart';
import '../services/api_services.dart'; // Import the API services for fetching data

class ShopListScreen extends StatefulWidget {
  final String cityName; // Field to accept city name for the ShopListScreen

  // Constructor to accept city name from the previous screen
  const ShopListScreen({Key? key, required this.cityName}) : super(key: key);

  @override
  _ShopListScreenState createState() => _ShopListScreenState();
}

class _ShopListScreenState extends State<ShopListScreen> {
  final ApiService apiService = ApiService();
  List<Shops> _shops = []; // List to hold shops for the current city
  List<Shops> _filteredShops = []; // Filtered list for search functionality
  bool _isLoading = true; // Flag to show loading indicator
  late String _cityName; // City name passed from the previous screen

  @override
  void initState() {
    super.initState();
    _cityName =
        widget.cityName; // Set the city name passed through the constructor
    _fetchShops(); // Fetch the shops data when the screen loads
  }

  // Function to fetch shops by city using the ApiService
  void _fetchShops() async {
    try {
      // Fetch shops by city from the API service
      ShopByCity shopByCity = await apiService.fetchShopsByCity(_cityName);
      setState(() {
        _shops = shopByCity.data.isNotEmpty ? shopByCity.data : [];
        // Assign the list of shops to the _shops variable
        _filteredShops =
            _shops; // Initially, the filtered shops are the same as all shops
        _isLoading = false; // Stop the loading indicator
      });
    } catch (e) {
      print('Error fetching shops: $e'); // Log the error message
      setState(() {
        _isLoading = false; // Stop loading in case of an error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to load shops: $e')), // Show error message
      );
    }
  }

  // Function to filter shops based on the search query
  void _filterShops(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredShops = _shops; // If the query is empty, show all shops
      });
    } else {
      setState(() {
        _filteredShops = _shops
            .where((shop) => shop.shopName
                .toLowerCase()
                .contains(query.toLowerCase())) // Filter by shop name
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context); // Go back when the back button is pressed
          },
        ),
        title: Text(
          'Shops in $_cityName',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ), // Display city name in the app bar
      ),
      body: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while fetching data
          : _filteredShops.isEmpty
              ? Center(
                  child: Text(
                    'No shops available',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // Add horizontal padding
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    clipBehavior: Clip.none,
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search bar for filtering shops by name
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          // Space between search and content
                          child: TextField(
                            decoration: InputDecoration(
                              hintText:
                                  'Search by shop name...', // Placeholder text
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0), // Adjust vertical padding
                            ),
                            onChanged:
                                _filterShops, // Trigger filter function on text change
                          ),
                        ),
                        // Display the total number of shops
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          // Space between count and grid
                          child: Text(
                            '${_shops.length} Businesses Found',
                            // Display the total number of shops
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // GridView to display filtered shops
                        GridView.builder(
                          shrinkWrap: true,
                          // Prevent overflow by limiting grid size
                          physics: NeverScrollableScrollPhysics(),
                          // Disable grid scroll, controlled by the parent scroll view
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.0,
                            mainAxisSpacing: 12.0,
                            childAspectRatio:
                                0.75, // Adjust the aspect ratio of the items
                          ),
                          itemCount: _filteredShops.length,
                          // Number of filtered shops
                          itemBuilder: (context, index) {
                            final shop = _filteredShops[
                                index]; // Get shop for current index
                            return Card(
                              // White background for the card
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // More rounded corners for a soft look
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  // Implement action on shop tap if needed
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
                                    // Shop Image with Rounded Top Corners
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                      child: shop.shopImage != null
                                          ? Image.network(
                                              'https://etiop.in/${shop.shopImage}',
                                              width: double.infinity,
                                              // Full width of the card
                                              height: 100,
                                              // Adjusted height for the image
                                              fit: BoxFit
                                                  .cover, // Maintain aspect ratio
                                            )
                                          : Container(
                                              width: double.infinity,
                                              height:
                                                  100, // Set height for fallback image

                                              child: Icon(
                                                Icons.shop,
                                                size: 80,
                                              ),
                                            ),
                                    ),
                                    // Shop Name
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        shop.shopName ?? 'Unknown Shop',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    // Shop Description
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 0),
                                      child: Text(
                                        shop.description ??
                                            'No description available',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
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
                  ),
                ),
    );
  }
}
