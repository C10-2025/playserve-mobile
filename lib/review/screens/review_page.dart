import 'package:flutter/material.dart';
import 'package:playserve_mobile/review/widgets/review_list.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {

    // === Placeholder Data ===
    final List<ReviewItem> dummyItems = [
      ReviewItem(
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
            comment: "Great place to play, clean and well maintained!",
          ),
          ReviewPreview(
            rating: 4,
            username: "budi",
            comment: "Good experience overall, lighting could be better.",
          ),
        ],
        onAddReview: () {
          debugPrint("Add review for Grand Sports Arena");
        },
        onViewComments: () {
          debugPrint("View comments for Grand Sports Arena");
        },
      ),

      // --- ITEM 2 ---
      ReviewItem(
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
            comment: "Comfortable court, staff were friendly.",
          ),
          ReviewPreview(
            rating: 3,
            username: "rani",
            comment: "Average facility, parking area is limited.",
          ),
        ],
        onAddReview: () {
          debugPrint("Add review for Sentra Court Center");
        },
        onViewComments: () {
          debugPrint("View comments for Sentra Court Center");
        },
      ),

      // --- ITEM 3 ---
      ReviewItem(
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
            comment: "Affordable and decent quality.",
          ),
          ReviewPreview(
            rating: 3,
            username: "yohan",
            comment: "Gets crowded on weekends but still okay.",
          ),
        ],
        onAddReview: () {
          debugPrint("Add review for Arena Multi Futsal");
        },
        onViewComments: () {
          debugPrint("View comments for Arena Multi Futsal");
        },
      ),
    ];

    // Actual page
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF1A2B4C),
        child: Center(
          child: ReviewList(
            reviews: dummyItems,
          ),
        ),
      ),
    );
  }
}
