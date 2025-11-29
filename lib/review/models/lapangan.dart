import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:playserve_mobile/review/models/review_preview.dart';

// Placeholder to the playing court model at the web
// TODO: deprecate this
class Lapangan {
  final String? imageUrl;
  final String name;
  final String address;
  final int pricePerHour;
  final double avgRating;
  final int reviewCount;
  final List<ReviewPreview> latestReviews;

  final VoidCallback onAddReview;
  final VoidCallback onViewComments;

  Lapangan({
    required this.imageUrl,
    required this.name,
    required this.address,
    required this.pricePerHour,
    required this.avgRating,
    required this.reviewCount,
    required this.latestReviews,
    required this.onAddReview,
    required this.onViewComments,
  });
}

// To parse this JSON data, do
//
//     final playingField = playingFieldFromJson(jsonString);
// TODO: integrate this
List<PlayingField> playingFieldFromJson(String str) => List<PlayingField>.from(json.decode(str).map((x) => PlayingField.fromJson(x)));
String playingFieldToJson(List<PlayingField> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlayingField {
    Model model;
    int pk;
    Fields fields;

    PlayingField({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory PlayingField.fromJson(Map<String, dynamic> json) => PlayingField(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String name;
    String address;
    City city;
    String latitude;
    String longitude;
    int numberOfCourts;
    bool hasLights;
    bool hasBackboard;
    CourtSurface courtSurface;
    String pricePerHour;
    String ownerName;
    String ownerContact;
    String ownerBankAccount;
    String openingTime;
    String closingTime;
    String description;
    List<dynamic> amenities;
    String courtImage;
    String imageUrl;
    dynamic createdBy;
    DateTime createdAt;
    DateTime updatedAt;
    bool isActive;

    Fields({
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
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        address: json["address"],
        city: cityValues.map[json["city"]]!,
        latitude: json["latitude"],
        longitude: json["longitude"],
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
    );

    Map<String, dynamic> toJson() => {
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

enum Model {
    BOOKING_PLAYINGFIELD
}

final modelValues = EnumValues({
    "booking.playingfield": Model.BOOKING_PLAYINGFIELD
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
