class SubCategoryRelatedShopModel {
  final int id;
  final String shopName;
  final String shopNo;
  final String area;
  final String city;
  final String state;
  final String district;
  final String country;
  final String zipcode;
  final String? shopImage; // Made nullable
  final String description;
  final String services;
  final String time;
  final String email;
  final String websiteLink;
  final String googleMapLink;
  final String mobileNo;

  SubCategoryRelatedShopModel({
    required this.id,
    required this.shopName,
    required this.shopNo,
    required this.area,
    required this.city,
    required this.state,
    required this.district,
    required this.country,
    required this.zipcode,
    this.shopImage, // Made nullable
    required this.description,
    required this.services,
    required this.time,
    required this.email,
    required this.websiteLink,
    required this.googleMapLink,
    required this.mobileNo,
  });

  factory SubCategoryRelatedShopModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryRelatedShopModel(
      id: json['id'],
      shopName: json['shop_name'] ?? '',
      shopNo: json['shop_no'] ?? '',
      area: json['area'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      country: json['country'] ?? '',
      zipcode: json['zipcode'] ?? '',
      shopImage: json['shop_image'], // Can be null
      description: json['description'] ?? '',
      services: json['services'] ?? '',
      time: json['time'] ?? '',
      email: json['email'] ?? '',
      websiteLink: json['website_link'] ?? '',
      googleMapLink: json['google_map_link'] ?? '',
      mobileNo: json['mobile_no'] ?? '',
    );
  }
}
