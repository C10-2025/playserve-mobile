import 'package:flutter/material.dart';

class AddReviewModal extends StatefulWidget {
  final String courtName;
  final Function(int rating, String comment) onSubmit;

  const AddReviewModal({
    super.key,
    required this.courtName,
    required this.onSubmit,
  });

  @override
  State<AddReviewModal> createState() => _AddReviewModalState();
}

class _AddReviewModalState extends State<AddReviewModal> {
  int rating = 0;
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dim Overlay
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.4),
          ),
        ),

        Center(
          child: Material( // <-- FIX (Material ancestor)
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.90,
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD6E8C5), width: 2),
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
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 26),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  const SizedBox(height: 6),
                  const Text(
                    "LEAVE A RATING & REVIEW",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A2B4C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Share your experience at ${widget.courtName}",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF4C5C7C),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      final val = i + 1;
                      return IconButton(
                        icon: Icon(
                          Icons.star,
                          color: val <= rating
                              ? const Color(0xFFB0D235)
                              : Colors.grey.shade400,
                          size: 28,
                        ),
                        onPressed: () => setState(() => rating = val),
                      );
                    }),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: commentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Write your comments here...",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFE0E0E0),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  ElevatedButton(
                    onPressed: () {
                      widget.onSubmit(rating, commentController.text.trim());
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB0D235),
                      foregroundColor: const Color(0xFF1A2B4C),
                      minimumSize: const Size(double.infinity, 46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "SUBMIT REVIEW",
                      style: TextStyle(fontSize: 15),
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
