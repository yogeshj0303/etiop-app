import 'package:etiop_application/modals/shop_model.dart';

class CreateShop {
  final bool success;
  final String message;
  final Shop shop;

  CreateShop({required this.success, required this.message, required this.shop});

  factory CreateShop.fromJson(Map<String, dynamic> json) {
    return CreateShop(
      success: json['success'],
      message: json['message'],
      shop: Shop.fromJson(json['shop']),
    );
  }
}

