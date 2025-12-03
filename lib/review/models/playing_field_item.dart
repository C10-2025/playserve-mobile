import 'dart:convert';
// To parse this JSON data, do
//
//     final playingField = playingFieldFromJson(jsonString);

// Corresponds to the PlayingField model at Django app
List<PlayingFieldItem> playingFieldItemFromJson(String str) => List<PlayingFieldItem>.from(json.decode(str).map((x) => PlayingFieldItem.fromJson(x)));
String playingFieldItemToJson(List<PlayingFieldItem> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlayingFieldItem {
    String id;
    String name;
    String address;
    City city;
    double latitude;
    double longitude;
    int numberOfCourts;
    bool hasLights;
    bool hasBackboard;
    CourtSurface courtSurface;
    int pricePerHour;
    String ownerName;
    String ownerContact;
    String ownerBankAccount;
    String openingTime;
    String closingTime;
    String description;
    List<dynamic> amenities;
    dynamic courtImage;
    String imageUrl;
    dynamic createdBy;
    DateTime createdAt;
    DateTime updatedAt;
    bool isActive;
    PriceRangeCategory priceRangeCategory;

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

    factory PlayingFieldItem.fromJson(Map<String, dynamic> json) => PlayingFieldItem(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        city: cityValues.map[json["city"]]!,
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        numberOfCourts: json["number_of_courts"],
        hasLights: json["has_lights"],
        hasBackboard: json["has_backboard"],
        courtSurface: courtSurfaceValues.map[json["court_surface"]]!,
        pricePerHour: json["price_per_hour"],
        ownerName: json["owner_name"],
        ownerContact: json["owner_contact"],
        ownerBankAccount: json["owner_bank_account"],
        openingTime: json["opening_time"],
        closingTime: json["closing_time"],
        description: json["description"],
        amenities: List<dynamic>.from(json["amenities"].map((x) => x)),
        courtImage: json["court_image"],
        imageUrl: json["image_url"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isActive: json["is_active"],
        priceRangeCategory: priceRangeCategoryValues.map[json["price_range_category"]]!,
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
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "is_active": isActive,
        "price_range_category": priceRangeCategoryValues.reverse[priceRangeCategory],
    };
}

enum City {
    BEKASI,
    BOGOR,
    DEPOK,
    JAKARTA,
    TANGERANG
}

final cityValues = EnumValues({
    "Bekasi": City.BEKASI,
    "Bogor": City.BOGOR,
    "Depok": City.DEPOK,
    "Jakarta": City.JAKARTA,
    "Tangerang": City.TANGERANG
});

enum CourtSurface {
    HARD
}

final courtSurfaceValues = EnumValues({
    "HARD": CourtSurface.HARD
});

enum PriceRangeCategory {
    BUDGET,
    MID,
    PREMIUM
}

final priceRangeCategoryValues = EnumValues({
    "budget": PriceRangeCategory.BUDGET,
    "mid": PriceRangeCategory.MID,
    "premium": PriceRangeCategory.PREMIUM
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}