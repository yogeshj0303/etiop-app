class ShopDetails {
  final String shopName;
  final String? shopImage; // Nullable
  final String description;
  final String services;
  final String area;
  final String city;
  final String state;
  final String country;
  final String zipcode;
  final String email;
  final String mobile_no;
  final String website_link;
  final String google_map_link;
  final int categoryId; // New field for category_id
  final List<String> otherImages;
  final String? catlog_0;
  final String? catlog_1;
  final String? catlog_2;
  final String? catlog_3;
  final String? catlog_4;

  ShopDetails({
    required this.shopName,
    this.shopImage, // Nullable
    required this.description,
    required this.services,
    required this.area,
    required this.city,
    required this.state,
    required this.country,
    required this.zipcode,
    required this.categoryId, // Required field for category_id
    required this.otherImages,
    required this.email,
    required this.mobile_no,
    required this.website_link,
    required this.google_map_link,
    this.catlog_0,
    this.catlog_1,
    this.catlog_2,
    this.catlog_3,
    this.catlog_4,
  });

  factory ShopDetails.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
    // Check if 'shop_others' is a list and process the image URLs
    if (json['shop_others'] != null) {
      images = (json['shop_others'] as List)
          .map((image) => image['other_image'] as String) // Extract 'other_image' string
          .toList();
    }
    return ShopDetails(
      shopName: json['shop']['shop_name'] ?? 'Unknown Shop',
      shopImage: json['shop']['shop_image'], // Nullable field
      description: json['shop']['description'] ?? 'No description available',
      services: json['shop']['services'] ?? 'Not listed',
      area: json['shop']['area'] ?? 'Not specified',
      city: json['shop']['city'] ?? 'Unknown City',
      state: json['shop']['state'] ?? 'Unknown State',
      country: json['shop']['country'] ?? 'Unknown Country',
      zipcode: json['shop']['zipcode'] ?? '000000',
      categoryId: json['shop']['category_id'] ?? 0, // Default to 0 if not available
      otherImages: images,
      email: json['shop']['email'] ?? 'Not available',
      mobile_no: json['shop']['mobile_no'] ?? 'Not available',
      website_link: json['shop']['website_link'] ?? 'Not available',
      google_map_link: json['shop']['google_map_link'] ?? 'Not available',
      catlog_0: json['shop']['catlog_0'],
      catlog_1: json['shop']['catlog_1'],
      catlog_2: json['shop']['catlog_2'],
      catlog_3: json['shop']['catlog_3'],
      catlog_4: json['shop']['catlog_4'],
    );
  }
}
