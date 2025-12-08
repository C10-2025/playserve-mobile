import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:playserve_mobile/review/models/review_item.dart'; 

class ViewCommentsModal extends StatelessWidget {
  final String courtName;
  final String address;
  final double pricePerHour;
  final List<ReviewItemNew> reviews;
  final bool isAdmin;
  final VoidCallback onRefresh;

  const ViewCommentsModal({
    super.key,
    required this.courtName,
    required this.address,
    required this.pricePerHour,
    required this.reviews,
    required this.isAdmin,
    required this.onRefresh,
  });

  // Deleting procedure
  Future<void> _deleteReview(BuildContext context, ReviewItemNew review, CookieRequest request) async {
    // User confirmation prompt dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Comment"),
        content:
            const Text("Are you sure you want to delete this comment permanently?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    // Send delete request to backend if confirmed
    if (confirm != true) return;

    const url = "http://127.0.0.1:8000/review/delete-review-flutter/";

    // NOTE: best practice is to add a content type header, but json.loads()
    // Work regardless of content type
    final response = await request.post(
      url,
      jsonEncode({
        "username": review.username,
        "field_name": review.fieldName,
      }),
    );

    if (!context.mounted) return;

    if (response["status"] == "success") {
      Navigator.pop(context); // close modal
      onRefresh(); // reload parent
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete comment. ${response['message'] ?? ''}"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double modalWidth =
        (screenWidth < 500 ? screenWidth * 0.9 : 480.0).toDouble();

    final CookieRequest request = context.watch<CookieRequest>();

    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(color: Colors.black.withOpacity(0.4)),
        ),
        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: modalWidth,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFD6E8C5), width: 2),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.20), blurRadius: 24)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Text(
                    "Comments for $courtName",
                    style: const TextStyle(fontSize: 16, color: Color(0xFF1A2B4C)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Address: $address • Price: Rp $pricePerHour",
                    style: const TextStyle(fontSize: 12, color: Color(0xFF445566)),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 380,
                    child: reviews.isNotEmpty
                        ? ListView.separated(
                            itemCount: reviews.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, i) {
                              final r = reviews[i];
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
                                      style: const TextStyle(fontSize: 13, color: Color(0xFF1A2B4C)),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      "★" * r.rating + "☆" * (5 - r.rating),
                                      style: const TextStyle(fontSize: 14, color: Colors.amber),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      r.comment,
                                      style: const TextStyle(fontSize: 13, color: Color(0xFF1A2B4C)),
                                    ),
                                    const SizedBox(height: 10),
                                    if (isAdmin)
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () => _deleteReview(context, r, request),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text("Delete Comment"),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text("No comments yet for this field.", style: TextStyle(color: Colors.grey)),
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
