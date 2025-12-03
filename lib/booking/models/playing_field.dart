import 'dart:convert';

List<PlayingFieldItem> playingFieldItemFromJson(String str) =>
    List<PlayingFieldItem>.from(
        json.decode(str).map((x) => PlayingFieldItem.fromJson(x)));

String playingFieldItemToJson(List<PlayingFieldItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlayingFieldItem {
  final String id;
  final String name;
  final String address;
  final City city;
  final double? latitude;
  final double? longitude;
  final int numberOfCourts;
  final bool hasLights;
  final bool hasBackboard;
  final CourtSurface courtSurface;
  final double pricePerHour;
  final String ownerName;
  final String ownerContact;
  final String ownerBankAccount;
  final String? openingTime;
  final String? closingTime;
  final String description;
  final List<dynamic> amenities;
  final String? courtImage;
  final String? imageUrl;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final PriceRangeCategory priceRangeCategory;

  PlayingFieldItem({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.numberOfCourts,
    required this.hasLights,
    required this.hasBackboard,
    required this.courtSurface,
    required this.pricePerHour,
    required this.ownerName,
    required this.ownerContact,
    required this.ownerBankAccount,
    required this.openingTime,
    required this.closingTime,
    required this.description,
    required this.amenities,
    required this.courtImage,
    required this.imageUrl,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.priceRangeCategory,
  });

  factory PlayingFieldItem.fromJson(Map<String, dynamic> json) =>
      PlayingFieldItem(
        id: json["id"].toString(),
        name: json["name"],
        address: json["address"],
        city: cityValues.map[json["city"]] ?? City.jakarta,
        latitude:
            json["latitude"] == null ? null : (json["latitude"] as num).toDouble(),
        longitude: json["longitude"] == null
            ? null
            : (json["longitude"] as num).toDouble(),
        numberOfCourts: json["number_of_courts"] ?? 1,
        hasLights: json["has_lights"] ?? false,
        hasBackboard: json["has_backboard"] ?? false,
        courtSurface:
            courtSurfaceValues.map[json["court_surface"]] ?? CourtSurface.hard,
        pricePerHour: (json["price_per_hour"] as num).toDouble(),
        ownerName: json["owner_name"] ?? "",
        ownerContact: json["owner_contact"] ?? "",
        ownerBankAccount: json["owner_bank_account"] ?? "",
        openingTime: json["opening_time"],
        closingTime: json["closing_time"],
        description: json["description"] ?? "",
        amenities: json["amenities"] != null
            ? List<dynamic>.from(json["amenities"].map((x) => x))
            : <dynamic>[],
        courtImage: json["court_image"],
        imageUrl: json["image_url"],
        createdBy: json["created_by"],
        createdAt:
            json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
        updatedAt:
            json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null,
        isActive: json["is_active"] ?? true,
        priceRangeCategory: priceRangeCategoryValues
                .map[json["price_range_category"]] ??
            PriceRangeCategory.mid,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "city": cityValues.reverse[city],
        "latitude": latitude,
        "longitude": longitude,
        "number_of_courts": numberOfCourts,
        "has_lights": hasLights,
        "has_backboard": hasBackboard,
        "court_surface": courtSurfaceValues.reverse[courtSurface],
        "price_per_hour": pricePerHour,
        "owner_name": ownerName,
        "owner_contact": ownerContact,
        "owner_bank_account": ownerBankAccount,
        "opening_time": openingTime,
        "closing_time": closingTime,
        "description": description,
        "amenities": List<dynamic>.from(amenities.map((x) => x)),
        "court_image": courtImage,
        "image_url": imageUrl,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "is_active": isActive,
        "price_range_category": priceRangeCategoryValues.reverse[priceRangeCategory],
      };
}

enum City { jakarta, bogor, depok, tangerang, bekasi }

final cityValues = EnumValues({
  "Jakarta": City.jakarta,
  "Bogor": City.bogor,
  "Depok": City.depok,
  "Tangerang": City.tangerang,
  "Bekasi": City.bekasi,
});

enum CourtSurface { hard, clay, grass, synthetic }

final courtSurfaceValues = EnumValues({
  "HARD": CourtSurface.hard,
  "CLAY": CourtSurface.clay,
  "GRASS": CourtSurface.grass,
  "SYNTHETIC": CourtSurface.synthetic,
});

enum PriceRangeCategory { budget, mid, premium }

final priceRangeCategoryValues = EnumValues({
  "budget": PriceRangeCategory.budget,
  "mid": PriceRangeCategory.mid,
  "premium": PriceRangeCategory.premium,
});

class EnumValues<T> {
  EnumValues(this.map);
  Map<String, T> map;
  Map<T, String>? reverseMap;

  Map<T, String> get reverse =>
      reverseMap ??= map.map((k, v) => MapEntry(v, k));
}
