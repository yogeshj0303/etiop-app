import 'package:flutter/material.dart';
import 'package:etiop_application/widgets/shop_list.dart';
import '../services/api_services.dart';

class CityButtonsWidget extends StatefulWidget {
  const CityButtonsWidget({Key? key}) : super(key: key);

  @override
  _CityButtonsWidgetState createState() => _CityButtonsWidgetState();
}

class _CityButtonsWidgetState extends State<CityButtonsWidget> {
  late Future<List<String>> _cities;

  @override
  void initState() {
    super.initState();
    _cities = ApiService().fetchCities();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _cities,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No cities available.'));
        }

        final cities = snapshot.data!;
        return SizedBox(
          height: 90, // Fixed height for the horizontal scrolling view
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cities.length,
            itemBuilder: (context, index) {
              final city = cities[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () {
                    print('$city button pressed');
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ShopListScreen(
                      cityName: city,
                    )));
                  },
                  child: Column(
                    children: [
                      Material(
                        elevation: 1, // Set the elevation value
                        shape: CircleBorder(), // Circle shape to match the container's shape
                        color: Theme.of(context).badgeTheme.backgroundColor,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              city.substring(0, 1), // Initial letter as placeholder
                              style:  TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        city,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
