import 'package:flutter/material.dart';
import 'package:playserve_mobile/review/models/review_item.dart'; // ReviewItemNew

class ViewCommentsModal extends StatelessWidget {
  final String courtName;
  final String address;
  final int pricePerHour;
  final List<ReviewItemNew> reviews;

  const ViewCommentsModal({
    super.key,
    required this.courtName,
    required this.address,
    required this.pricePerHour,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // ensure it becomes a double
    final double modalWidth =
        (width < 420 ? width * 0.90 : 380).toDouble();

    final double modalHeight =
        (width < 420 ? MediaQuery.of(context).size.height * 0.70 : 480)
            .toDouble();

    return Stack(
      children: [
        // Dim background
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Colors.black54,
          ),
        ),

        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: modalWidth,
              height: modalHeight,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD6E8C5), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 22,
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Close button
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  // Title
                  Text(
                    "Comments for $courtName",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF1A2B4C),
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    "$address • Rp $pricePerHour",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF445566),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Comments list
                  Expanded(
                    child: reviews.isEmpty
                        ? const Center(
                            child: Text(
                              "No comments yet for this field.",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: reviews.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (_, i) {
                              final r = reviews[i];
                              // Comment item 
                              return Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F7F7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      r.username,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF1A2B4C),
                                      ),
                                    ),

                                    const SizedBox(height: 2),

                                    Text(
                                      "★" * r.rating +
                                          "☆" * (5 - r.rating),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.amber,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      r.comment,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF1A2B4C),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
