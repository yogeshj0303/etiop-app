import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BannerService {
  static const String apiUrl = "https://etiop.acttconnect.com/api/banners-get";

  // Fetch banners from API and store them in SharedPreferences
  Future<void> fetchAndStoreBanners() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Parse the JSON response
      List<dynamic> data = json.decode(response.body);

      // Extract image paths and descriptions
      List<String> imagePaths = [];
      List<String> descriptions = [];
      for (var item in data) {
        imagePaths.add(item["banner_doc"]);
        descriptions.add(item["banner_name"]);
      }

      // Save data to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList('imagePaths', imagePaths);
      prefs.setStringList('descriptions', descriptions);
    } else {
      throw Exception("Failed to load banners");
    }
  }

  // Load banners from SharedPreferences
  Future<Map<String, List<String>>> loadBanners() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? imagePaths = prefs.getStringList('imagePaths');
    List<String>? descriptions = prefs.getStringList('descriptions');

    if (imagePaths != null && descriptions != null) {
      return {
        'imagePaths': imagePaths,
        'descriptions': descriptions,
      };
    } else {
      throw Exception("No banners found in SharedPreferences");
    }
  }
}
