class ShopDetails {
  final int id;
  final int shopOwnerId;
  final int ownerId;
  final String shopName;
  final String? shopImage;
  final String description;
  final String? services;
  final String area;
  final String city;
  final String state;
  final String? district;
  final String country;
  final String zipcode;
  final String email;
  final String? mobile_no;
  final String? website_link;
  final String? google_map_link;
  final int categoryId;
  final int? subcategoryId;
  final List<String> otherImages;
  final String? catlog_0;
  final String? catlog_1;
  final String? catlog_2;
  final String? catlog_3;
  final String? catlog_4;
  final String? categoryName;
  final String? subCategoryName;
  final String? shopStatus;
  final String? shopNo;
  final String? govtName;
  final String? officeName;
  final String? officerName;
  final String? ownerName;
  final String? ownerEmail;

  ShopDetails({
    required this.id,
    required this.shopOwnerId,
    required this.ownerId,
    required this.shopName,
    this.shopImage,
    required this.description,
    this.services,
    required this.area,
    required this.city,
    required this.state,
    this.district,
    required this.country,
    required this.zipcode,
    required this.categoryId,
    this.subcategoryId,
    required this.otherImages,
    required this.email,
    this.mobile_no,
    this.website_link,
    this.google_map_link,
    this.catlog_0,
    this.catlog_1,
    this.catlog_2,
    this.catlog_3,
    this.catlog_4,
    this.categoryName,
    this.subCategoryName,
    this.shopStatus,
    this.shopNo,
    this.govtName,
    this.officeName,
    this.officerName,
    this.ownerName,
    this.ownerEmail,
  });

  factory ShopDetails.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
    if (json['shop_others'] != null) {
      images = (json['shop_others'] as List)
          .map((image) => image['other_image'] as String)
          .toList();
    }

    final shop = json['shop'] as Map<String, dynamic>;
    
    return ShopDetails(
      id: shop['id'] ?? 0,
      shopOwnerId: shop['shop_owner_id'] ?? 0,
      ownerId: shop['owner_id'] ?? 0,
      shopName: shop['shop_name'] ?? 'Unknown Shop',
      shopImage: shop['shop_image'],
      description: shop['description'] ?? 'No description available',
      services: shop['services'],
      area: shop['area'] ?? 'Not specified',
      city: shop['city'] ?? 'Unknown City',
      state: shop['state'] ?? 'Unknown State',
      district: shop['district'],
      country: shop['country'] ?? 'Unknown Country',
      zipcode: shop['zipcode'] ?? '000000',
      categoryId: shop['category_id'] ?? 0,
      subcategoryId: shop['subcategory_id'],
      otherImages: images,
      email: shop['email'] ?? 'Not available',
      mobile_no: shop['mobile_no'],
      website_link: shop['website_link'],
      google_map_link: shop['google_map_link'],
      catlog_0: shop['catlog_0'],
      catlog_1: shop['catlog_1'],
      catlog_2: shop['catlog_2'],
      catlog_3: shop['catlog_3'],
      catlog_4: shop['catlog_4'],
      categoryName: shop['category_name'],
      subCategoryName: shop['subcategory_name'],
      shopStatus: shop['shop_status'],
      shopNo: shop['shop_no'],
      govtName: shop['govt_name'],
      officeName: shop['office_name'],
      officerName: shop['officer_name'],
      ownerName: shop['owner_name'],
      ownerEmail: shop['owner_email'],
    );
  }
}
