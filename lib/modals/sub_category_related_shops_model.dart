class SubCategoryRelatedShopModel {
  final int id;
  final int shopOwnerId;
  final int ownerId;
  final int categoryId;
  final String shopName;
  final String? shopNo;
  final String area;
  final String? city;
  final String state;
  final String district;
  final String country;
  final String zipcode;
  final String? shopImage;
  final String shopStatus;
  final String description;
  final String? services;
  final String createdAt;
  final String updatedAt;
  final String email;
  final String? websiteLink;
  final String? googleMapLink;
  final String? mobileNo;
  final int subcategoryId;
  final String departmentName;
  final String? officeName;
  final String officerName;
  final String? catlog0;
  final String? catlog1;
  final String? catlog2;
  final String? catlog3;
  final String? catlog4;

  SubCategoryRelatedShopModel({
    required this.id,
    required this.shopOwnerId,
    required this.ownerId,
    required this.categoryId,
    required this.shopName,
    this.shopNo,
    required this.area,
    this.city,
    required this.state,
    required this.district,
    required this.country,
    required this.zipcode,
    this.shopImage,
    required this.shopStatus,
    required this.description,
    this.services,
    required this.createdAt,
    required this.updatedAt,
    required this.email,
    this.websiteLink,
    this.googleMapLink,
    this.mobileNo,
    required this.subcategoryId,
    required this.departmentName,
    this.officeName,
    required this.officerName,
    this.catlog0,
    this.catlog1,
    this.catlog2,
    this.catlog3,
    this.catlog4,
  });

  factory SubCategoryRelatedShopModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryRelatedShopModel(
      id: json['id'],
      shopOwnerId: json['shop_owner_id'],
      ownerId: json['owner_id'],
      categoryId: json['category_id'],
      shopName: json['shop_name'] ?? '',
      shopNo: json['shop_no'],
      area: json['area'] ?? '',
      city: json['city'],
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      country: json['country'] ?? '',
      zipcode: json['zipcode'] ?? '',
      shopImage: json['shop_image'],
      shopStatus: json['shop_status'] ?? '',
      description: json['description'] ?? '',
      services: json['services'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      email: json['email'] ?? '',
      websiteLink: json['website_link'],
      googleMapLink: json['google_map_link'],
      mobileNo: json['mobile_no'],
      subcategoryId: json['subcategory_id'],
      departmentName: json['department_name'] ?? '',
      officeName: json['office_name'],
      officerName: json['officer_name'] ?? '',
      catlog0: json['catlog_0'],
      catlog1: json['catlog_1'],
      catlog2: json['catlog_2'],
      catlog3: json['catlog_3'],
      catlog4: json['catlog_4'],
    );
  }
}
