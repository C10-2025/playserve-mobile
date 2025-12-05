class PlayingField {
  final int id;
  final String name;
  final String address;
  final String city;
  final String courtSurface;
  final double pricePerHour;
  final String? openingTime;
  final String? closingTime;
  final String? imageUrl;
  final List<dynamic>? amenities;
  final String? ownerName;
  final String? ownerContact;
  final String? ownerBankAccount;
  final bool isActive;

  PlayingField({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.courtSurface,
    required this.pricePerHour,
    required this.openingTime,
    required this.closingTime,
    required this.imageUrl,
    required this.amenities,
    required this.ownerName,
    required this.ownerContact,
    required this.ownerBankAccount,
    required this.isActive,
  });

  factory PlayingField.fromJson(Map<String, dynamic> json) {
    return PlayingField(
      id: int.tryParse(json["id"].toString()) ?? 0,
      name: json["name"] ?? "",
      address: json["address"] ?? "",
      city: json["city"] ?? "",
      courtSurface: json["court_surface"] ?? json["surface"] ?? "",
      pricePerHour: (json["price_per_hour"] as num).toDouble(),
      openingTime: json["opening_time"],
      closingTime: json["closing_time"],
      imageUrl: json["image_url"] ?? json["court_image"],
      amenities: json["amenities"] is List ? List<dynamic>.from(json["amenities"]) : null,
      ownerName: json["owner_name"],
      ownerContact: json["owner_contact"] ?? json["owner_phone"],
      ownerBankAccount: json["owner_bank_account"] ?? json["owner_bank_name"],
      isActive: json["is_active"] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "city": city,
        "court_surface": courtSurface,
        "price_per_hour": pricePerHour,
        "opening_time": openingTime,
        "closing_time": closingTime,
        "description": "",
        "amenities": amenities ?? [],
        "owner_name": ownerName ?? "",
        "owner_contact": ownerContact ?? "",
        "owner_bank_account": ownerBankAccount ?? "",
      };
}
