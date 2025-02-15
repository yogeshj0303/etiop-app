class CityResponse {
  final bool success;
  final List<String> cities;
  final String message;

  CityResponse({required this.success, required this.cities, required this.message});

  factory CityResponse.fromJson(Map<String, dynamic> json) {
    return CityResponse(
      success: json['success'],
      cities: List<String>.from(json['data']),
      message: json['message'],
    );
  }
}
