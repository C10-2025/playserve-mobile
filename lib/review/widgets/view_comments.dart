import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:playserve_mobile/review/models/review_item.dart'; // contains ReviewItemNew

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

  Future<void> _deleteReview(BuildContext context, ReviewItemNew review) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text('Are you sure you want to delete this comment permanently?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm != true) return;

    final request = context.read<CookieRequest>();
    const url = 'http://127.0.0.1:8000/review/delete-review-flutter/';

    try {
      final response = await request.post(
        url,
        jsonEncode({'username': review.username, 'field_name': review.fieldName}),
      );

      if (!context.mounted) return;

      if (response['status'] == 'success') {
        Navigator.pop(context); // close modal
        onRefresh();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete comment: ${response['message'] ?? ''}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final modalWidth = (screenW < 520 ? screenW * 0.96 : 520.0);

    return Stack(
      children: [
        GestureDetector(onTap: () => Navigator.pop(context), child: Container(color: Colors.black.withOpacity(0.4))),
        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: modalWidth,
              constraints: const BoxConstraints(maxHeight: 520),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFD6E8C5), width: 2),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.16), blurRadius: 18)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(alignment: Alignment.topRight, child: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))),
                  Text('Comments for $courtName', style: const TextStyle(fontSize: 16, color: Color(0xFF1A2B4C))),
                  const SizedBox(height: 6),
                  Text('$address • Rp ${pricePerHour.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, color: Color(0xFF445566))),
                  const SizedBox(height: 12),
                  Expanded(
                    child: reviews.isNotEmpty
                        ? ListView.separated(
                            itemCount: reviews.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, i) {
                              final r = reviews[i];
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(10)),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(r.username, style: const TextStyle(fontSize: 13, color: Color(0xFF1A2B4C))),
                                  const SizedBox(height: 4),
                                  Text('${"★" * r.rating}${"☆" * (5 - r.rating)}', style: const TextStyle(color: Colors.amber, fontSize: 14)),
                                  const SizedBox(height: 6),
                                  Text(r.comment, style: const TextStyle(fontSize: 13, color: Color(0xFF1A2B4C))),
                                  const SizedBox(height: 8),
                                  if (isAdmin)
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () => _deleteReview(context, r),
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                                        child: const Text('Delete Comment'),
                                      ),
                                    ),
                                ]),
                              );
                            },
                          )
                        : const Center(child: Text('No comments yet for this field.', style: TextStyle(color: Colors.grey))),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
