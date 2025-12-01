import 'package:flutter/material.dart';
import 'package:playserve_mobile/review/widgets/review_list.dart';
import 'package:playserve_mobile/review/widgets/add_review.dart';
import 'package:playserve_mobile/review/widgets/view_comments.dart';

import 'package:playserve_mobile/review/models/lapangan.dart';
import 'package:playserve_mobile/review/models/review_item.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late List<Lapangan> lapangans;
  late List<ReviewItem> reviews;

  @override
  void initState() {
    super.initState();

    // ===========================================================
    // 1. ORIGINAL LAPANGAN PLACEHOLDERS (UNCHANGED)
    // ===========================================================
    lapangans = [
      Lapangan(
        imageUrl:
            "https://images.unsplash.com/photo-1509021436665-8f07dbf5bf1d?w=600",
        name: "Grand Sports Arena",
        address: "Jakarta Selatan",
        pricePerHour: 150000,
        avgRating: 4.5,
        reviewCount: 12,
      ),
      Lapangan(
        imageUrl:
            "https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=600",
        name: "Sentra Court Center",
        address: "Bandung Kota",
        pricePerHour: 120000,
        avgRating: 4.1,
        reviewCount: 8,
      ),
      Lapangan(
        imageUrl:
            "https://images.unsplash.com/photo-1509718443690-d8e2fb3474b7?w=600",
        name: "Arena Multi Futsal",
        address: "Surabaya Timur",
        pricePerHour: 90000,
        avgRating: 3.8,
        reviewCount: 20,
      ),
    ];

    // ===========================================================
    // 2. ORIGINAL REVIEW *PREVIEW* PLACEHOLDERS,
    //    converted to ReviewItem with lapanganName
    //    (EVERY REVIEW IS PRESERVED EXACTLY)
    // ===========================================================
    reviews = [
      // Reviews for Grand Sports Arena
      ReviewItem(
        username: "andrew",
        rating: 5,
        comment: "Great place to play, clean and well maintained!",
        lapanganName: "Grand Sports Arena",
      ),
      ReviewItem(
        username: "budi",
        rating: 4,
        comment: "Good experience overall, lighting could be better.",
        lapanganName: "Grand Sports Arena",
      ),
      ReviewItem(
        username: "alex",
        rating: 5,
        comment: "Best futsal court!",
        lapanganName: "Grand Sports Arena",
      ),
      ReviewItem(
        username: "dina",
        rating: 4,
        comment: "Good but crowded at night.",
        lapanganName: "Grand Sports Arena",
      ),

      // Reviews for Sentra Court Center
      ReviewItem(
        username: "kelvin",
        rating: 4,
        comment: "Comfortable court and friendly staff.",
        lapanganName: "Sentra Court Center",
      ),
      ReviewItem(
        username: "rani",
        rating: 3,
        comment: "Average facility, parking area is limited.",
        lapanganName: "Sentra Court Center",
      ),
      ReviewItem(
        username: "mike",
        rating: 3,
        comment: "Could improve lighting.",
        lapanganName: "Sentra Court Center",
      ),

      // Reviews for Arena Multi Futsal
      ReviewItem(
        username: "dimas",
        rating: 4,
        comment: "Affordable and decent quality.",
        lapanganName: "Arena Multi Futsal",
      ),
      ReviewItem(
        username: "yohan",
        rating: 3,
        comment: "Gets crowded on weekends but still okay.",
        lapanganName: "Arena Multi Futsal",
      ),
      ReviewItem(
        username: "fajar",
        rating: 4,
        comment: "Cheap and good!",
        lapanganName: "Arena Multi Futsal",
      ),
      ReviewItem(
        username: "kevin",
        rating: 3,
        comment: "Okay but a bit hot inside.",
        lapanganName: "Arena Multi Futsal",
      ),
    ];
  }

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
                lapangans: lapangans,
                allReviews: reviews,

                // ===========================================================
                // Add Review Button → opens modal
                // ===========================================================
                onAddReview: (lap) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => AddReviewModal(
                      courtName: lap.name,
                      onSubmit: (rating, comment) {
                        setState(() {
                          reviews.insert(
                            0,
                            ReviewItem(
                              username: "You",
                              rating: rating,
                              comment: comment,
                              lapanganName: lap.name,
                            ),
                          );
                        });
                      },
                    ),
                  );
                },

                // ===========================================================
                // View Comments Button → open modal with filtered results
                // ===========================================================
                onViewComments: (lap) {
                  final filtered = reviews
                      .where((r) => r.lapanganName == lap.name)
                      .toList();

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => ViewCommentsModal(
                      courtName: lap.name,
                      address: lap.address,
                      pricePerHour: lap.pricePerHour,
                      reviews: filtered,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
