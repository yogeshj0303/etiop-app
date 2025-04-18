class ShopByCity {
  final bool success;
  final List<Shops> data;
  final String message;

  ShopByCity({required this.success, required this.data, required this.message});

  factory ShopByCity.fromJson(Map<String, dynamic> json) {
    return ShopByCity(
      success: json['success'],
      data: (json['data'] as List).map((i) => Shops.fromJson(i)).toList(),
      message: json['message'],
    );
  }
}

class Shops {
  final int id;
  final int shopOwnerId;
  final int ownerId;
  final int categoryId;
  final String shopName;
  final String shopNo;
  final String area;
  final String city;
  final String state;
  final String? district;
  final String country;
  final String zipcode;
  final String? shopImage;
  final String shopStatus;
  final String description;
  final String services;
  // final List<String> days;
  // final Map<String, ShopTime> time;
  final String createdAt;
  final String updatedAt;

  Shops({
    required this.id,
    required this.shopOwnerId,
    required this.ownerId,
    required this.categoryId,
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
    required this.createdAt,
    required this.updatedAt,
  });

  factory Shops.fromJson(Map<String, dynamic> json) {
    // var timeMap = Map<String, ShopTime>.fromIterable(
    //   json['time'].keys,
    //   key: (key) => key as String,
    //   value: (key) => ShopTime.fromJson(json['time'][key]),
    // );

    return Shops(
      id: json['id'],
      shopOwnerId: json['shop_owner_id'],
      ownerId: json['owner_id'],
      categoryId: json['category_id'],
      shopName: json['shop_name'],
      shopNo: json['shop_no'],
      area: json['area'],
      city: json['city'],
      state: json['state'],
      district: json['district'],
      country: json['country'],
      zipcode: json['zipcode'],
      shopImage: json['shop_image'],
      shopStatus: json['shop_status'],
      description: json['description'],
      services: json['services'],
      // days: List<String>.from(json['days']),
      // time: timeMap,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class ShopTime {
  final String? openTime;
  final String? closeTime;

  ShopTime({this.openTime, this.closeTime});

  factory ShopTime.fromJson(Map<String, dynamic> json) {
    return ShopTime(
      openTime: json['open_time'],
      closeTime: json['close_time'],
    );
  }
}
