import 'package:flutter/material.dart';
import 'package:playserve_mobile/review/widgets/review_list.dart';
import 'package:playserve_mobile/review/widgets/add_review.dart';
import 'package:playserve_mobile/review/widgets/view_comments.dart';
import 'package:playserve_mobile/review/models/lapangan.dart';
import 'package:playserve_mobile/review/models/review_preview.dart';
import 'package:playserve_mobile/review/models/review_item.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {

  // Actual Page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF1A2B4C),
            child: Center(
              child: ReviewList(
                reviews: _placeholderItems(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // === THREE PLACEHOLDER ITEMS ===
  List<Lapangan> _placeholderItems() {
    return [
      // ===========================================================
      // ITEM 1
      // ===========================================================
      Lapangan(
        imageUrl:
            "https://images.unsplash.com/photo-1509021436665-8f07dbf5bf1d?w=600",
        name: "Grand Sports Arena",
        address: "Jakarta Selatan",
        pricePerHour: 150000,
        avgRating: 4.5,
        reviewCount: 12,
        latestReviews: [
          ReviewPreview(
              rating: 5,
              username: "andrew",
              comment: "Great place to play, clean and well maintained!"),
          ReviewPreview(
              rating: 4,
              username: "budi",
              comment: "Good experience overall, lighting could be better."),
        ],
        onAddReview: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AddReviewModal(
              courtName: "Grand Sports Arena",
              onSubmit: (rating, comment) {
                debugPrint("Submitted review for GSA → rating: $rating, comment: $comment");
              },
            ),
          );
        },
        onViewComments: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => ViewCommentsModal(
              courtName: "Grand Sports Arena",
              address: "Jakarta Selatan",
              pricePerHour: 150000,
              reviews: [
                ReviewItem(username: "alex", rating: 5, comment: "Best futsal court!"),
                ReviewItem(username: "dina", rating: 4, comment: "Good but crowded at night."),
              ],
            ),
          );
        },
      ),

      // ===========================================================
      // ITEM 2
      // ===========================================================
      Lapangan(
        imageUrl:
            "https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=600",
        name: "Sentra Court Center",
        address: "Bandung Kota",
        pricePerHour: 120000,
        avgRating: 4.1,
        reviewCount: 8,
        latestReviews: [
          ReviewPreview(
            rating: 4,
            username: "kelvin",
            comment: "Comfortable court and friendly staff.",
          ),
          ReviewPreview(
            rating: 3,
            username: "rani",
            comment: "Average facility, parking area is limited.",
          ),
        ],
        onAddReview: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AddReviewModal(
              courtName: "Sentra Court Center",
              onSubmit: (rating, comment) {
                debugPrint("Submitted review for SCC → rating: $rating, comment: $comment");
              },
            ),
          );
        },
        onViewComments: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => ViewCommentsModal(
              courtName: "Sentra Court Center",
              address: "Bandung Kota",
              pricePerHour: 120000,
              reviews: [
                ReviewItem(username: "kelvin", rating: 4, comment: "Affordable and comfy."),
                ReviewItem(username: "mike", rating: 3, comment: "Could improve lighting."),
              ],
            ),
          );
        },
      ),

      // ===========================================================
      // ITEM 3
      // ===========================================================
      Lapangan(
        imageUrl:
            "https://images.unsplash.com/photo-1509718443690-d8e2fb3474b7?w=600",
        name: "Arena Multi Futsal",
        address: "Surabaya Timur",
        pricePerHour: 90000,
        avgRating: 3.8,
        reviewCount: 20,
        latestReviews: [
          ReviewPreview(
              rating: 4,
              username: "dimas",
              comment: "Affordable and decent quality."),
          ReviewPreview(
              rating: 3,
              username: "yohan",
              comment: "Gets crowded on weekends but still okay."),
        ],
        onAddReview: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AddReviewModal(
              courtName: "Arena Multi Futsal",
              onSubmit: (rating, comment) {
                debugPrint("Submitted review for AMF → rating: $rating, comment: $comment");
              },
            ),
          );
        },
        onViewComments: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => ViewCommentsModal(
              courtName: "Arena Multi Futsal",
              address: "Surabaya Timur",
              pricePerHour: 90000,
              reviews: [
                ReviewItem(username: "fajar", rating: 4, comment: "Cheap and good!"),
                ReviewItem(username: "kevin", rating: 3, comment: "Okay but a bit hot inside."),
              ],
            ),
          );
        },
      ),
    ];
  }
}
