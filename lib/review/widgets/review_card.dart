import 'package:flutter/material.dart';
import 'package:playserve_mobile/booking/models/playing_field.dart';
import 'package:playserve_mobile/review/models/review_item.dart';

class ReviewCard extends StatelessWidget {
  final PlayingField field;
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
    final isSmall = width < 360;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 6,
            offset: const Offset(0, 2),
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
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      field.name,
                      style: TextStyle(
                        fontSize: isSmall ? 14 : 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A2B4C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${field.address} • Rp ${field.pricePerHour.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: isSmall ? 11 : 12,
                        color: const Color(0xFF445566),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '★ ${avgRating.toStringAsFixed(1)} • $reviewCount reviews',
                      style: TextStyle(
                        fontSize: isSmall ? 11 : 12,
                        color: const Color(0xFF1A2B4C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

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
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,   
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
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,   
                    ),
                  ),
                  child: const Text("View Comments"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          // ================== PREVIEW AREA ==================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: latest.isEmpty
                ? const Text(
                    "No reviews yet.",
                    style: TextStyle(
                      color: Color(0xFF1A2B4C),
                      fontSize: 12,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Latest reviews:",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1A2B4C),
                        ),
                      ),
                      const SizedBox(height: 6),
                      ...latest.map((r) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            "${"★" * r.rating}${"☆" * (5 - r.rating)} — ${r.username}: ${r.comment}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1A2B4C),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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

  // ================== IMAGE ==================
  Widget _buildImage(bool small) {
    final size = small ? 54.0 : 66.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        field.imageUrl ?? "",
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.network(
          "https://images.unsplash.com/photo-1547934045-2942d193cb49",
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
