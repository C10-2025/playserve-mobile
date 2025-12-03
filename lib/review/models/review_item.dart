import 'dart:convert';
// To parse this JSON data, do
//
//     final reviewItem = reviewItemFromJson(jsonString);

// Indvidual review item, corresponds to the Review model at Django app
List<ReviewItemNew> reviewItemNewFromJson(String str) => List<ReviewItemNew>.from(json.decode(str).map((x) => ReviewItemNew.fromJson(x)));
String reviewItemNewToJson(List<ReviewItemNew> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewItemNew {
    String username;
    int rating;
    String comment;
    String fieldName;

    ReviewItemNew({
        required this.username,
        required this.rating,
        required this.comment,
        required this.fieldName,
    });

    factory ReviewItemNew.fromJson(Map<String, dynamic> json) => ReviewItemNew(
        username: json["username"],
        rating: json["rating"],
        comment: json["comment"],
        fieldName: json["fieldName"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "rating": rating,
        "comment": comment,
        "fieldName": fieldName,
    };
}