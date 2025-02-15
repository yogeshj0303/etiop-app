class RelatedShop {
  final int id;
  final String shopName;
  final String shopNo;
  final String area;
  final String city;
  final String state;
  final String? district;
  final String country;
  final String zipcode;
  final String shopImage;
  final String shopStatus;
  final String description;
  final String services;
  // final List<String> days;
  // final Map<String, Map<String, String>> time;

  RelatedShop({
    required this.id,
    required this.shopName,
    required this.shopNo,
    required this.area,
    required this.city,
    required this.state,
    this.district,
    required this.country,
    required this.zipcode,
    required this.shopImage,
    required this.shopStatus,
    required this.description,
    required this.services,
    // required this.days,
    // required this.time,
  });

  factory RelatedShop.fromJson(Map<String, dynamic> json) {
    return RelatedShop(
      id: json['id'] ?? 0,
      shopName: json['shop_name'] ?? '',
      shopNo: json['shop_no'] ?? '',
      area: json['area'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      district: json['district'],
      country: json['country'] ?? '',
      zipcode: json['zipcode'] ?? '',
      shopImage: json['shop_image'] ?? '', // Handle null values for shopImage
      shopStatus: json['shop_status'] ?? '',
      description: json['description'] ?? '', // Handle null description
      services: json['services'] ?? '', // Handle null services
      // days: json['days'] != null
      //     ? List<String>.from(json['days'])
      //     : [], // Default to an empty list if days is null
      // time: json['time'] != null
      //     ? Map<String, Map<String, String>>.from(json['time'])
      //     : {}, // Default to an empty map if time is null
    );
  }
}
