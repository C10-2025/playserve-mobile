import 'dart:convert';

import 'playing_field.dart';

List<BookingItem> bookingItemFromJson(String str) =>
    List<BookingItem>.from(
        json.decode(str).map((x) => BookingItem.fromJson(x)));

class BookingItem {
  final int id;
  final PlayingFieldSummary field;
  final DateTime bookingDate;
  final String startTime;
  final String endTime;
  final double durationHours;
  final double totalPrice;
  final String status;
  final String notes;
  final bool canCancel;

  BookingItem({
    required this.id,
    required this.field,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.durationHours,
    required this.totalPrice,
    required this.status,
    required this.notes,
    required this.canCancel,
  });

  factory BookingItem.fromJson(Map<String, dynamic> json) => BookingItem(
        id: json["id"],
        field: PlayingFieldSummary.fromJson(json["field"]),
        bookingDate: DateTime.parse(json["booking_date"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        durationHours: (json["duration_hours"] as num).toDouble(),
        totalPrice: (json["total_price"] as num).toDouble(),
        status: json["status"],
        notes: json["notes"] ?? "",
        canCancel: json["can_cancel"] ?? false,
      );
}

class PlayingFieldSummary {
  final int id;
  final String name;
  final String city;
  final String? imageUrl;
  final String? courtImage;

  PlayingFieldSummary({
    required this.id,
    required this.name,
    required this.city,
    required this.imageUrl,
    required this.courtImage,
  });

  factory PlayingFieldSummary.fromJson(Map<String, dynamic> json) =>
      PlayingFieldSummary(
        id: json["id"],
        name: json["name"],
        city: json["city"],
        imageUrl: json["image_url"],
        courtImage: json["court_image"],
      );
}
