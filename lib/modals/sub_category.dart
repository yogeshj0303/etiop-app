class Subcategory {
  final int id;
  final int categoryId;
  final String subcategoryName;
  final String subcategoryImage;
  final String? imageUrl;
  final String? services;

  Subcategory({
    required this.id,
    required this.categoryId,
    required this.subcategoryName,
    required this.subcategoryImage,
    this.imageUrl,
    this.services,
  });

  // Factory method to parse JSON
  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'],
      categoryId: json['category_id'],
      subcategoryName: json['subcategory_name'],
      subcategoryImage: json['subcategory_image'],
      imageUrl: json['image_url'],
      services: json['services'],
    );
  }
}
