import 'package:flutter/material.dart';
import 'package:playserve_mobile/review/models/playing_field_item.dart';
import 'package:playserve_mobile/review/models/review_item.dart';

class ReviewCard extends StatelessWidget {
  final PlayingFieldItem field;
  final List<ReviewItemNew> allReviews;
  final VoidCallback onAddReview;
  final VoidCallback onViewComments;
  final double avgRating;
  final int reviewCount;

  const ReviewCard({
    super.key,
    required this.field,
    required this.allReviews,
    required this.onAddReview,
    required this.onViewComments,
    required this.avgRating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    final relatedReviews =
        allReviews.where((r) => r.fieldName == field.name).toList();
    final latest = relatedReviews.take(2).toList();

    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 380;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
      margin: const EdgeInsets.only(bottom: 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ================== TOP ROW ==================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(isSmall),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Field Name
                    Text(
                      field.name,
                      style: TextStyle(
                        fontSize: isSmall ? 15 : 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A2B4C),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "${field.address} • Rp ${field.pricePerHour}",
                      style: TextStyle(
                        fontSize: isSmall ? 12 : 14,
                        color: const Color(0xFF445566),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Avg rating: ${avgRating.toStringAsFixed(1)} • Reviews: $reviewCount",
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

          const SizedBox(height: 20),

          // ================== BUTTONS ==================
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onAddReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB0D235),
                    foregroundColor: const Color(0xFF1A2B4C),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Add Review"),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: OutlinedButton(
                  onPressed: onViewComments,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFD6E8C5), width: 2),
                    foregroundColor: const Color(0xFF1A2B4C),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("View Comments"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ================== PREVIEW ==================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(10),
            ),
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
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),

                      ...latest.map(
                        (r) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            "★" * r.rating + "☆" * (5 - r.rating) +
                                " — ${r.username}: ${r.comment}",
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // ================== IMAGE BUILDER ==================
  Widget _buildImage(bool isSmall) {
    final size = isSmall ? 60.0 : 80.0;

    if (field.imageUrl.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        field.imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, _, __) {
          return Image.network(
            "https://images.unsplash.com/photo-1547934045-2942d193cb49",
            width: size,
            height: size,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
