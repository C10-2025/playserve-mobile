import 'package:flutter/material.dart';
import 'package:playserve_mobile/review/models/review_item.dart';

class ViewCommentsModal extends StatelessWidget {
  final String courtName;
  final String address;
  final int pricePerHour;
  final List<ReviewItem> reviews; // NOTE: view_comments' job is to view the comments of all reviews

  const ViewCommentsModal({
    super.key,
    required this.courtName,
    required this.address,
    required this.pricePerHour,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    final double modalWidth = MediaQuery.of(context).size.width * 0.92;
    final double modalHeight = MediaQuery.of(context).size.height * 0.65;

    return Stack(
      children: [
        // Dim background overlay
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.4),
          ),
        ),

        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: modalWidth,
              constraints: const BoxConstraints(maxWidth: 480),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xFFD6E8C5), width: 2),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.20),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Close button
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 24),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  // Title
                  Text(
                    "Comments for $courtName",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1A2B4C),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Subtitle
                  Text(
                    "Address: $address • Price: Rp $pricePerHour",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF445566),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // Scrollable comments
                  SizedBox(
                    height: modalHeight,
                    child: reviews.isNotEmpty
                        ? ListView.separated(
                            itemCount: reviews.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, i) {
                              final r = reviews[i];
                              return Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F7F7),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Username
                                    Text(
                                      r.username,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF1A2B4C),
                                      ),
                                    ),

                                    const SizedBox(height: 3),

                                    // Stars
                                    Text(
                                      "★" * r.rating +
                                          "☆" * (5 - r.rating),
                                      style: const TextStyle(
                                        color: Colors.amber,
                                        fontSize: 14,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    // Comment text
                                    Text(
                                      r.comment,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF1A2B4C),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              "No comments yet for this field.",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
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
