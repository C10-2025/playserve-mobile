import 'package:flutter/material.dart';
import 'package:playserve_mobile/review/models/lapangan.dart';
import 'package:playserve_mobile/review/models/review_item.dart';

// Corresponds to Review content part of review_list.html, moved here because it's quite lengthy
// === Review/Comment card ===
class ReviewCard extends StatelessWidget {
  final Lapangan lapangan;
  final List<ReviewItem> allReviews; // full list from ReviewPage
  final VoidCallback onAddReview;
  final VoidCallback onViewComments;

  const ReviewCard({
    super.key,
    required this.lapangan,
    required this.allReviews,
    required this.onAddReview,
    required this.onViewComments,
  });

  @override
  Widget build(BuildContext context) {
    // Filter reviews belonging to this lapangan
    final relatedReviews = allReviews
        .where((r) => r.lapanganName == lapangan.name)
        .toList();

    // Get newest 2 reviews
    final latest = relatedReviews.take(2).toList();

    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 360;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Info Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (lapangan.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    lapangan.imageUrl!,
                    width: isSmall ? 60 : 80,
                    height: isSmall ? 60 : 80,
                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lapangan.name,
                      style: TextStyle(
                        fontSize: isSmall ? 14 : 17,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A2B4C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${lapangan.address} • Rp ${lapangan.pricePerHour}",
                      style: TextStyle(
                        fontSize: isSmall ? 11 : 13,
                        color: const Color(0xFF445566),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Avg rating: ${lapangan.avgRating} • Reviews: ${lapangan.reviewCount}",
                      style: TextStyle(
                        fontSize: isSmall ? 11 : 13,
                        color: const Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: onAddReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB0D235),
                  foregroundColor: const Color(0xFF1A2B4C),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                ),
                child: const Text("Add Review"),
              ),
              OutlinedButton(
                onPressed: onViewComments,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFD6E8C5)),
                  foregroundColor: const Color(0xFF1A2B4C),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                ),
                child: const Text("View Comments"),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Latest reviews preview
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(12),
            child: latest.isEmpty
                ? const Text(
                    "No reviews yet.",
                    style: TextStyle(color: Color(0xFF777777)),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Latest reviews:",
                        style: TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 6),

                      ...latest.map((r) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            "${"★" * r.rating}${"☆" * (5 - r.rating)} — ${r.username}: ${r.comment}",
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
