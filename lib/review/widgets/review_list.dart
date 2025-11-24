import 'package:flutter/material.dart';

// Corresponds to the review_list.html at the web version
// === Review list ===
class ReviewList extends StatelessWidget {
  final List<ReviewItem> reviews;

  const ReviewList({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.topCenter,
      child: Container(
        width: 1100,
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 42),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2B4C),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 28,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Court Reviews",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 3,
                  width: 160,
                  decoration: BoxDecoration(
                    color: Color(0xFFB0D235),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Scrollable list
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  children: reviews.map((item) {
                    return ReviewCard(
                      imageUrl: item.imageUrl,
                      name: item.name,
                      address: item.address,
                      pricePerHour: item.pricePerHour,
                      avgRating: item.avgRating,
                      reviewCount: item.reviewCount,
                      latestReviews: item.latestReviews,
                      onAddReview: item.onAddReview,
                      onViewComments: item.onViewComments,
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder to the court model at the web
class ReviewItem {
  final String? imageUrl;
  final String name;
  final String address;
  final int pricePerHour;
  final double avgRating;
  final int reviewCount;
  final List<ReviewPreview> latestReviews;

  final VoidCallback onAddReview;
  final VoidCallback onViewComments;

  ReviewItem({
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


// Corresponds to Review content part of review_list.html
// === Review/Comment card ===
class ReviewCard extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final String address;
  final int pricePerHour;
  final double avgRating;
  final int reviewCount;
  final List<ReviewPreview> latestReviews;
  final VoidCallback onAddReview;
  final VoidCallback onViewComments;

  const ReviewCard({
    super.key,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 28),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xFF1A2B4C),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "$address • Rp $pricePerHour",
                      style: const TextStyle(color: Color(0xFF445566)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Avg rating: ${avgRating.toStringAsFixed(1)} • Reviews: $reviewCount",
                      style: const TextStyle(color: Color(0xFF333333)),
                    ),
                  ],
                ),
              ),

              Row(
                children: [
                  ElevatedButton(
                    onPressed: onAddReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB0D235),
                      foregroundColor: const Color(0xFF1A2B4C),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Add Review"),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: onViewComments,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFD6E8C5)),
                      foregroundColor: const Color(0xFF1A2B4C),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("View Comments"),
                  ),
                ],
              )
            ],
          ),

          const SizedBox(height: 12),

          // Latest review preview
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Latest reviews preview:",
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),

                latestReviews.isNotEmpty
                    ? Column(
                        children: latestReviews
                            .map((r) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    children: [
                                      Text(
                                        "★" * r.rating + "☆" * (5 - r.rating),
                                        style: const TextStyle(color: Colors.orange),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "— ${r.username}: ${r.comment}",
                                        style: const TextStyle(color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      )
                    : const Text(
                        "No reviews yet.",
                        style: TextStyle(color: Color(0xFF777777)),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewPreview {
  final int rating;
  final String username;
  final String comment;

  ReviewPreview({
    required this.rating,
    required this.username,
    required this.comment,
  });
}


