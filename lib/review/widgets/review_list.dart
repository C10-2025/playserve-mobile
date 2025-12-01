import 'package:flutter/material.dart';
import 'package:playserve_mobile/review/models/lapangan.dart';
import 'package:playserve_mobile/review/models/review_item.dart';
import 'package:playserve_mobile/review/models/review_card.dart';

// The main widget; list of all reviews
class ReviewList extends StatelessWidget {
  final List<Lapangan> lapangans;
  final List<ReviewItem> allReviews;
  final Function(Lapangan) onAddReview;
  final Function(Lapangan) onViewComments;

  const ReviewList({
    super.key,
    required this.lapangans,
    required this.allReviews,
    required this.onAddReview,
    required this.onViewComments,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: width > 1100 ? 1100 : width,
        height: MediaQuery.of(context).size.height * 0.90,

        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),

        decoration: BoxDecoration(
          color: const Color(0xFF1A2B4C),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 22,
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===========================================================
            // HEADER (like Django review-header)
            // ===========================================================
            Text(
              "Court Reviews",
              style: TextStyle(
                fontSize: width < 360 ? 18 : 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 6),

            Container(
              height: 3,
              width: 140,
              decoration: BoxDecoration(
                color: const Color(0xFFB0D235),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 20),

            // ===========================================================
            // SCROLLABLE REVIEW LIST (like Django review-content)
            // ===========================================================
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(right: 4),
                itemCount: lapangans.length,
                itemBuilder: (context, index) {
                  final lap = lapangans[index];

                  return ReviewCard(
                    lapangan: lap,
                    allReviews: allReviews,
                    onAddReview: () => onAddReview(lap),
                    onViewComments: () => onViewComments(lap),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
