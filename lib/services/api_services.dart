import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../modals/banner_model.dart';
import '../modals/cities_model.dart';
import '../modals/related_shops.dart';
import '../modals/shop_by_city_model.dart';
import '../modals/shop_details.dart';
import '../modals/shop_model.dart';
import '../modals/sub_category.dart';
import '../modals/sub_category_related_shops_model.dart';

class ApiService {
  static const String baseUrl = 'https://etiop.acttconnect.com/api/';

  static Future<Map<String, dynamic>> registerUser(
      String name,
      String lastName,
      String email,
      String mobile,
      String gender,
      String address,
      String password,
      String state,
      String district) async {
    final url = Uri.parse(baseUrl + 'user-register');
    
    var request = http.MultipartRequest('POST', url)
      ..fields['name'] = name
      ..fields['last_name'] = lastName
      ..fields['email'] = email
      ..fields['mobile_number'] = mobile
      ..fields['gender'] = gender
      ..fields['address'] = address
      ..fields['password'] = password
      ..fields['state'] = state
      ..fields['district'] = district;

    request.headers['Accept'] = 'application/json';

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        return {'success': false, 'message': jsonDecode(response.body)['message']};
      } else {
        throw Exception('Failed to register user: ${response.statusCode}');
      }
    } catch (e) {
      return {'success': false, 'message': 'Error registering user: $e'};
    }
  }

  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    final url = Uri.parse(baseUrl + 'user-login');
    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    try {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        return {'success': false, 'message': jsonDecode(response.body)['message']};
      }
      return {'success': false, 'message': 'An error occurred'};
    } catch (e) {
      return {'success': false, 'message': 'Error logging in user: $e'};
    }
  }

  Future<List<BannerModel>> fetchBanners() async {
    final url =
        Uri.parse("${baseUrl}banners-get"); // Replace with the correct endpoint
    try {
      final response = await http.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          final List<dynamic> data = jsonData['data'];
          return data.map((json) {
            final banner = BannerModel.fromJson(json);

            // Debug: Print the full image URL
            print("Image URL: ${baseUrl}${banner.bannerDoc}");

            return banner;
          }).toList();
        } else {
          throw Exception('Failed to fetch banners: ${jsonData['message']}');
        }
      } else {
        throw Exception(
            'Failed to load banners, Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching banners: $e');
    }
  }

  Future<List<Shop>> fetchShops() async {
    final response = await http.get(Uri.parse('${baseUrl}all-shops'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return data.map((shopJson) => Shop.fromJson(shopJson)).toList();
    } else {
      throw Exception('Failed to load shops');
    }
  }

  Future<ShopDetails?> fetchShopDetails(int shopId) async {
    final url = Uri.parse('${baseUrl}shopdetails/$shopId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        if (jsonResponse['status'] == true) {
          return ShopDetails.fromJson(jsonResponse['data']);
        }
      }
    } catch (e) {
      print('Error fetching shop details: $e');
    }
    return null;
  }

  Future<List<RelatedShop>> fetchRelatedShops(int categoryId) async {
    final url = Uri.parse('${baseUrl}related-shops/$categoryId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse);

        if (jsonResponse['data'] is List) {
          // Ensure that 'data' is a List<dynamic>
          final List<dynamic> data = jsonResponse['data'];
          print(data);

          // Now safely map the data to RelatedShop objects
          return data.map((e) => RelatedShop.fromJson(e)).toList();
        } else {
          print('Failed to load related shops: ${jsonResponse['message']}');
        }
      }
      throw Exception('Failed to load related shops');
    } catch (e) {
      print('Error fetching related shops: $e');
      throw Exception('Failed to load related shops');
    }
  }

  Future<List<String>> fetchCities() async {
    const String url = '${baseUrl}city-get';
    final response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        final cityResponse = CityResponse.fromJson(data);
        return cityResponse.cities;
      } else {
        throw Exception('Failed to load cities');
      }
    } catch (e) {
      print('Error fetching cities: $e');
      throw Exception('Failed to load cities: $e');
    }
  }

  // Function to fetch shops by city
  Future<ShopByCity> fetchShopsByCity(String cityName) async {
    // Define the API endpoint to get shops by city
    final url =
        Uri.parse('https://etiop.acttconnect.com/api/shop-by-city/$cityName');

    try {
      // Send the GET request to the API
      final response = await http.get(url);

      // Check if the response status is OK (200)
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response body to a JSON object
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        // Return a ShopByCity object using the parsed data
        return ShopByCity.fromJson(data);
      } else {
        // If the response status code is not OK, throw an error
        throw Exception('Failed to load shops');
      }
    } catch (e) {
      print('Error fetching shops: $e');
      // If there's an error, throw an exception
      throw Exception('Failed to load shops: $e');
    }
  }

  Future<Map<String, dynamic>> createShop(
    Map<String, dynamic> data,
    File? shopImage,
    List<File> catalogueImages,
  ) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://etiop.acttconnect.com/api/shop-add'),
      );

      // Add text fields
      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add shop image if exists
      if (shopImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'shop_image',
          shopImage.path,
        ));
      }

    // Add catalogue images
    for (var i = 0; i < catalogueImages.length; i++) {
      request.files.add(await http.MultipartFile.fromPath(
        'catlog_$i',
        catalogueImages[i].path,
      ));
    }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to create shop: ${response.body}');
      }
    } catch (e) {
      print('Error in createShop: $e');
      throw Exception('Failed to create shop: $e');
    }
  }

  Future<List<dynamic>> fetchCategories() async {
    final url = '${baseUrl}all-categories';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']; // Return the list of categories
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<List<Subcategory>> fetchSubcategoriesByCategoryId(
      int categoryId) async {
    final url = Uri.parse('${baseUrl}subcategories-by-cat/$categoryId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Subcategory.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load subcategories');
      }
    } catch (e) {
      throw Exception('Error fetching subcategories: $e');
    }
  }

  Future<List<SubCategoryRelatedShopModel>> fetchSubCategoryRelatedShops(
      int subCategoryId) async {
    final response = await http.get(
      Uri.parse(
          'https://etiop.acttconnect.com/api/related-Sub-cat-shops/$subCategoryId'),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Parse the JSON response
      final responseData = json.decode(response.body);

      if (responseData['success']) {
        final List<dynamic> shopsJson = responseData['data'];
        return shopsJson
            .map((json) => SubCategoryRelatedShopModel.fromJson(json))
            .toList();
      } else {
        throw responseData['message'] ?? 'Failed to load shops';
      }
    } else if (response.statusCode == 404) {
      final responseData = json.decode(response.body);
      throw responseData['message'];
    } else {
      throw Exception('Failed to fetch data from API');
    }
  }
    static const String _baseUrl = 'https://etiop.acttconnect.com/api';

  Future<List<dynamic>> fetchNotifications(int userId) async {
    final response = await http.post(Uri.parse('$_baseUrl/get-notification?user_id=$userId'));

    print(response.body);
    print("the user id is $userId");
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print(data);
      if (data['status'] == 'success') {
        return data['data'];
      } else {
        throw Exception('Failed to load notifications');
      }
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  static Future<String?> _getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('id');
  }

  // Function to delete the shop
  static Future<Map<String, dynamic>> deleteShop(int shopId) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}shop-data-delete/$shopId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Shop deleted successfully.');
        return json.decode(response.body);
      } else {
        print('Failed to delete shop: ${response.statusCode}');
        return {
          'status': 'error',
          'message': 'Failed to delete shop: ${response.statusCode}',
        };
      }
    } catch (e) {
      // Handle errors such as network issues
      return {
        'status': 'error',
        'message': 'Error: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> submitEnquiry({
    required String name,
    required String phoneNo,
    required String email,
    required String message,
    required String userId,
  }) async {
    try {
      // Construct the query parameters
      final Uri uri = Uri.parse("${baseUrl}support-query").replace(
        queryParameters: {
          'name': name,
          'phone_no': phoneNo,
          'email': email,
          'message': message,
          'users_id': userId,
        },
      );

      // Make the GET request with query parameters
      final response = await http.post(uri, headers: {
        'Content-Type': 'application/json',
      });

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Successful response
        print('Enquiry submitted successfully.');
        return json.decode(response.body);
      } else {
        // Handle error response
        print('Error: ${response.body}');
        throw Exception('Failed to submit enquiry. Please try again later.');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw Exception('An error occurred: $e');
    }
  }

  // Future<List<AllSubcategory>> fetchSubcategories() async {
  //   final response = await http
  //       .get(Uri.parse('https://etiop.acttconnect.com/api/all-subcategory'));

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body)['data'];
  //     return List<AllSubcategory>.from(
  //         data.map((item) => AllSubcategory.fromJson(item)));
  //   } else {
  //     throw Exception('Failed to load subcategories');
  //   }
  // }

  Future<Map<String, dynamic>?> updateShop(
    String shopId,
    Map<String, dynamic> shopData,
    File? shopImage,
    List<File> catalogueImages,
  ) async {
    try {
      // Add user_id if available
      final String? userId = await ApiService._getUserId();
      if (userId != null) {
        shopData['user_id'] = userId;
      }

      // Create URL with query parameters
      final uri = Uri.parse('${baseUrl}shop-data-update/$shopId')
          .replace(queryParameters: shopData.map((key, value) => 
              MapEntry(key, value.toString())));

      // Create request with final URL
      var request = http.MultipartRequest('POST', uri);

      // Add shop image and catalog images
      if (shopImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'shop_image',
          shopImage.path,
        ));
      }

      for (var i = 0; i < catalogueImages.length; i++) {
        request.files.add(await http.MultipartFile.fromPath(
          'catlog_$i',
          catalogueImages[i].path,
        ));
      }

      request.headers['Accept'] = 'application/json';
      
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        print('Error response: ${response.body}');
        throw Exception('Failed to update shop: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating shop: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> resetPassword(String email) async {
    final url = Uri.parse('https://etiop.acttconnect.com/api/forgot-password-api?email=$email');
    
    try {
      final response = await http.post(url);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to reset password');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }
}
