class BannerModel {
  final int id;
  final String bannerName;
  final String bannerDoc;
  final int ownerId;
  final String createdAt;
  final String updatedAt;

  BannerModel({
    required this.id,
    required this.bannerName,
    required this.bannerDoc,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      bannerName: json['banner_name'],
      bannerDoc: json['banner_doc'],
      ownerId: json['owner_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
