import 'package:flutter/material.dart';
import 'package:playserve_mobile/review/models/playing_field_item.dart'; // PlayingFieldItem
import 'package:playserve_mobile/review/models/review_item.dart'; // ReviewItemNew

// Correspond to the Review Content of the django review_list template
// A card that give a short overview and the reviews of a field in review_list
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
    // Filter reviews by fieldName
    final relatedReviews = allReviews
        .where((r) => r.fieldName == field.name)
        .toList();

    // Get newest 2 reviews
    final latest = relatedReviews.take(2).toList();
    
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 380;

    return Container(
      margin: const EdgeInsets.only(bottom: 28),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOP ROW 
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (field.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    field.imageUrl, // NOTE: only works for certain domains which allow direct taking from frontends
                    width: isSmall ? 60 : 80,
                    height: isSmall ? 60 : 80,
                    fit: BoxFit.cover,

                    // Fallback for blocked images
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        "https://images.unsplash.com/photo-1547934045-2942d193cb49?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1176",
                        width: isSmall ? 60 : 80,
                        height: isSmall ? 60 : 80,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      field.name,
                      style: TextStyle(
                        fontSize: isSmall ? 15 : 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A2B4C),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${field.address} • Rp ${field.pricePerHour}",
                      style: TextStyle(
                        fontSize: isSmall ? 12 : 14,
                        color: const Color(0xFF445566),
                      ),
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

          const SizedBox(height: 18),

          // BUTTONS 
          Row(
            children: [
              ElevatedButton(
                onPressed: onAddReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB0D235),
                  foregroundColor: const Color(0xFF1A2B4C),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                ),
                child: const Text("Add Review"),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: onViewComments,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFD6E8C5)),
                  foregroundColor: const Color(0xFF1A2B4C),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                ),
                child: const Text("View Comments"),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // PREVIEW 
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(14),
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
                      const SizedBox(height: 6),
                      ...latest.map((r) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            "${"★" * r.rating}${"☆" * (5 - r.rating)} — ${r.username}: ${r.comment}",
                            style: const TextStyle(fontSize: 13),
                          ),
                        );
                      }),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
