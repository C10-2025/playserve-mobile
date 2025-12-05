class AvailabilityResponse {
  final bool available;
  final String message;

  AvailabilityResponse({required this.available, required this.message});

  factory AvailabilityResponse.fromJson(Map<String, dynamic> json) {
    return AvailabilityResponse(
      available: json["available"] ?? false,
      message: json["message"] ?? "",
    );
  }
}
