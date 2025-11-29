import 'dart:convert';
import 'package:playserve_mobile/review/models/lapangan.dart';

// Review model. Corresponds to the class Review at the django module
// TODO: deprecate this
class ReviewItem {
  final String username;
  final int rating;
  final String comment;

  ReviewItem({
    required this.username,
    required this.rating,
    required this.comment,
  });
}

// To parse this JSON data, do
//
//     final reviewItem = reviewItemFromJson(jsonString);
// TODO: integrate this
List<ReviewItemNew> reviewItemNewFromJson(String str) => List<ReviewItemNew>.from(json.decode(str).map((x) => ReviewItemNew.fromJson(x)));
String reviewItemNewToJson(List<ReviewItemNew> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewItemNew {
    String model;
    int pk;
    Fields fields;

    ReviewItemNew({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory ReviewItemNew.fromJson(Map<String, dynamic> json) => ReviewItemNew(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}