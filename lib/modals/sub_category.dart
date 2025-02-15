class Subcategory {
  final int id;
  final int categoryId;
  final String? subcategoryName;
  final String? subcategoryImage;
  final int ownerId;

  Subcategory({
    required this.id,
    required this.categoryId,
    this.subcategoryName,
    this.subcategoryImage,
    required this.ownerId,
  });

  // Factory method to parse JSON
  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'],
      categoryId: json['category_id'],
      subcategoryName: json['subcategory_name'],
      subcategoryImage: json['subcategory_image'],
      ownerId: json['owner_id'],
    );
  }
}
