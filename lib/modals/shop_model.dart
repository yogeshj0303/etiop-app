class Shop {
  final int id;
  final int? shopOwnerId;
  final int? ownerId;
  final int? categoryId;
  final String? shopName;
  final String? shopNo;
  final String? area;
  final String? city;
  final String? state;
  final String? district;
  final String? country;
  final String? zipcode;
  final String? shopImage;
  final String? shopStatus;
  final String? description;
  // final String? services;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ShopOwner? shopOwner;
  final Category? category; // Ensure this is nullable as it might be null
  final List<dynamic>? requirements;  // Add this field for requirements
  final String? websiteLink;
  final String? googleMapLink;
  final int? subcategoryId;
  final List<String>? catalogImageUrls;
  final String? catlog_0;
  final String? catlog_1;
  final String? catlog_2;
  final String? catlog_3;
  final String? catlog_4;
  final String? email;
  final String? mobileNo;
  final String? govtName;
  final String? officeName;
  final String? officerName;
  final String? ownerName;
  final String? ownerEmail;
  final String? categoryName;
  final String? departmentName;

  Shop({
    required this.id,
    required this.shopOwnerId,
    required this.ownerId,
    required this.categoryId,
    required this.shopName,
    required this.departmentName,
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
    // required this.services,
    required this.createdAt,
    required this.updatedAt,
    required this.shopOwner,
    this.category,
    this.requirements,  // Add this in the constructor
    this.websiteLink,
    this.googleMapLink,
    this.subcategoryId,
    this.catalogImageUrls,
    this.catlog_0,
    this.catlog_1,
    this.catlog_2,
    this.catlog_3,
    this.catlog_4,
    this.email,
    this.mobileNo,
    this.govtName,
    this.officeName,
    this.officerName,
    this.ownerName,
    this.ownerEmail,
    this.categoryName,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    // Extract catalog images from catlog_0 through catlog_4
    List<String> catalogImages = [];
    for (int i = 0; i < 5; i++) {
      String? image = json['catlog_$i'];
      if (image != null && image.isNotEmpty) {
        catalogImages.add(image);
      }
    }

    // Properly handle requirements
    List<dynamic>? requirementsList;
    if (json['requirements'] != null) {
      requirementsList = List<dynamic>.from(json['requirements']);
    }

    return Shop(
      id: json['id'],
      shopOwnerId: json['shop_owner_id'],
      ownerId: json['owner_id'],
      categoryId: json['category_id'],
      shopName: json['shop_name'],
      shopNo: json['shop_no'],
      departmentName: json['department_name'],
      area: json['area'],
      city: json['city'],
      state: json['state'],
      district: json['district'],
      country: json['country'],
      zipcode: json['zipcode'],
      shopImage: json['shop_image'],
      shopStatus: json['shop_status'],
      description: json['description'],
      // services: json['services'],
      createdAt: DateTime.tryParse(json['created_at'].toString()),
      updatedAt: DateTime.tryParse(json['updated_at'].toString()),
      shopOwner: json['shop_owner']!=null?ShopOwner.fromJson(json['shop_owner']):null,
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : null, // Ensure category is parsed only if it exists
      requirements: requirementsList,
      websiteLink: json['website_link'],
      googleMapLink: json['google_map_link'],
      subcategoryId: json['subcategory_id'],
      catalogImageUrls: catalogImages.isNotEmpty ? catalogImages : null,
      catlog_0: json['catlog_0'],
      catlog_1: json['catlog_1'],
      catlog_2: json['catlog_2'],
      catlog_3: json['catlog_3'],
      catlog_4: json['catlog_4'],
      email: json['email'],
      mobileNo: json['mobile_no'],
      govtName: json['govt_name'],
      officeName: json['office_name'],
      officerName: json['officer_name'],
      ownerName: json['owner_name'],
      ownerEmail: json['owner_email'],
      categoryName: json['category_name'],
    );
  }

  /// Create a toMap function with all the fields same as postman request.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shop_owner_id': shopOwnerId,
      'owner_id': ownerId,
      'category_id': categoryId,
      'shop_name': shopName,
      'shop_no': shopNo,
      'area': area,
      'city': city,
      'state': state,
      'district': district,
      'country': country,
      'zipcode': zipcode,
      'shop_image': shopImage,
      'department_name': departmentName,
      'shop_status': shopStatus,
      'description': description,
      // 'services': services,
    };
  }

  String? get fullImageUrl {
    if (shopImage == null) return null;
    return 'https://etiop.in/$shopImage';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shop_owner_id': shopOwnerId,
      'owner_id': ownerId,
      'category_id': categoryId,
      'shop_name': shopName,
      'shop_no': shopNo,
      'area': area,
      'city': city,
      'state': state,
      'district': district,
      'country': country,
      'zipcode': zipcode,
      'shop_image': shopImage,
      'shop_status': shopStatus,
      'department_name': departmentName,
      'description': description,
      // 'services': services,
      'requirements': requirements,
      'website_link': websiteLink,
      'google_map_link': googleMapLink,
      'subcategory_id': subcategoryId,
    };
  }
}

class ShopOwner {
  final int id;
  final String isAdmin;
  final String name;
  final String lastName;
  final String mobileNumber;
  final String gender;
  final DateTime? dateOfJoining;
  final DateTime? dob;
  final String? aadhar;
  final String passwordWord;
  final int? ownerId;
  final int? roleId;
  final String? email;
  final String? avatar;
  final int status;
  final String address;

  ShopOwner({
    required this.id,
    required this.isAdmin,
    required this.name,
    required this.lastName,
    required this.mobileNumber,
    required this.gender,
    required this.dateOfJoining,
    required this.dob,
    required this.aadhar,
    required this.passwordWord,
    required this.ownerId,
    required this.roleId,
    this.email,
    required this.avatar,
    required this.status,
    required this.address,
  });

  factory ShopOwner.fromJson(Map<String, dynamic> json) {
    return ShopOwner(
      id: json['id'],
      isAdmin: json['is_admin'],
      name: json['name'],
      lastName: json['last_name'],
      mobileNumber: json['mobile_number'],
      gender: json['gender'],
      dateOfJoining: DateTime.tryParse(json['date_of_joining'] ?? ""),
      dob: DateTime.tryParse(json['dob'] ?? ""),
      aadhar: json['addhar'],
      passwordWord: json['password_word'],
      ownerId: json['owner_id'],
      roleId: json['role_id'],
      email: json['email'],
      avatar: json['avatar'],
      status: json['status'],
      address: json['address'],
    );
  }
}

class Category {
  final int id;
  final String categoryName;
  final int ownerId;

  Category({
    required this.id,
    required this.categoryName,
    required this.ownerId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      categoryName: json['category_name'],
      ownerId: json['owner_id'],
    );
  }
}
